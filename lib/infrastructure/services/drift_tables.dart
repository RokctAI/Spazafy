import 'package:drift/drift.dart';

@DataClassName('ProductEntity')
class ProductsTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get data => text()(); // Store full JSON for compatibility

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

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderEntity')
class OrdersTable extends Table {
  TextColumn get id => text().clientDefault(() => '')(); // UUID
  TextColumn get data => text()(); // Store full JSON for compatibility

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
