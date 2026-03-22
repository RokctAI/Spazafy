import 'package:rokctapp/dummy_types.dart';
import 'package:drift/drift.dart';

@DataClassName('ProductEntity')
class ProductsTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get title => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  TextColumn get img => text().nullable()();
  TextColumn get unitId => text().nullable()();
  BoolColumn get isPack => boolean().withDefault(const Constant(false))();
  TextColumn get parentId => text().nullable()(); // For child-parent SKU link
  TextColumn get data => text()(); // Store full JSON for compatibility

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StockEntity')
class StocksTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get productUuid => text().nullable()();
  RealColumn get price => real().nullable()();
  RealColumn get costPrice => real().nullable()();
  IntColumn get quantity => integer().nullable()();
  TextColumn get sku => text().nullable()();
  TextColumn get data => text().nullable()(); // JSON blob fallback

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EventQueueEntity')
class EventQueueTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get source => text()(); // e.g., 'mobile_pos'
  TextColumn get eventType => text()(); // e.g., 'sale_completed'
  TextColumn get entityId => text()(); // e.g., 'SHOP-001'
  TextColumn get entityType => text()(); // e.g., 'shop'
  TextColumn get payload => text()(); // JSON payload
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncQueueEntity')
class SyncQueueTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get url => text()();
  TextColumn get method => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AbandonedSyncQueueEntity')
class AbandonedSyncQueueTable extends Table {
  TextColumn get id => text()(); // UUID from original request
  TextColumn get url => text()();
  TextColumn get method => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get abandonedAt => dateTime()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderEntity')
class OrdersTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get shopId => text().nullable()();
  RealColumn get totalPrice => real().nullable()();
  RealColumn get totalCost => real().nullable()();
  TextColumn get status => text().nullable()(); // 'new', 'accepted', etc.
  TextColumn get paymentType => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  TextColumn get data => text()(); // Store full JSON for compatibility

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderItemEntity')
class OrderItemsTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get orderId => text().references(OrdersTable, #id)();
  TextColumn get productId => text().nullable()();
  TextColumn get stockId => text().nullable()();
  IntColumn get quantity => integer().nullable()();
  RealColumn get price => real().nullable()(); // Snapshot at sale
  RealColumn get costPrice =>
      real().nullable()(); // Snapshot at sale for accurate margins

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ShopEntity')
class ShopTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryEntity')
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SettingEntity')
class SettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BillingCartEntity')
class BillingCartTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BannerEntity')
class BannersTable extends Table {
  TextColumn get id => text()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserEntity')
class UserTable extends Table {
  TextColumn get id => text()(); // UUID from backend
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text().nullable()(); // 'seller', 'customer', etc.
  TextColumn get password =>
      text().nullable()(); // Stored hashed/encrypted for offline re-login
  TextColumn get data => text()(); // Full ProfileData JSON
  DateTimeColumn get lastLogin => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('NotificationEntity')
class NotificationsTable extends Table {
  IntColumn get id => integer()(); // Notification ID
  TextColumn get data => text()(); // Full JSON
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
