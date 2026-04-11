import 'package:rokctapp/infrastructure/models/data/order_detail.dart';
import 'package:rokctapp/infrastructure/models/data/driver/product_data.dart';

class AddonData {
  AddonData({
    String? id,
    String? stockId,
    String? addonId,
    int? quantity,
    num? totalPrice,
    ProductData? product,
    Stock? stock,
    bool? active,
  }) {
    _id = id;
    _stockId = stockId;
    _addonId = addonId;
    _totalPrice = totalPrice;
    _quantity = quantity;
    _product = product;
    _stock = stock;
    _active = active;
  }

  AddonData.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _stockId = json['stock_id']?.toString();
    _addonId = json['addon_id']?.toString();
    _quantity = json['quantity'];
    _totalPrice = json["total_price"];
    _stock = json['stock'] != null ? Stock.fromJson(json['stock']) : null;
    _product = json['product'] != null
        ? ProductData.fromJson(json['product'])
        : null;
  }

  String? _id;
  String? _stockId;
  String? _addonId;
  int? _quantity;
  bool? _active;
  num? _totalPrice;
  ProductData? _product;
  Stock? _stock;

  AddonData copyWith({
    String? id,
    String? stockId,
    String? addonId,
    int? quantity,
    bool? active,
    num? totalPrice,
    Stock? stock,
    ProductData? product,
  }) => AddonData(
    id: id ?? _id,
    stockId: stockId ?? _stockId,
    addonId: addonId ?? _addonId,
    quantity: quantity ?? _quantity,
    totalPrice: totalPrice ?? _totalPrice,
    stock: stock ?? _stock,
    active: active ?? _active,
    product: product ?? _product,
  );

  String? get id => _id;

  String? get stockId => _stockId;

  String? get addonId => _addonId;

  int? get quantity => _quantity;

  bool? get active => _active;

  set setActive(bool active) => _active = active;

  set setCount(int count) => _quantity = count;

  num? get totalPrice => _totalPrice;

  ProductData? get product => _product;

  Stock? get stock => _stock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['stock_id'] = _stockId;
    map['addon_id'] = _addonId;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    return map;
  }
}
