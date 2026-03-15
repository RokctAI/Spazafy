import 'product_data.dart';

class AddonData {
  AddonData({
    String? id,
    String? stockId,
    String? addonId,
    int? quantity,
    num? totalPrice,
    ProductData? product,
    Stocks? stock,
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
    _addonId = json['addon_id']?.toString() ?? json['product_id']?.toString();
    _quantity = json['quantity'] ?? 0;
    _totalPrice = json["total_price"] ?? json['price'];
    _stock = json['stock'] != null ? Stocks.fromJson(json['stock']) : null;
    _product =
        json['product'] != null ? ProductData.fromJson(json['product']) : null;
    _active = json['active'] is bool ? json['active'] : false;
  }

  String? _id;
  String? _stockId;
  String? _addonId;
  int? _quantity;
  bool? _active;
  num? _totalPrice;
  ProductData? _product;
  Stocks? _stock;

  AddonData copyWith({
    String? id,
    String? stockId,
    String? addonId,
    int? quantity,
    bool? active,
    num? totalPrice,
    Stocks? stock,
    ProductData? product,
  }) =>
      AddonData(
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
  num? get totalPrice => _totalPrice;
  ProductData? get product => _product;
  Stocks? get stock => _stock;

  set setActive(bool active) => _active = active;
  set setCount(int count) => _quantity = count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['stock_id'] = _stockId;
    map['addon_id'] = _addonId;
    map['quantity'] = _quantity;
    map['total_price'] = _totalPrice;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    if (_stock != null) {
      map['stock'] = _stock?.toJson();
    }
    map['active'] = _active;
    return map;
  }
}
