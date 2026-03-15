import 'address_new_data.dart';
import 'shop_data.dart';
import 'currency_data.dart';

class UserModel {
  UserModel({
    String? id,
    String? uuid,
    String? firstname,
    String? lastname,
    String? referral,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? emailVerifiedAt,
    String? registeredAt,
    bool? active,
    String? img,
    String? role,
    String? password,
    String? confirmPassword,
    List<AddressNewModel>? addresses,
    ShopData? shop,
    Wallet? wallet,
    num? rate,
    List<List<double>>? deliveryZone,
  }) {
    _id = id;
    _uuid = uuid;
    _firstname = firstname;
    _lastname = lastname;
    _referral = referral;
    _email = email;
    _phone = phone;
    _birthday = birthday;
    _gender = gender;
    _emailVerifiedAt = emailVerifiedAt;
    _registeredAt = registeredAt;
    _active = active;
    _img = img;
    _role = role;
    _password = password;
    _addresses = addresses;
    _confirmPassword = confirmPassword;
    _shop = shop;
    _wallet = wallet;
    _rate = rate;
    _deliveryZone = deliveryZone;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _uuid = json['uuid'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _email = json['email'];
    _phone = json['phone'];
    _birthday = json['birthday'];
    _gender = json['gender'];
    _emailVerifiedAt = json['email_verified_at'];
    _registeredAt = json['registered_at'];
    _active = json['active'] is int ? (json['active'] != 0) : json['active'];
    _img = json['img'];
    _role = json['role'];
    _rate = json["assign_reviews_avg_rating"];
    if (json['addresses'] != null) {
      _addresses = [];
      json['addresses'].forEach((v) {
        _addresses?.add(AddressNewModel.fromJson(v));
      });
    }
    _shop = json['shop'] != null ? ShopData.fromJson(json['shop']) : null;
    _wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    _deliveryZone = json["delivery_man_delivery_zone"] == null
        ? []
        : List<List<double>>.from(
            json["delivery_man_delivery_zone"]!.map(
              (x) => List<double>.from(x.map((x) => x?.toDouble())),
            ),
          );
  }

  String? _id;
  String? _uuid;
  String? _firstname;
  String? _lastname;
  String? _referral;
  String? _email;
  String? _phone;
  String? _birthday;
  String? _gender;
  String? _emailVerifiedAt;
  String? _registeredAt;
  bool? _active;
  String? _img;
  String? _role;
  String? _password;
  String? _confirmPassword;
  List<AddressNewModel>? _addresses;
  ShopData? _shop;
  Wallet? _wallet;
  num? _rate;
  List<List<double>>? _deliveryZone;

  UserModel copyWith({
    String? id,
    String? uuid,
    String? firstname,
    String? lastname,
    String? referral,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? emailVerifiedAt,
    String? registeredAt,
    bool? active,
    String? img,
    String? role,
    String? password,
    String? conPassword,
    List<AddressNewModel>? addresses,
    ShopData? shop,
    Wallet? wallet,
    num? rate,
    List<List<double>>? deliveryZone,
  }) =>
      UserModel(
        id: id ?? _id,
        uuid: uuid ?? _uuid,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname,
        referral: referral ?? _referral,
        email: email ?? _email,
        phone: phone ?? _phone,
        birthday: birthday ?? _birthday,
        gender: gender ?? _gender,
        emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
        registeredAt: registeredAt ?? _registeredAt,
        active: active ?? _active,
        img: img ?? _img,
        role: role ?? _role,
        confirmPassword: conPassword ?? _confirmPassword,
        password: password ?? _password,
        addresses: addresses ?? _addresses,
        shop: shop ?? _shop,
        wallet: wallet ?? _wallet,
        rate: rate ?? _rate,
        deliveryZone: deliveryZone ?? _deliveryZone,
      );

  String? get id => _id;
  String? get uuid => _uuid;
  String? get firstname => _firstname;
  String? get lastname => _lastname;
  String? get referral => _referral;
  String? get email => _email;
  String? get phone => _phone;
  String? get birthday => _birthday;
  String? get gender => _gender;
  String? get emailVerifiedAt => _emailVerifiedAt;
  String? get registeredAt => _registeredAt;
  bool? get active => _active;
  String? get img => _img;
  String? get role => _role;
  List<AddressNewModel>? get addresses => _addresses;
  String? get password => _password;
  String? get conPassword => _confirmPassword;
  ShopData? get shop => _shop;
  Wallet? get wallet => _wallet;
  num? get rate => _rate;
  List<List<double>>? get deliveryZone => _deliveryZone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uuid'] = _uuid;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['referral'] = _referral;
    map['email'] = _email;
    map['phone'] = _phone;
    map['birthday'] = _birthday;
    map['gender'] = _gender;
    map['email_verified_at'] = _emailVerifiedAt;
    map['registered_at'] = _registeredAt;
    map['active'] = _active;
    map['img'] = _img;
    map['role'] = _role;
    if (_addresses != null) {
      map['addresses'] = _addresses?.map((v) => v.toJson()).toList();
    }
    if (_shop != null) {
      map['shop'] = _shop?.toJson();
    }
    if (_wallet != null) {
      map['wallet'] = _wallet?.toJson();
    }
    map['assign_reviews_avg_rating'] = _rate;
    map['delivery_man_delivery_zone'] = _deliveryZone == null
        ? []
        : List<dynamic>.from(
            _deliveryZone!.map((x) => List<dynamic>.from(x.map((x) => x))),
          );
    return map;
  }

  Map<String, dynamic> toJsonForSignUp({typeFirebase = false}) => {
        "firstname": _firstname,
        if (_lastname?.isNotEmpty ?? false) "lastname": _lastname,
        if (_phone?.isNotEmpty ?? false) "phone": _phone?.replaceAll('+', ""),
        if (_email?.isNotEmpty ?? false) "email": _email,
        if (_password?.isNotEmpty ?? false) "password": _password,
        if (_confirmPassword?.isNotEmpty ?? false)
          "password_conformation": _confirmPassword,
        if (_referral?.isNotEmpty ?? false) 'referral': _referral,
        if (typeFirebase) "type": "firebase",
      };
}

class Wallet {
  Wallet({
    String? uuid,
    String? userId,
    String? currencyId,
    num? price,
    String? symbol,
    String? createdAt,
    String? updatedAt,
    CurrencyData? currency,
  }) {
    _uuid = uuid;
    _userId = userId;
    _currencyId = currencyId;
    _price = price;
    _symbol = symbol;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _currency = currency;
  }

  Wallet.fromJson(dynamic json) {
    _uuid = json['uuid'];
    _userId = json['user_id']?.toString();
    _currencyId = json['currency_id']?.toString();
    _price = json['price'];
    _symbol = json['symbol'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _currency = json['currency'] != null
        ? CurrencyData.fromJson(json['currency'])
        : null;
  }

  String? _uuid;
  String? _userId;
  String? _currencyId;
  num? _price;
  String? _symbol;
  String? _createdAt;
  String? _updatedAt;
  CurrencyData? _currency;

  Wallet copyWith({
    String? uuid,
    String? userId,
    String? currencyId,
    num? price,
    String? symbol,
    String? createdAt,
    String? updatedAt,
    CurrencyData? currency,
  }) =>
      Wallet(
        uuid: uuid ?? _uuid,
        userId: userId ?? _userId,
        currencyId: currencyId ?? _currencyId,
        price: price ?? _price,
        symbol: symbol ?? _symbol,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        currency: currency ?? _currency,
      );

  String? get uuid => _uuid;
  String? get userId => _userId;
  String? get currencyId => _currencyId;
  num? get price => _price;
  String? get symbol => _symbol;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  CurrencyData? get currency => _currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = _uuid;
    map['user_id'] = _userId;
    map['currency_id'] = _currencyId;
    map['price'] = _price;
    map['symbol'] = _symbol;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_currency != null) {
      map['currency'] = _currency?.toJson();
    }
    return map;
  }
}
