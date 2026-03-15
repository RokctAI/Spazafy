// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => '',
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductEntity extends DataClass implements Insertable<ProductEntity> {
  final String id;
  final String data;
  const ProductEntity({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(id: Value(id), data: Value(data));
  }

  factory ProductEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductEntity(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  ProductEntity copyWith({String? id, String? data}) =>
      ProductEntity(id: id ?? this.id, data: data ?? this.data);
  ProductEntity copyWithCompanion(ProductsTableCompanion data) {
    return ProductEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductEntity(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEntity &&
          other.id == this.id &&
          other.data == this.data);
}

class ProductsTableCompanion extends UpdateCompanion<ProductEntity> {
  final Value<String> id;
  final Value<String> data;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    this.id = const Value.absent(),
    required String data,
    this.rowid = const Value.absent(),
  }) : data = Value(data);
  static Insertable<ProductEntity> custom({
    Expression<String>? id,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrderEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => '',
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrderEntity extends DataClass implements Insertable<OrderEntity> {
  final String id;
  final String data;
  const OrderEntity({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(id: Value(id), data: Value(data));
  }

  factory OrderEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderEntity(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  OrderEntity copyWith({String? id, String? data}) =>
      OrderEntity(id: id ?? this.id, data: data ?? this.data);
  OrderEntity copyWithCompanion(OrdersTableCompanion data) {
    return OrderEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderEntity(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderEntity && other.id == this.id && other.data == this.data);
}

class OrdersTableCompanion extends UpdateCompanion<OrderEntity> {
  final Value<String> id;
  final Value<String> data;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    this.id = const Value.absent(),
    required String data,
    this.rowid = const Value.absent(),
  }) : data = Value(data);
  static Insertable<OrderEntity> custom({
    Expression<String>? id,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopTableTable extends ShopTable
    with TableInfo<$ShopTableTable, ShopEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $ShopTableTable createAlias(String alias) {
    return $ShopTableTable(attachedDatabase, alias);
  }
}

class ShopEntity extends DataClass implements Insertable<ShopEntity> {
  final String id;
  final String data;
  const ShopEntity({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  ShopTableCompanion toCompanion(bool nullToAbsent) {
    return ShopTableCompanion(id: Value(id), data: Value(data));
  }

  factory ShopEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopEntity(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  ShopEntity copyWith({String? id, String? data}) =>
      ShopEntity(id: id ?? this.id, data: data ?? this.data);
  ShopEntity copyWithCompanion(ShopTableCompanion data) {
    return ShopEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopEntity(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopEntity && other.id == this.id && other.data == this.data);
}

class ShopTableCompanion extends UpdateCompanion<ShopEntity> {
  final Value<String> id;
  final Value<String> data;
  final Value<int> rowid;
  const ShopTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopTableCompanion.insert({
    required String id,
    required String data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        data = Value(data);
  static Insertable<ShopEntity> custom({
    Expression<String>? id,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopTableCompanion copyWith({
    Value<String>? id,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return ShopTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoryEntity extends DataClass implements Insertable<CategoryEntity> {
  final String id;
  final String data;
  const CategoryEntity({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(id: Value(id), data: Value(data));
  }

  factory CategoryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntity(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  CategoryEntity copyWith({String? id, String? data}) =>
      CategoryEntity(id: id ?? this.id, data: data ?? this.data);
  CategoryEntity copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntity(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntity &&
          other.id == this.id &&
          other.data == this.data);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryEntity> {
  final Value<String> id;
  final Value<String> data;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        data = Value(data);
  static Insertable<CategoryEntity> custom({
    Expression<String>? id,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingEntity extends DataClass implements Insertable<SettingEntity> {
  final String id;
  final String data;
  const SettingEntity({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(id: Value(id), data: Value(data));
  }

  factory SettingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingEntity(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  SettingEntity copyWith({String? id, String? data}) =>
      SettingEntity(id: id ?? this.id, data: data ?? this.data);
  SettingEntity copyWithCompanion(SettingsTableCompanion data) {
    return SettingEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntity(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingEntity &&
          other.id == this.id &&
          other.data == this.data);
}

class SettingsTableCompanion extends UpdateCompanion<SettingEntity> {
  final Value<String> id;
  final Value<String> data;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    required String id,
    required String data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        data = Value(data);
  static Insertable<SettingEntity> custom({
    Expression<String>? id,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillingCartTableTable extends BillingCartTable
    with TableInfo<$BillingCartTableTable, BillingCartEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillingCartTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'billing_cart_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillingCartEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillingCartEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillingCartEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $BillingCartTableTable createAlias(String alias) {
    return $BillingCartTableTable(attachedDatabase, alias);
  }
}

class BillingCartEntity extends DataClass
    implements Insertable<BillingCartEntity> {
  final String id;
  final String data;
  const BillingCartEntity({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  BillingCartTableCompanion toCompanion(bool nullToAbsent) {
    return BillingCartTableCompanion(id: Value(id), data: Value(data));
  }

  factory BillingCartEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillingCartEntity(
      id: serializer.fromJson<String>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  BillingCartEntity copyWith({String? id, String? data}) =>
      BillingCartEntity(id: id ?? this.id, data: data ?? this.data);
  BillingCartEntity copyWithCompanion(BillingCartTableCompanion data) {
    return BillingCartEntity(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillingCartEntity(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillingCartEntity &&
          other.id == this.id &&
          other.data == this.data);
}

class BillingCartTableCompanion extends UpdateCompanion<BillingCartEntity> {
  final Value<String> id;
  final Value<String> data;
  final Value<int> rowid;
  const BillingCartTableCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillingCartTableCompanion.insert({
    required String id,
    required String data,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        data = Value(data);
  static Insertable<BillingCartEntity> custom({
    Expression<String>? id,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillingCartTableCompanion copyWith({
    Value<String>? id,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return BillingCartTableCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillingCartTableCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => '',
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, url, method, payload, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueEntity extends DataClass implements Insertable<SyncQueueEntity> {
  final String id;
  final String url;
  final String method;
  final String payload;
  final DateTime createdAt;
  const SyncQueueEntity({
    required this.id,
    required this.url,
    required this.method,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    map['method'] = Variable<String>(method);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      url: Value(url),
      method: Value(method),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntity(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      method: serializer.fromJson<String>(json['method']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'method': serializer.toJson<String>(method),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueEntity copyWith({
    String? id,
    String? url,
    String? method,
    String? payload,
    DateTime? createdAt,
  }) =>
      SyncQueueEntity(
        id: id ?? this.id,
        url: url ?? this.url,
        method: method ?? this.method,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueEntity copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueEntity(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      method: data.method.present ? data.method.value : this.method,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntity(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, method, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntity &&
          other.id == this.id &&
          other.url == this.url &&
          other.method == this.method &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueEntity> {
  final Value<String> id;
  final Value<String> url;
  final Value<String> method;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.method = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    required String method,
    required String payload,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : url = Value(url),
        method = Value(method),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueEntity> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<String>? method,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (method != null) 'method': method,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith({
    Value<String>? id,
    Value<String>? url,
    Value<String>? method,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      method: method ?? this.method,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $ShopTableTable shopTable = $ShopTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $BillingCartTableTable billingCartTable = $BillingCartTableTable(
    this,
  );
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        productsTable,
        ordersTable,
        shopTable,
        categoriesTable,
        settingsTable,
        billingCartTable,
        syncQueueTable,
      ];
}

typedef $$ProductsTableTableCreateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<String> id,
  required String data,
  Value<int> rowid,
});
typedef $$ProductsTableTableUpdateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<String> id,
  Value<String> data,
  Value<int> rowid,
});

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnFilters(column),
      );
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$ProductsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductEntity,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductEntity,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductEntity>,
    ),
    ProductEntity,
    PrefetchHooks Function()> {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$ProductsTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$ProductsTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$ProductsTableTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> data = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                ProductsTableCompanion(id: id, data: data, rowid: rowid),
            createCompanionCallback: ({
              Value<String> id = const Value.absent(),
              required String data,
              Value<int> rowid = const Value.absent(),
            }) =>
                ProductsTableCompanion.insert(
              id: id,
              data: data,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$ProductsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductEntity,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductEntity,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductEntity>,
    ),
    ProductEntity,
    PrefetchHooks Function()>;
typedef $$OrdersTableTableCreateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<String> id,
  required String data,
  Value<int> rowid,
});
typedef $$OrdersTableTableUpdateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<String> id,
  Value<String> data,
  Value<int> rowid,
});

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnFilters(column),
      );
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$OrdersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrderEntity,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (
      OrderEntity,
      BaseReferences<_$AppDatabase, $OrdersTableTable, OrderEntity>,
    ),
    OrderEntity,
    PrefetchHooks Function()> {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$OrdersTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$OrdersTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$OrdersTableTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> data = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                OrdersTableCompanion(id: id, data: data, rowid: rowid),
            createCompanionCallback: ({
              Value<String> id = const Value.absent(),
              required String data,
              Value<int> rowid = const Value.absent(),
            }) =>
                OrdersTableCompanion.insert(id: id, data: data, rowid: rowid),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$OrdersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrderEntity,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (
      OrderEntity,
      BaseReferences<_$AppDatabase, $OrdersTableTable, OrderEntity>,
    ),
    OrderEntity,
    PrefetchHooks Function()>;
typedef $$ShopTableTableCreateCompanionBuilder = ShopTableCompanion Function({
  required String id,
  required String data,
  Value<int> rowid,
});
typedef $$ShopTableTableUpdateCompanionBuilder = ShopTableCompanion Function({
  Value<String> id,
  Value<String> data,
  Value<int> rowid,
});

class $$ShopTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnFilters(column),
      );
}

class $$ShopTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$ShopTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopTableTable> {
  $$ShopTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$ShopTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShopTableTable,
    ShopEntity,
    $$ShopTableTableFilterComposer,
    $$ShopTableTableOrderingComposer,
    $$ShopTableTableAnnotationComposer,
    $$ShopTableTableCreateCompanionBuilder,
    $$ShopTableTableUpdateCompanionBuilder,
    (
      ShopEntity,
      BaseReferences<_$AppDatabase, $ShopTableTable, ShopEntity>,
    ),
    ShopEntity,
    PrefetchHooks Function()> {
  $$ShopTableTableTableManager(_$AppDatabase db, $ShopTableTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$ShopTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$ShopTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$ShopTableTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> data = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                ShopTableCompanion(id: id, data: data, rowid: rowid),
            createCompanionCallback: ({
              required String id,
              required String data,
              Value<int> rowid = const Value.absent(),
            }) =>
                ShopTableCompanion.insert(id: id, data: data, rowid: rowid),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$ShopTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShopTableTable,
    ShopEntity,
    $$ShopTableTableFilterComposer,
    $$ShopTableTableOrderingComposer,
    $$ShopTableTableAnnotationComposer,
    $$ShopTableTableCreateCompanionBuilder,
    $$ShopTableTableUpdateCompanionBuilder,
    (ShopEntity, BaseReferences<_$AppDatabase, $ShopTableTable, ShopEntity>),
    ShopEntity,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String id,
  required String data,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> data,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnFilters(column),
      );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoryEntity,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoryEntity,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntity>,
    ),
    CategoryEntity,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$CategoriesTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$CategoriesTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$CategoriesTableTableAnnotationComposer(
                    $db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> data = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                CategoriesTableCompanion(id: id, data: data, rowid: rowid),
            createCompanionCallback: ({
              required String id,
              required String data,
              Value<int> rowid = const Value.absent(),
            }) =>
                CategoriesTableCompanion.insert(
              id: id,
              data: data,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoryEntity,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoryEntity,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntity>,
    ),
    CategoryEntity,
    PrefetchHooks Function()>;
typedef $$SettingsTableTableCreateCompanionBuilder = SettingsTableCompanion
    Function({
  required String id,
  required String data,
  Value<int> rowid,
});
typedef $$SettingsTableTableUpdateCompanionBuilder = SettingsTableCompanion
    Function({
  Value<String> id,
  Value<String> data,
  Value<int> rowid,
});

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnFilters(column),
      );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$SettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingEntity,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingEntity,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingEntity>,
    ),
    SettingEntity,
    PrefetchHooks Function()> {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$SettingsTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$SettingsTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$SettingsTableTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> data = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                SettingsTableCompanion(id: id, data: data, rowid: rowid),
            createCompanionCallback: ({
              required String id,
              required String data,
              Value<int> rowid = const Value.absent(),
            }) =>
                SettingsTableCompanion.insert(
              id: id,
              data: data,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$SettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingEntity,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingEntity,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingEntity>,
    ),
    SettingEntity,
    PrefetchHooks Function()>;
typedef $$BillingCartTableTableCreateCompanionBuilder
    = BillingCartTableCompanion Function({
  required String id,
  required String data,
  Value<int> rowid,
});
typedef $$BillingCartTableTableUpdateCompanionBuilder
    = BillingCartTableCompanion Function({
  Value<String> id,
  Value<String> data,
  Value<int> rowid,
});

class $$BillingCartTableTableFilterComposer
    extends Composer<_$AppDatabase, $BillingCartTableTable> {
  $$BillingCartTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnFilters(column),
      );
}

class $$BillingCartTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BillingCartTableTable> {
  $$BillingCartTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get data => $composableBuilder(
        column: $table.data,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$BillingCartTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillingCartTableTable> {
  $$BillingCartTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$BillingCartTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillingCartTableTable,
    BillingCartEntity,
    $$BillingCartTableTableFilterComposer,
    $$BillingCartTableTableOrderingComposer,
    $$BillingCartTableTableAnnotationComposer,
    $$BillingCartTableTableCreateCompanionBuilder,
    $$BillingCartTableTableUpdateCompanionBuilder,
    (
      BillingCartEntity,
      BaseReferences<_$AppDatabase, $BillingCartTableTable, BillingCartEntity>,
    ),
    BillingCartEntity,
    PrefetchHooks Function()> {
  $$BillingCartTableTableTableManager(
    _$AppDatabase db,
    $BillingCartTableTable table,
  ) : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$BillingCartTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$BillingCartTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$BillingCartTableTableAnnotationComposer(
                    $db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> data = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                BillingCartTableCompanion(id: id, data: data, rowid: rowid),
            createCompanionCallback: ({
              required String id,
              required String data,
              Value<int> rowid = const Value.absent(),
            }) =>
                BillingCartTableCompanion.insert(
              id: id,
              data: data,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$BillingCartTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillingCartTableTable,
    BillingCartEntity,
    $$BillingCartTableTableFilterComposer,
    $$BillingCartTableTableOrderingComposer,
    $$BillingCartTableTableAnnotationComposer,
    $$BillingCartTableTableCreateCompanionBuilder,
    $$BillingCartTableTableUpdateCompanionBuilder,
    (
      BillingCartEntity,
      BaseReferences<_$AppDatabase, $BillingCartTableTable, BillingCartEntity>,
    ),
    BillingCartEntity,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  required String url,
  required String method,
  required String payload,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  Value<String> url,
  Value<String> method,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get url => $composableBuilder(
        column: $table.url,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get method => $composableBuilder(
        column: $table.method,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get payload => $composableBuilder(
        column: $table.payload,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnFilters(column),
      );
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get url => $composableBuilder(
        column: $table.url,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get method => $composableBuilder(
        column: $table.method,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get payload => $composableBuilder(
        column: $table.payload,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueEntity,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueEntity,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueEntity>,
    ),
    SyncQueueEntity,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
    _$AppDatabase db,
    $SyncQueueTableTable table,
  ) : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$SyncQueueTableTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<String> id = const Value.absent(),
              Value<String> url = const Value.absent(),
              Value<String> method = const Value.absent(),
              Value<String> payload = const Value.absent(),
              Value<DateTime> createdAt = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                SyncQueueTableCompanion(
              id: id,
              url: url,
              method: method,
              payload: payload,
              createdAt: createdAt,
              rowid: rowid,
            ),
            createCompanionCallback: ({
              Value<String> id = const Value.absent(),
              required String url,
              required String method,
              required String payload,
              required DateTime createdAt,
              Value<int> rowid = const Value.absent(),
            }) =>
                SyncQueueTableCompanion.insert(
              id: id,
              url: url,
              method: method,
              payload: payload,
              createdAt: createdAt,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueEntity,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueEntity,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueEntity>,
    ),
    SyncQueueEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$ShopTableTableTableManager get shopTable =>
      $$ShopTableTableTableManager(_db, _db.shopTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$BillingCartTableTableTableManager get billingCartTable =>
      $$BillingCartTableTableTableManager(_db, _db.billingCartTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
}
