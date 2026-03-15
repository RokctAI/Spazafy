import 'currency_data.dart';
import 'user.dart';
import 'product_data.dart';
import 'shop_data.dart';
import 'translation.dart';
import 'review_data.dart';
import 'coupon_data.dart';

class OrderData {
  OrderData({
    String? id,
    String? userId,
    num? price,
    num? currencyPrice,
    num? rate,
    int? orderDetailsCount,
    String? createdAt,
    String? updatedAt,
    CurrencyData? currency,
    UserModel? user,
    List<ShopOrderDetails>? details,
    ReviewData? review,
    String? status,
    num? tips,
    num? commissionFee,
    String? deliveryType,
    num? deliveryFee,
    num? otp,
    dynamic deliveryman,
    String? deliveryDate,
    String? deliveryTime,
    Transaction? transaction,
    OrderAddress? orderAddress,
    String? note,
    String? afterDeliveredImage,
    bool? seen,
    num? distance,
    bool? current,
  }) {
    _id = id;
    _userId = userId;
    _price = price;
    _currencyPrice = currencyPrice;
    _rate = rate;
    _orderDetailsCount = orderDetailsCount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _currency = currency;
    _user = user;
    _details = details;
    _review = review;
    _status = status;
    _tips = tips;
    _commissionFee = commissionFee;
    _deliveryType = deliveryType;
    _deliveryFee = deliveryFee;
    _otp = otp;
    _deliveryman = deliveryman;
    _deliveryDate = deliveryDate;
    _deliveryTime = deliveryTime;
    _transaction = transaction;
    _orderAddress = orderAddress;
    _note = note;
    _afterDeliveredImage = afterDeliveredImage;
    _seen = seen;
    _distance = distance;
    _current = current;
  }

  OrderData.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _userId = json['user_id']?.toString();
    _price = json['price'] ?? json['total_price'];
    _currencyPrice = json['currency_price'];
    _rate = json['rate'];
    _orderDetailsCount = json['order_details_count'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _currency = json['currency'] != null
        ? CurrencyData.fromJson(json['currency'])
        : null;
    _user = json['user'] != null
        ? UserModel.fromJson(json['user'])
        : json['user_id'] != null
            ? UserModel(id: json['user_id']?.toString())
            : null;
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(ShopOrderDetails.fromJson(v));
      });
    }
    _review =
        json['review'] != null ? ReviewData.fromJson(json['review']) : null;
    _status = json['status'];
    _tips = json['tips'];
    _commissionFee = json['commission_fee'];
    _deliveryType = json['delivery_type'];
    _deliveryFee = json['delivery_fee'];
    _otp = json['otp'];
    _deliveryman = json['deliveryman'];
    _deliveryDate = json['delivery_date'];
    _deliveryTime = json['delivery_time'];
    _transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
    _orderAddress = json['address'] != null
        ? OrderAddress.fromJson(json['address'])
        : null;
    _note = json['note'];
    _afterDeliveredImage = json['image_after_delivered'];
    _seen = json['seen'];
    _distance = json['km'];
    _current = json["current"] == null
        ? false
        : ((json["current"].runtimeType == int)
            ? (json["current"] == 0 ? false : true)
            : json["current"]);
  }

  String? _id;
  String? _userId;
  num? _price;
  num? _currencyPrice;
  num? _rate;
  int? _orderDetailsCount;
  String? _createdAt;
  String? _updatedAt;
  CurrencyData? _currency;
  UserModel? _user;
  List<ShopOrderDetails>? _details;
  ReviewData? _review;
  String? _status;
  num? _tips;
  num? _commissionFee;
  String? _deliveryType;
  num? _deliveryFee;
  num? _otp;
  dynamic _deliveryman;
  String? _deliveryDate;
  String? _deliveryTime;
  Transaction? _transaction;
  OrderAddress? _orderAddress;
  String? _note;
  String? _afterDeliveredImage;
  bool? _seen;
  num? _distance;
  bool? _current;

  OrderData copyWith({
    String? id,
    String? userId,
    num? price,
    num? currencyPrice,
    num? rate,
    int? orderDetailsCount,
    String? createdAt,
    String? updatedAt,
    CurrencyData? currency,
    UserModel? user,
    List<ShopOrderDetails>? details,
    ReviewData? review,
    String? status,
    num? tips,
    num? commissionFee,
    String? deliveryType,
    num? deliveryFee,
    num? otp,
    dynamic deliveryman,
    String? deliveryDate,
    String? deliveryTime,
    Transaction? transaction,
    OrderAddress? orderAddress,
    String? note,
    String? afterDeliveredImage,
    bool? seen,
    num? distance,
    bool? current,
  }) =>
      OrderData(
        id: id ?? _id,
        userId: userId ?? _userId,
        price: price ?? _price,
        currencyPrice: currencyPrice ?? _currencyPrice,
        rate: rate ?? _rate,
        orderDetailsCount: orderDetailsCount ?? _orderDetailsCount,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        currency: currency ?? _currency,
        user: user ?? _user,
        details: details ?? _details,
        review: review ?? _review,
        status: status ?? _status,
        tips: tips ?? _tips,
        commissionFee: commissionFee ?? _commissionFee,
        deliveryType: deliveryType ?? _deliveryType,
        deliveryFee: deliveryFee ?? _deliveryFee,
        otp: otp ?? _otp,
        deliveryman: deliveryman ?? _deliveryman,
        deliveryDate: deliveryDate ?? _deliveryDate,
        deliveryTime: deliveryTime ?? _deliveryTime,
        transaction: transaction ?? _transaction,
        orderAddress: orderAddress ?? _orderAddress,
        note: note ?? _note,
        afterDeliveredImage: afterDeliveredImage ?? _afterDeliveredImage,
        seen: seen ?? _seen,
        distance: distance ?? _distance,
        current: current ?? _current,
      );

  String? get id => _id;
  String? get userId => _userId;
  num? get price => _price;
  num? get currencyPrice => _currencyPrice;
  num? get rate => _rate;
  int? get orderDetailsCount => _orderDetailsCount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  CurrencyData? get currency => _currency;
  UserModel? get user => _user;
  List<ShopOrderDetails>? get details => _details;
  ReviewData? get review => _review;
  String? get status => _status;
  num? get tips => _tips;
  num? get commissionFee => _commissionFee;
  String? get deliveryType => _deliveryType;
  num? get deliveryFee => _deliveryFee;
  num? get otp => _otp;
  dynamic get deliveryman => _deliveryman;
  String? get deliveryDate => _deliveryDate;
  String? get deliveryTime => _deliveryTime;
  Transaction? get transaction => _transaction;
  OrderAddress? get orderAddress => _orderAddress;
  String? get note => _note;
  String? get afterDeliveredImage => _afterDeliveredImage;
  bool? get seen => _seen;
  num? get distance => _distance;
  bool? get current => _current;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['price'] = _price;
    map['currency_price'] = _currencyPrice;
    map['rate'] = _rate;
    map['order_details_count'] = _orderDetailsCount;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_currency != null) {
      map['currency'] = _currency?.toJson();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_details != null) {
      map['details'] = _details?.map((v) => v.toJson()).toList();
    }
    if (_review != null) {
      map['review'] = _review?.toJson();
    }
    map['status'] = _status;
    map['tips'] = _tips;
    map['commission_fee'] = _commissionFee;
    map['delivery_type'] = _deliveryType;
    map['delivery_fee'] = _deliveryFee;
    map['otp'] = _otp;
    map['deliveryman'] = _deliveryman;
    map['delivery_date'] = _deliveryDate;
    map['delivery_time'] = _deliveryTime;
    if (_transaction != null) {
      map['transaction'] = _transaction?.toJson();
    }
    if (_orderAddress != null) {
      map['address'] = _orderAddress?.toJson();
    }
    map['note'] = _note;
    map['image_after_delivered'] = _afterDeliveredImage;
    map['seen'] = _seen;
    map['km'] = _distance;
    map['current'] = _current;
    return map;
  }
}

class ShopOrderDetails {
  ShopOrderDetails({
    String? id,
    String? shopId,
    num? deliveryFee,
    num? price,
    num? tax,
    String? status,
    String? deliveryDate,
    String? deliveryTime,
    String? createdAt,
    String? updatedAt,
    List<OrderStocks>? orderStocks,
    CouponData? coupon,
    dynamic deliveryman,
    DeliveryType? deliveryType,
    // List<dynamic>? transactions,
    ShopData? shop,
  }) {
    _id = id;
    _shopId = shopId;
    _deliveryFee = deliveryFee;
    _price = price;
    _tax = tax;
    _status = status;
    _deliveryDate = deliveryDate;
    _deliveryTime = deliveryTime;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _orderStocks = orderStocks;
    _coupon = coupon;
    _deliveryman = deliveryman;
    _deliveryType = deliveryType;
    // _transactions = transactions;
    _shop = shop;
  }

  ShopOrderDetails.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _shopId = json['shop_id']?.toString();
    _deliveryFee = json['delivery_fee'];
    _price = json['price'];
    _tax = json['tax'];
    _status = json['status'];
    _deliveryDate = json['delivery_date'];
    _deliveryTime = json['delivery_time'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['order_stocks'] != null) {
      _orderStocks = [];
      json['order_stocks'].forEach((v) {
        _orderStocks?.add(OrderStocks.fromJson(v));
      });
    }
    _coupon =
        json['coupon'] != null ? CouponData.fromJson(json['coupon']) : null;
    _deliveryman = json['deliveryman'];
    _deliveryType = json['delivery_type'] != null
        ? DeliveryType.fromJson(json['delivery_type'])
        : null;
    _shop = json['shop'] != null ? ShopData.fromJson(json['shop']) : null;
  }

  String? _id;
  String? _shopId;
  num? _deliveryFee;
  num? _price;
  num? _tax;
  String? _status;
  String? _deliveryDate;
  String? _deliveryTime;
  String? _createdAt;
  String? _updatedAt;
  List<OrderStocks>? _orderStocks;
  CouponData? _coupon;
  dynamic _deliveryman;
  DeliveryType? _deliveryType;
  ShopData? _shop;

  ShopOrderDetails copyWith({
    String? id,
    String? shopId,
    num? deliveryFee,
    num? price,
    num? tax,
    String? status,
    String? deliveryDate,
    String? deliveryTime,
    String? createdAt,
    String? updatedAt,
    List<OrderStocks>? orderStocks,
    CouponData? coupon,
    dynamic deliveryman,
    DeliveryType? deliveryType,
    ShopData? shop,
  }) =>
      ShopOrderDetails(
        id: id ?? _id,
        shopId: shopId ?? _shopId,
        deliveryFee: deliveryFee ?? _deliveryFee,
        price: price ?? _price,
        tax: tax ?? _tax,
        status: status ?? _status,
        deliveryDate: deliveryDate ?? _deliveryDate,
        deliveryTime: deliveryTime ?? _deliveryTime,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        orderStocks: orderStocks ?? _orderStocks,
        coupon: coupon ?? _coupon,
        deliveryman: deliveryman ?? _deliveryman,
        deliveryType: deliveryType ?? _deliveryType,
        shop: shop ?? _shop,
      );

  String? get id => _id;
  String? get shopId => _shopId;
  num? get deliveryFee => _deliveryFee;
  num? get price => _price;
  num? get tax => _tax;
  String? get status => _status;
  String? get deliveryDate => _deliveryDate;
  String? get deliveryTime => _deliveryTime;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<OrderStocks>? get orderStocks => _orderStocks;
  CouponData? get coupon => _coupon;
  dynamic get deliveryman => _deliveryman;
  DeliveryType? get deliveryType => _deliveryType;
  ShopData? get shop => _shop;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['shop_id'] = _shopId;
    map['delivery_fee'] = _deliveryFee;
    map['price'] = _price;
    map['tax'] = _tax;
    map['status'] = _status;
    map['delivery_date'] = _deliveryDate;
    map['delivery_time'] = _deliveryTime;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_orderStocks != null) {
      map['order_stocks'] = _orderStocks?.map((v) => v.toJson()).toList();
    }
    map['deliveryman'] = _deliveryman;
    if (_deliveryType != null) {
      map['delivery_type'] = _deliveryType?.toJson();
    }
    if (_shop != null) {
      map['shop'] = _shop?.toJson();
    }
    return map;
  }
}

class OrderStocks {
  OrderStocks({
    String? id,
    String? stockId,
    num? originPrice,
    num? tax,
    num? discount,
    int? quantity,
    num? totalPrice,
    String? createdAt,
    String? updatedAt,
    Stocks? stock,
    String? status,
    bool? bonus,
    bool? shopBonus,
    dynamic kitchen,
    List<AddonData>? addons,
    String? note,
  }) {
    _id = id;
    _stockId = stockId;
    _originPrice = originPrice;
    _tax = tax;
    _discount = discount;
    _quantity = quantity;
    _totalPrice = totalPrice;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _stock = stock;
    _status = status;
    _bonus = bonus;
    _shopBonus = shopBonus;
    _kitchen = kitchen;
    _addons = addons;
    _note = note;
  }

  OrderStocks.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _stockId = json['stock_id']?.toString();
    _originPrice = json['origin_price'];
    _tax = json['tax'];
    _discount = json['discount'];
    _quantity = json['quantity'];
    _totalPrice = json['total_price'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _stock = json['stock'] != null ? Stocks.fromJson(json['stock']) : null;
    _status = json['status'];
    _bonus = json['bonus'] is int ? (json['bonus'] != 0) : json['bonus'];
    _shopBonus = json['bonus_shop'] is int ? (json['bonus_shop'] != 0) : json['bonus_shop'];
    _kitchen = json['kitchen'];
    if (json['addons'] != null) {
      _addons = [];
      json['addons'].forEach((v) {
        _addons?.add(AddonData.fromJson(v));
      });
    }
    _note = json['note'];
  }

  String? _id;
  String? _stockId;
  num? _originPrice;
  num? _tax;
  num? _discount;
  int? _quantity;
  num? _totalPrice;
  String? _createdAt;
  String? _updatedAt;
  Stocks? _stock;
  String? _status;
  bool? _bonus;
  bool? _shopBonus;
  dynamic _kitchen;
  List<AddonData>? _addons;
  String? _note;

  OrderStocks copyWith({
    String? id,
    String? stockId,
    num? originPrice,
    num? tax,
    num? discount,
    int? quantity,
    num? totalPrice,
    String? createdAt,
    String? updatedAt,
    Stocks? stock,
    String? status,
    bool? bonus,
    bool? shopBonus,
    dynamic kitchen,
    List<AddonData>? addons,
    String? note,
  }) =>
      OrderStocks(
        id: id ?? _id,
        stockId: stockId ?? _stockId,
        originPrice: originPrice ?? _originPrice,
        tax: tax ?? _tax,
        discount: discount ?? _discount,
        quantity: quantity ?? _quantity,
        totalPrice: totalPrice ?? _totalPrice,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        stock: stock ?? _stock,
        status: status ?? _status,
        bonus: bonus ?? _bonus,
        shopBonus: shopBonus ?? _shopBonus,
        kitchen: kitchen ?? _kitchen,
        addons: addons ?? _addons,
        note: note ?? _note,
      );

  String? get id => _id;
  String? get stockId => _stockId;
  num? get originPrice => _originPrice;
  num? get tax => _tax;
  num? get discount => _discount;
  int? get quantity => _quantity;
  num? get totalPrice => _totalPrice;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Stocks? get stock => _stock;
  String? get status => _status;
  bool? get bonus => _bonus;
  bool? get shopBonus => _shopBonus;
  dynamic get kitchen => _kitchen;
  List<AddonData>? get addons => _addons;
  String? get note => _note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['stock_id'] = _stockId;
    map['origin_price'] = _originPrice;
    map['tax'] = _tax;
    map['discount'] = _discount;
    map['quantity'] = _quantity;
    map['total_price'] = _totalPrice;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_stock != null) {
      map['stock'] = _stock?.toJson();
    }
    map['status'] = _status;
    map['bonus'] = _bonus;
    map['bonus_shop'] = _shopBonus;
    map['kitchen'] = _kitchen;
    if (_addons != null) {
      map['addons'] = _addons?.map((v) => v.toJson()).toList();
    }
    map['note'] = _note;
    return map;
  }
}

class DeliveryType {
  DeliveryType({
    String? id,
    String? shopId,
    String? type,
    int? price,
    List<String>? times,
    String? note,
    bool? active,
    String? createdAt,
    String? updatedAt,
    Translation? translation,
  }) {
    _id = id;
    _shopId = shopId;
    _type = type;
    _price = price;
    _times = times;
    _note = note;
    _active = active;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _translation = translation;
  }

  DeliveryType.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _shopId = json['shop_id']?.toString();
    _type = json['type'];
    _price = json['price'];
    _times = json['times'] != null ? json['times'].cast<String>() : [];
    _note = json['note'];
    _active = json['active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
  }

  String? _id;
  String? _shopId;
  String? _type;
  int? _price;
  List<String>? _times;
  String? _note;
  bool? _active;
  String? _createdAt;
  String? _updatedAt;
  Translation? _translation;

  DeliveryType copyWith({
    String? id,
    String? shopId,
    String? type,
    int? price,
    List<String>? times,
    String? note,
    bool? active,
    String? createdAt,
    String? updatedAt,
    Translation? translation,
  }) =>
      DeliveryType(
        id: id ?? _id,
        shopId: shopId ?? _shopId,
        type: type ?? _type,
        price: price ?? _price,
        times: times ?? _times,
        note: note ?? _note,
        active: active ?? _active,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        translation: translation ?? _translation,
      );

  String? get id => _id;

  String? get shopId => _shopId;

  String? get type => _type;

  int? get price => _price;

  List<String>? get times => _times;

  String? get note => _note;

  bool? get active => _active;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Translation? get translation => _translation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['shop_id'] = _shopId;
    map['type'] = _type;
    map['price'] = _price;
    map['times'] = _times;
    map['note'] = _note;
    map['active'] = _active;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_translation != null) {
      map['translation'] = _translation?.toJson();
    }
    return map;
  }
}

class ProductNote {
  String stockId;
  String comment;

  ProductNote({required this.stockId, required this.comment});
}



