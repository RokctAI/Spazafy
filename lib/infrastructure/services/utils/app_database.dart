import 'package:rokctapp/infrastructure/models/data/manager/table_bookings_data.dart';
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';
import 'drift_tables.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ProductsTable,
    StocksTable,
    EventQueueTable,
    OrdersTable,
    OrderItemsTable,
    ShopTable,
    CategoriesTable,
    SettingsTable,
    BillingCartTable,
    SyncQueueTable,
    AbandonedSyncQueueTable,
    UserTable,
    BannersTable,
    NotificationsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(syncQueueTable);
        }
        if (from < 3) {
          // Flattening Migration
          await m.addColumn(productsTable, productsTable.title);
          await m.addColumn(productsTable, productsTable.barcode);
          await m.addColumn(productsTable, productsTable.categoryId);
          await m.addColumn(productsTable, productsTable.active);
          await m.addColumn(productsTable, productsTable.img);
          await m.addColumn(productsTable, productsTable.unitId);
          await m.addColumn(productsTable, productsTable.isPack);
          await m.addColumn(productsTable, productsTable.parentId);

          await m.createTable(stocksTable);
          await m.createTable(eventQueueTable);

          // Data Migration: Extract data from blobs into new columns
          final products = await select(productsTable).get();
          for (final product in products) {
            try {
              final Map<String, dynamic> data = jsonDecode(product.data);
              await (update(
                productsTable,
              )..where((t) => t.id.equals(product.id))).write(
                ProductsTableCompanion(
                  title: Value(data['title']),
                  barcode: Value(data['bar_code'] ?? data['barcode']),
                  categoryId: Value(data['category_id']?.toString()),
                  active: Value(data['active'] ?? true),
                  img: Value(data['img']),
                  unitId: Value(data['unit_id']?.toString()),
                ),
              );
            } catch (e) {
              // Skip if invalid JSON or missing fields
            }
          }
        }
        if (from < 4) {
          // Orders Flattening Migration
          await m.addColumn(ordersTable, ordersTable.shopId);
          await m.addColumn(ordersTable, ordersTable.totalPrice);
          await m.addColumn(ordersTable, ordersTable.totalCost);
          await m.addColumn(ordersTable, ordersTable.status);
          await m.addColumn(ordersTable, ordersTable.paymentType);
          await m.addColumn(ordersTable, ordersTable.createdAt);
          await m.addColumn(ordersTable, ordersTable.synced);

          await m.createTable(orderItemsTable);
        }
        if (from < 5) {
          await m.createTable(userTable);
        }
        if (from < 6) {
          await m.createTable(bannersTable);
        }
        if (from < 7) {
          await m.addColumn(syncQueueTable, syncQueueTable.retryCount);
        }
        if (from < 8) {
          await m.createTable(abandonedSyncQueueTable);
        }
        if (from < 9) {
          await m.createTable(notificationsTable);
        }
        if (from < 10) {
          await m.addColumn(syncQueueTable, syncQueueTable.lastError);
        }
      },
    );
  }

  // Generic getter to abstract out Drift Tables
  TableInfo<Table, dynamic> getTable(String boxName) {
    switch (boxName) {
      case 'products':
        return productsTable;
      case 'orders':
        return ordersTable;
      case 'shop':
        return shopTable;
      case 'categories':
        return categoriesTable;
      case 'settings':
        return settingsTable;
      case 'billing_cart':
        return billingCartTable;
      case 'stocks':
        return stocksTable;
      case 'events':
        return eventQueueTable;
      case 'banners':
        return bannersTable;
      case 'notifications':
        return notificationsTable;
      default:
        throw ArgumentError('Unknown box name: $boxName');
    }
  }

  // ─── Generic CRUD helpers to replace HiveDatabase ───

  /// Save a JSON-serializable item by key.
  Future<void> putItem(
    String boxName,
    String key,
    Map<String, dynamic> json,
  ) async {
    final table = getTable(boxName);
    final dataString = jsonEncode(json);

    await into(
      table,
    ).insertOnConflictUpdate(_createInsertable(boxName, key, dataString));
  }

  /// Get an item as Map by key.
  Future<Map<String, dynamic>?> getItem(String boxName, String key) async {
    final table = getTable(boxName);

    final query = select(table)
      ..where((tbl) {
        return _idColumn(table).equals(key);
      });
    final result = await query.getSingleOrNull();

    if (result == null) return null;

    final dataString = _dataColumn(result);
    return jsonDecode(dataString) as Map<String, dynamic>;
  }

  /// Get all items from a box as a list of Maps.
  Future<List<Map<String, dynamic>>> getAll(String boxName) async {
    final table = getTable(boxName);

    final results = await select(table).get();
    return results.map((result) {
      final dataString = _dataColumn(result);
      return jsonDecode(dataString) as Map<String, dynamic>;
    }).toList();
  }

  /// Delete an item by key.
  Future<void> deleteItem(String boxName, String key) async {
    final table = getTable(boxName);
    await (delete(table)..where((tbl) {
          return _idColumn(table).equals(key);
        }))
        .go();
  }

  /// Clear all items in a box.
  Future<int> clearBox(String boxName) async {
    final table = getTable(boxName);
    return delete(table).go();
  }

  // ─── Sync Queue Helpers ───
  Future<int> insertSyncRequest(SyncQueueTableCompanion request) {
    return into(syncQueueTable).insert(request);
  }

  Future<int> enqueueSyncRequest({
    required String url,
    required String method,
    required Map<String, dynamic> payload,
  }) {
    return insertSyncRequest(
      SyncQueueTableCompanion.insert(
        id: Value(const Uuid().v4()),
        url: url,
        method: method,
        payload: jsonEncode(payload),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<List<SyncQueueEntity>> getPendingSyncRequests() {
    return (select(syncQueueTable)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
        ]))
        .get();
  }

  Future<void> removeSyncRequest(String id) {
    return (delete(syncQueueTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> abandonSyncRequest(
    SyncQueueEntity request, {
    String? error,
  }) async {
    await transaction(() async {
      // 1. Insert into abandoned table
      await into(abandonedSyncQueueTable).insert(
        AbandonedSyncQueueTableCompanion.insert(
          id: request.id,
          url: request.url,
          method: request.method,
          payload: request.payload,
          createdAt: request.createdAt,
          abandonedAt: DateTime.now(),
          lastError: Value(error),
        ),
      );
      // 2. Remove from active queue
      await removeSyncRequest(request.id);
    });
  }

  Future<List<SyncQueueEntity>> getSyncRequestsByMethod(String method) {
    return (select(
      syncQueueTable,
    )..where((t) => t.method.equals(method))).get();
  }

  Future<void> incrementSyncRetry(String id, {String? error}) async {
    final query = select(syncQueueTable)..where((t) => t.id.equals(id));
    final request = await query.getSingleOrNull();
    if (request != null) {
      await (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
        SyncQueueTableCompanion(
          retryCount: Value(request.retryCount + 1),
          lastError: Value(error),
        ),
      );
    }
  }

  // ─── High-Quality Product Helpers ───

  /// Search products locally using flattened columns
  Future<List<ProductEntity>> searchProducts({
    String? query,
    String? categoryId,
  }) async {
    final search = select(productsTable);
    if (query != null && query.isNotEmpty) {
      search.where(
        (t) =>
            t.title.contains(query) |
            t.barcode.equals(query) |
            t.data.contains(query),
      ); // Fallback to data search
    }
    if (categoryId != null) {
      search.where((t) => t.categoryId.equals(categoryId));
    }
    return search.get();
  }

  /// High-quality upsert that flattens data on the fly
  Future<void> upsertProduct(Map<String, dynamic> json) async {
    final id = json['uuid'] ?? json['id']?.toString() ?? '';
    if (id.isEmpty) return;

    await into(productsTable).insertOnConflictUpdate(
      ProductsTableCompanion.insert(
        id: Value(id),
        title: Value(json['translation']?['title'] ?? json['title']),
        barcode: Value(json['bar_code'] ?? json['barcode']),
        categoryId: Value(json['category_id']?.toString()),
        active: Value(json['active'] == 1 || json['active'] == true),
        img: Value(json['img']),
        unitId: Value(json['unit_id']?.toString()),
        data: jsonEncode(json),
      ),
    );
  }

  // ─── High-Quality Category Helpers ───

  Future<void> upsertCategory(Map<String, dynamic> json) async {
    final id = json['name'] ?? json['id']?.toString() ?? '';
    if (id.isEmpty) return;
    await putItem('categories', id, json);
  }

  Future<List<Map<String, dynamic>>> getCategoriesLocally() async {
    return getAll('categories');
  }

  // ─── High-Quality Shop Helpers ───

  Future<void> upsertShop(Map<String, dynamic> json) async {
    final id = json['id']?.toString() ?? json['uuid'] ?? '';
    if (id.isEmpty) return;
    await putItem('shop', id, json);
  }

  Future<List<Map<String, dynamic>>> getShopsLocally({
    String? categoryId,
  }) async {
    final allShops = await getAll('shop');
    if (categoryId != null) {
      return allShops
          .where((shop) => shop['category_id'] == categoryId)
          .toList();
    }
    return allShops;
  }

  // ─── High-Quality Banner Helpers ───

  Future<void> upsertBanner(Map<String, dynamic> json) async {
    final id = json['name'] ?? json['id']?.toString() ?? '';
    if (id.isEmpty) return;
    await putItem('banners', id, json);
  }

  Future<List<Map<String, dynamic>>> getBannersLocally() async {
    return getAll('banners');
  }

  // ─── High-Quality Order Helpers ───

  Future<List<OrderEntity>> getOrdersLocally({String? status}) async {
    final query = select(ordersTable);
    if (status != null) {
      query.where((t) => t.status.equals(status));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);
    return query.get();
  }

  Future<void> upsertOrder(Map<String, dynamic> json) async {
    final id = json['id']?.toString() ?? json['uuid'] ?? '';
    if (id.isEmpty) return;

    await into(ordersTable).insertOnConflictUpdate(
      OrdersTableCompanion.insert(
        id: Value(id),
        shopId: Value(json['shop_id']?.toString()),
        totalPrice: Value((json['total_price'] as num?)?.toDouble()),
        totalCost: Value((json['total_cost'] as num?)?.toDouble()),
        status: Value(json['status']),
        paymentType: Value(json['payment_type']),
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        synced: const Value(true), // If coming from API, it's synced
        data: jsonEncode(json),
      ),
    );

    // Snapshot Order Items
    final items = json['details'] as List? ?? [];
    for (final item in items) {
      final itemId = item['id']?.toString() ?? '';
      if (itemId.isEmpty) continue;

      await into(orderItemsTable).insertOnConflictUpdate(
        OrderItemsTableCompanion.insert(
          id: Value(itemId),
          orderId: id,
          productId: Value(item['product_id']?.toString()),
          stockId: Value(item['stock_id']?.toString()),
          quantity: Value(item['quantity'] as int?),
          price: Value((item['price'] as num?)?.toDouble()),
          costPrice: Value((item['cost_price'] as num?)?.toDouble()),
        ),
      );
    }
  }

  // Helper methods to dynamically extract fields and create companions
  Insertable<dynamic> _createInsertable(
    String boxName,
    String id,
    String data,
  ) {
    switch (boxName) {
      case 'products':
        return ProductsTableCompanion.insert(id: Value(id), data: data);
      case 'stocks':
        return StocksTableCompanion.insert(id: Value(id), data: Value(data));
      case 'events':
        return EventQueueTableCompanion.insert(
          id: id,
          source: 'mobile',
          eventType: 'legacy',
          entityId: '',
          entityType: '',
          payload: data,
          timestamp: DateTime.now(),
        );
      case 'orders':
        return OrdersTableCompanion.insert(
          id: id,
          data: data,
          createdAt: DateTime.now(),
        );
      case 'shop':
        return ShopTableCompanion.insert(id: id, data: data);
      case 'categories':
        return CategoriesTableCompanion.insert(id: id, data: data);
      case 'settings':
        return SettingsTableCompanion.insert(id: id, data: data);
      case 'billing_cart':
        return BillingCartTableCompanion.insert(id: id, data: data);
      case 'banners':
        return BannersTableCompanion.insert(id: id, data: data);
      case 'notifications':
        return NotificationsTableCompanion.insert(
          id: int.tryParse(id) ?? 0,
          data: data,
        );
      default:
        throw ArgumentError('Unknown box name: $boxName');
    }
  }

  Expression<String> _idColumn(TableInfo<Table, dynamic> table) {
    if (table is $ProductsTableTable) return table.id;
    if (table is $OrdersTableTable) return table.id;
    if (table is $ShopTableTable) return table.id;
    if (table is $CategoriesTableTable) return table.id;
    if (table is $SettingsTableTable) return table.id;
    if (table is $BillingCartTableTable) return table.id;
    if (table is $OrderItemsTableTable) return table.id;
    if (table is $BannersTableTable) return table.id;
    if (table is $NotificationsTableTable) return table.id.cast<String>();
    throw ArgumentError('Unknown table type');
  }

  String _dataColumn(dynamic row) {
    if (row is ProductEntity) return row.data;
    if (row is OrderEntity) return row.data;
    if (row is ShopEntity) return row.data;
    if (row is CategoryEntity) return row.data;
    if (row is SettingEntity) return row.data;
    if (row is BillingCartEntity) return row.data;
    if (row is UserEntity) return row.data;
    if (row is BannerEntity) return row.data;
    if (row is NotificationEntity) return row.data;
    throw ArgumentError('Unknown row type');
  }

  // ─── High-Quality Notification Helpers ───

  Future<void> upsertNotification(Map<String, dynamic> json) async {
    final id = json['notification_id'] ?? json['id'] ?? 0;
    if (id == 0) return;

    await into(notificationsTable).insertOnConflictUpdate(
      NotificationsTableCompanion.insert(
        id: Value(id),
        data: jsonEncode(json),
        readAt: Value(DateTime.tryParse(json['read_at'] ?? '')),
      ),
    );
  }

  Future<List<NotificationEntity>> getNotificationsLocally() async {
    return (select(notificationsTable)..orderBy([
          (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
        ]))
        .get();
  }

  // ─── User Helpers ───

  Future<void> upsertUser(Map<String, dynamic> json, {String? password}) async {
    final id = json['uuid'] ?? json['id']?.toString() ?? '';
    if (id.isEmpty) return;

    await into(userTable).insertOnConflictUpdate(
      UserTableCompanion.insert(
        id: Value(id),
        email: Value(json['email']?.toString()),
        phone: Value(json['phone']?.toString()),
        role: Value(json['role']?.toString() ?? 'customer'),
        password: Value(password),
        data: jsonEncode(json),
        lastLogin: Value(DateTime.now()),
      ),
    );
  }

  Future<UserEntity?> getLocalUser(String identifier) async {
    return (select(userTable)..where(
          (t) => t.email.equals(identifier) | t.phone.equals(identifier),
        ))
        .getSingleOrNull();
  }

  Future<bool> hasManagerAccount() async {
    final manager = await (select(
      userTable,
    )..where((t) => t.role.equals('seller') | t.role.equals('manager'))).get();
    return manager.isNotEmpty;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      // applyWorkaroundToOpenSqlite3OnOldAndroidVersions is provided by sqlite3_flutter_libs
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
