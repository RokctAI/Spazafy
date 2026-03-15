import 'extras_data.dart';
import 'discount_data.dart';
import 'addons_data.dart';
import 'bonus_data.dart';
import 'brand_data.dart';
import 'category_data.dart';
import 'unit_data.dart';
import 'review_data.dart';
import 'galleries.dart';
import 'shop_data.dart';
import 'translation.dart';

class ProductData {
  ProductData({
    String? id,
    String? uuid,
    String? shopId,
    String? categoryId,
    String? keywords,
    String? brandId,
    num? tax,
    num? interval,
    int? minQty,
    int? maxQty,
    bool? active,
    String? img,
    String? createdAt,
    String? updatedAt,
    num? ratingAvg,
    dynamic ordersCount,
    Translation? translation,
    List<Properties>? properties,
    List<Stocks>? stocks,
    ShopData? shop,
    CategoryData? category,
    BrandData? brand,
    Stocks? stock,
    UnitData? unit,
    List<ReviewData>? reviews,
    List<Galleries>? galleries,
    List<DiscountData>? discounts,
    int? count,
    String? barCode,
    String? status,
    String? type,
    bool? addon,
    dynamic kitchen,
    List<String>? locales,
    List<Translation>? translations,
    bool? isSelectedAddon,
    int? cartCount,
  }) {
    _id = id;
    _uuid = uuid;
    _shopId = shopId;
    _categoryId = categoryId;
    _keywords = keywords;
    _brandId = brandId;
    _tax = tax;
    _interval = interval;
    _minQty = minQty;
    _maxQty = maxQty;
    _active = active;
    _img = img;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _ratingAvg = ratingAvg;
    _ordersCount = ordersCount;
    _translation = translation;
    _properties = properties;
    _stocks = stocks;
    _shop = shop;
    _category = category;
    _brand = brand;
    _unit = unit;
    _reviews = reviews;
    _galleries = galleries;
    _count = count;
    _stock = stock;
    _discounts = discounts;
    _barCode = barCode;
    _status = status;
    _type = type;
    _addon = addon;
    _kitchen = kitchen;
    _locales = locales;
    _translations = translations;
    _isSelectedAddon = isSelectedAddon;
    _cartCount = cartCount;
  }

  ProductData.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _uuid = json['uuid'];
    _shopId = json['shop_id']?.toString();
    _categoryId = json['category_id']?.toString();
    _keywords = json['keywords'];
    _brandId = json['brand_id']?.toString();
    _tax = json['tax'] != null ? num.tryParse(json['tax'].toString()) : null;
    _interval = json['interval'];
    _minQty = json['min_qty'] != null
        ? int.tryParse(json['min_qty'].toString())
        : null;
    _maxQty = json['max_qty'] != null
        ? int.tryParse(json['max_qty'].toString())
        : null;
    _img = json['img'] ?? json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _ratingAvg = json['rating_avg'];
    _ordersCount = json['orders_count'];
    _count = 0;
    _cartCount = json['cart_count'] ?? 0;
    _barCode = json['bar_code'];
    _status = json['status'];
    _type = json['type'];
    _addon = json['addon'];
    _locales =
        json['locales'] != null ? List<String>.from(json['locales']) : [];
    _isSelectedAddon = false;
    _unit = json['unit'] != null ? UnitData.fromJson(json['unit']) : null;
    _translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
    _stock = json['stock'] != null ? Stocks.fromJson(json['stock']) : null;
    _kitchen = json['kitchen'];
    _category = json['category'] != null
        ? CategoryData.fromJson(json['category'])
        : null;
    _brand = json['brand'] != null ? BrandData.fromJson(json['brand']) : null;
    if (json['stocks'] != null) {
      _stocks = [];
      json['stocks'].forEach((v) {
        _stocks?.add(Stocks.fromJson(v));
      });
    }
    if (json['discounts'] != null) {
      _discounts = [];
      json['discounts'].forEach((v) {
        _discounts?.add(DiscountData.fromJson(v));
      });
    }
    if (json['galleries'] != null) {
      _galleries = [];
      json['galleries'].forEach((v) {
        _galleries?.add(Galleries.fromJson(v));
      });
    }
    if (json['translations'] != null) {
      _translations = [];
      json['translations'].forEach((v) {
        _translations?.add(Translation.fromJson(v));
      });
    }
  }

  String? _id;
  String? _uuid;
  String? _shopId;
  String? _categoryId;
  String? _keywords;
  String? _brandId;
  num? _tax;
  num? _interval;
  int? _minQty;
  int? _maxQty;
  bool? _active;
  String? _img;
  String? _createdAt;
  String? _updatedAt;
  num? _ratingAvg;
  dynamic _ordersCount;
  Translation? _translation;
  List<Properties>? _properties;
  List<Stocks>? _stocks;
  ShopData? _shop;
  CategoryData? _category;
  BrandData? _brand;
  UnitData? _unit;
  Stocks? _stock;
  List<ReviewData>? _reviews;
  List<Galleries>? _galleries;
  List<DiscountData>? _discounts;
  String? _barCode;
  String? _status;
  String? _type;
  bool? _addon;
  dynamic _kitchen;
  List<String>? _locales;
  List<Translation>? _translations;
  bool? _isSelectedAddon;
  int? _cartCount;
  int? _count;

  ProductData copyWith({
    String? id,
    String? uuid,
    String? shopId,
    String? categoryId,
    String? keywords,
    String? brandId,
    num? tax,
    num? interval,
    int? minQty,
    int? maxQty,
    bool? active,
    String? img,
    String? createdAt,
    String? updatedAt,
    num? ratingAvg,
    dynamic ordersCount,
    Translation? translation,
    List<Properties>? properties,
    List<Stocks>? stocks,
    ShopData? shop,
    Stocks? stock,
    CategoryData? category,
    BrandData? brand,
    UnitData? unit,
    List<ReviewData>? reviews,
    List<Galleries>? galleries,
    String? barCode,
    String? status,
    String? type,
    bool? addon,
    dynamic kitchen,
    List<String>? locales,
    List<Translation>? translations,
    bool? isSelectedAddon,
    int? cartCount,
  }) =>
      ProductData(
        id: id ?? _id,
        uuid: uuid ?? _uuid,
        stock: stock ?? _stock,
        shopId: shopId ?? _shopId,
        categoryId: categoryId ?? _categoryId,
        keywords: keywords ?? _keywords,
        brandId: brandId ?? _brandId,
        tax: tax ?? _tax,
        interval: interval ?? _interval,
        minQty: minQty ?? _minQty,
        maxQty: maxQty ?? _maxQty,
        active: active ?? _active,
        img: img ?? _img,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        ratingAvg: ratingAvg ?? _ratingAvg,
        ordersCount: ordersCount ?? _ordersCount,
        translation: translation ?? _translation,
        properties: properties ?? _properties,
        stocks: stocks ?? _stocks,
        shop: shop ?? _shop,
        category: category ?? _category,
        brand: brand ?? _brand,
        unit: unit ?? _unit,
        reviews: reviews ?? _reviews,
        galleries: galleries ?? _galleries,
        barCode: barCode ?? _barCode,
        status: status ?? _status,
        type: type ?? _type,
        addon: addon ?? _addon,
        kitchen: kitchen ?? _kitchen,
        locales: locales ?? _locales,
        translations: translations ?? _translations,
        isSelectedAddon: isSelectedAddon ?? _isSelectedAddon,
        cartCount: cartCount ?? _cartCount,
      );

  String? get id => _id;
  String? get uuid => _uuid;
  String? get shopId => _shopId;
  String? get categoryId => _categoryId;
  String? get keywords => _keywords;
  String? get brandId => _brandId;
  num? get tax => _tax;
  num? get interval => _interval;
  int? get minQty => _minQty;
  int? get maxQty => _maxQty;
  bool? get active => _active;
  String? get img => _img;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get ratingAvg => _ratingAvg;
  dynamic get ordersCount => _ordersCount;
  Translation? get translation => _translation;
  Stocks? get stock => _stock;
  List<Properties>? get properties => _properties;
  List<Stocks>? get stocks => _stocks;
  List<DiscountData>? get discounts => _discounts;
  ShopData? get shop => _shop;
  CategoryData? get category => _category;
  BrandData? get brand => _brand;
  UnitData? get unit => _unit;
  int? get count => _count;
  List<ReviewData>? get reviews => _reviews;
  List<Galleries>? get galleries => _galleries;
  String? get barCode => _barCode;
  String? get status => _status;
  String? get type => _type;
  bool? get addon => _addon;
  dynamic get kitchen => _kitchen;
  List<String>? get locales => _locales;
  List<Translation>? get translations => _translations;
  bool? get isSelectedAddon => _isSelectedAddon;
  int? get cartCount => _cartCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uuid'] = _uuid;
    map['shop_id'] = _shopId;
    map['category_id'] = _categoryId;
    map['keywords'] = _keywords;
    map['brand_id'] = _brandId;
    map['tax'] = _tax;
    map['interval'] = _interval;
    map['min_qty'] = _minQty;
    map['max_qty'] = _maxQty;
    map['active'] = _active;
    map['img'] = _img;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['stock'] = _stock?.toJson();
    map['rating_avg'] = _ratingAvg;
    map['orders_count'] = _ordersCount;
    map['bar_code'] = _barCode;
    map['status'] = _status;
    map['type'] = _type;
    map['addon'] = _addon;
    map['kitchen'] = _kitchen;
    map['locales'] = _locales;
    map['cart_count'] = _cartCount;
    if (_translation != null) {
      map['translation'] = _translation?.toJson();
    }
    if (_properties != null) {
      map['properties'] = _properties?.map((v) => v.toJson()).toList();
    }
    if (_stocks != null) {
      map['stocks'] = _stocks?.map((v) => v.toJson()).toList();
    }
    if (_shop != null) {
      map['shop'] = _shop?.toJson();
    }
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    if (_brand != null) {
      map['brand'] = _brand?.toJson();
    }
    if (_unit != null) {
      map['unit'] = _unit?.toJson();
    }
    if (_reviews != null) {
      map['reviews'] = _reviews?.map((v) => v.toJson()).toList();
    }
    if (_galleries != null) {
      map['galleries'] = _galleries?.map((v) => v.toJson()).toList();
    }
    if (_discounts != null) {
      map['discounts'] = _discounts?.map((v) => v.toJson()).toList();
    }
    if (_translations != null) {
      map['translations'] = _translations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Stocks {
  Stocks({
    String? id,
    String? countableId,
    num? price,
    int? quantity,
    num? discount,
    num? tax,
    num? totalPrice,
    BonusModel? bonus,
    List<Extras>? extras,
    List<AddonData>? addons,
    ProductData? product,
    num? costPrice,
    num? purchasePrice,
    String? sku,
    String? countableType,
    bool? shopBonus,
    int? cartCount,
  }) {
    _bonus = bonus;
    _id = id;
    _countableId = countableId;
    _price = price;
    _quantity = quantity;
    _discount = discount;
    _tax = tax;
    _totalPrice = totalPrice;
    _extras = extras;
    _addons = addons;
    _product = product;
    _costPrice = costPrice;
    _purchasePrice = purchasePrice;
    _sku = sku;
    _countableType = countableType;
    _shopBonus = shopBonus;
    _cartCount = cartCount;
  }

  Stocks.fromJson(dynamic json) {
    _bonus = json["bonus"] == null ? null : BonusModel.fromJson(json["bonus"]);
    _id = json['id']?.toString();
    _countableId = json['countable_id']?.toString();
    _price = json['price'];
    _quantity = json['quantity'];
    _discount = json['discount'];
    _tax = json['tax'];
    _totalPrice = json['total_price'];
    _costPrice = json['cost_price'];
    _purchasePrice = json['purchase_price'];
    _sku = json['sku'];
    _countableType = json['countable_type'];
    _cartCount = json['cart_count'] ?? 0;
    _shopBonus = json['bonus_shop'] is bool
        ? json['bonus_shop']
        : (json['bonus_shop']?.toString() == "1");

    if (json['extras'] != null) {
      _extras = [];
      if (json['extras'].runtimeType != bool) {
        json['extras'].forEach((v) {
          _extras?.add(Extras.fromJson(v));
        });
      }
    }
    if (json['stock_extras'] != null) {
      _extras = [];
      json['stock_extras'].forEach((v) {
        _extras?.add(Extras.fromJson(v));
      });
    }
    if (json['addons'] != null) {
      _addons = [];
      json['addons'].forEach((v) {
        _addons?.add(AddonData.fromJson(v));
      });
    }
    _product =
        json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }

  String? _id;
  String? _countableId;
  num? _price;
  int? _quantity;
  num? _discount;
  num? _tax;
  BonusModel? _bonus;
  num? _totalPrice;
  List<Extras>? _extras;
  ProductData? _product;
  List<AddonData>? _addons;
  num? _costPrice;
  num? _purchasePrice;
  String? _sku;
  String? _countableType;
  bool? _shopBonus;
  int? _cartCount;

  Stocks copyWith({
    String? id,
    String? countableId,
    num? price,
    int? quantity,
    num? discount,
    num? tax,
    BonusModel? bonus,
    num? totalPrice,
    List<Extras>? extras,
    List<AddonData>? addons,
    ProductData? product,
    num? costPrice,
    num? purchasePrice,
    String? sku,
    String? countableType,
    bool? shopBonus,
    int? cartCount,
  }) =>
      Stocks(
        bonus: bonus ?? _bonus,
        id: id ?? _id,
        countableId: countableId ?? _countableId,
        price: price ?? _price,
        quantity: quantity ?? _quantity,
        discount: discount ?? _discount,
        tax: tax ?? _tax,
        totalPrice: totalPrice ?? _totalPrice,
        extras: extras ?? _extras,
        product: product ?? _product,
        addons: addons ?? _addons,
        costPrice: costPrice ?? _costPrice,
        purchasePrice: purchasePrice ?? _purchasePrice,
        sku: sku ?? _sku,
        countableType: countableType ?? _countableType,
        shopBonus: shopBonus ?? _shopBonus,
        cartCount: cartCount ?? _cartCount,
      );

  String? get id => _id;
  String? get countableId => _countableId;
  num? get price => _price;
  int? get quantity => _quantity;
  num? get discount => _discount;
  num? get tax => _tax;
  num? get totalPrice => _totalPrice;
  BonusModel? get bonus => _bonus;
  List<AddonData>? get addons => _addons;
  List<Extras>? get extras => _extras;
  ProductData? get product => _product;
  num? get costPrice => _costPrice;
  num? get purchasePrice => _purchasePrice;
  String? get sku => _sku;
  String? get countableType => _countableType;
  bool? get shopBonus => _shopBonus;
  int? get cartCount => _cartCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['countable_id'] = _countableId;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['discount'] = _discount;
    map['tax'] = _tax;
    map['total_price'] = _totalPrice;
    map['cost_price'] = _costPrice;
    map['purchase_price'] = _purchasePrice;
    map['sku'] = _sku;
    map['countable_type'] = _countableType;
    map['bonus_shop'] = _shopBonus;
    map['cart_count'] = _cartCount;
    if (_extras != null) {
      map['extras'] = _extras?.map((v) => v.toJson()).toList();
    }
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    if (_addons != null) {
      map['addons'] = _addons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
