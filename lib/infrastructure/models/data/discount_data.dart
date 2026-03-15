class Properties {
  Properties({String? locale, String? key, String? value}) {
    _locale = locale;
    _key = key;
    _value = value;
  }

  Properties.fromJson(dynamic json) {
    _locale = json['locale'];
    _key = json['key'];
    _value = json['value'];
  }

  String? _locale;
  String? _key;
  String? _value;

  Properties copyWith({String? locale, String? key, String? value}) =>
      Properties(
        locale: locale ?? _locale,
        key: key ?? _key,
        value: value ?? _value,
      );

  String? get locale => _locale;
  String? get key => _key;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['locale'] = _locale;
    map['key'] = _key;
    map['value'] = _value;
    return map;
  }
}

class DiscountData {
  String? id;
  String? shopId;
  String? type;
  num? price;
  DateTime? start;
  DateTime? end;
  int? active;
  String? img;
  DateTime? createdAt;
  DateTime? updatedAt;

  DiscountData({
    this.id,
    this.shopId,
    this.type,
    this.price,
    this.start,
    this.end,
    this.active,
    this.img,
    this.createdAt,
    this.updatedAt,
  });

  DiscountData copyWith({
    String? id,
    String? shopId,
    String? type,
    num? price,
    DateTime? start,
    DateTime? end,
    int? active,
    String? img,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      DiscountData(
        id: id ?? this.id,
        shopId: shopId ?? this.shopId,
        type: type ?? this.type,
        price: price ?? this.price,
        start: start ?? this.start,
        end: end ?? this.end,
        active: active ?? this.active,
        img: img ?? this.img,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory DiscountData.fromJson(Map<String, dynamic> json) => DiscountData(
        id: json["id"]?.toString(),
        shopId: json["shop_id"]?.toString(),
        type: json["type"],
        price: json["price"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        active: json["active"],
        img: json["img"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "type": type,
        "price": price,
        "start":
            "${start?.year.toString().padLeft(4, '0')}-${start?.month.toString().padLeft(2, '0')}-${start?.day.toString().padLeft(2, '0')}",
        "end":
            "${end?.year.toString().padLeft(4, '0')}-${end?.month.toString().padLeft(2, '0')}-${end?.day.toString().padLeft(2, '0')}",
        "active": active,
        "img": img,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
