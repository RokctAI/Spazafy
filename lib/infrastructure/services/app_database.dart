import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'drift_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  ProductsTable,
  OrdersTable,
  ShopTable,
  CategoriesTable,
  SettingsTable,
  BillingCartTable,
  SyncQueueTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
      default:
        throw ArgumentError('Unknown box name: $boxName');
    }
  }

  // ─── Generic CRUD helpers to replace HiveDatabase ───

  /// Save a JSON-serializable item by key.
  Future<void> putItem(String boxName, String key, Map<String, dynamic> json) async {
    final table = getTable(boxName);
    final dataString = jsonEncode(json);

    await into(table).insertOnConflictUpdate(
      _createInsertable(boxName, key, dataString),
    );
  }

  /// Get an item as Map by key.
  Future<Map<String, dynamic>?> getItem(String boxName, String key) async {
    final table = getTable(boxName);

    final query = select(table)..where((tbl) {
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
    })).go();
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

  Future<List<SyncQueueEntity>> getPendingSyncRequests() {
    return (select(syncQueueTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<void> removeSyncRequest(String id) {
    return (delete(syncQueueTable)..where((t) => t.id.equals(id))).go();
  }

  // Helper methods to dynamically extract fields and create companions
  Insertable<dynamic> _createInsertable(String boxName, String id, String data) {
    switch (boxName) {
      case 'products':
        return ProductsTableCompanion.insert(id: Value(id), data: data);
      case 'orders':
        return OrdersTableCompanion.insert(id: Value(id), data: data);
      case 'shop':
        return ShopTableCompanion.insert(id: id, data: data);
      case 'categories':
        return CategoriesTableCompanion.insert(id: id, data: data);
      case 'settings':
        return SettingsTableCompanion.insert(id: id, data: data);
      case 'billing_cart':
        return BillingCartTableCompanion.insert(id: id, data: data);
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
    throw ArgumentError('Unknown table type');
  }

  String _dataColumn(dynamic row) {
    if (row is ProductEntity) return row.data;
    if (row is OrderEntity) return row.data;
    if (row is ShopEntity) return row.data;
    if (row is CategoryEntity) return row.data;
    if (row is SettingEntity) return row.data;
    if (row is BillingCartEntity) return row.data;
    throw ArgumentError('Unknown row type');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
