import 'translation.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';

class ShopData {
  ShopData({
    this.id,
    this.userId,
    this.tax,
    this.pricePerKm,
    this.minPrice,
    this.percentage,
    this.phone,
    this.visibility,
    this.openTime,
    this.open,
    this.verify,
    this.closeTime,
    this.backgroundImg,
    this.logoImg,
    this.minAmount,
    this.status,
    this.type,
    this.deliveryTime,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.productsCount,
    this.translation,
    this.locales,
    this.seller,
    this.bonus,
    this.avgRate,
    this.rateCount,
    this.shopWorkingDays,
    this.isRecommend,
    this.isDiscount,
    this.tags,
    this.shopClosedDate,
    this.shopPayments,
    this.enableCod,
  });

  String? id;
  String? userId;
  num? tax;
  num? pricePerKm;
  num? minPrice;
  num? percentage;
  String? avgRate;
  String? rateCount;
  String? phone;
  bool? visibility;
  bool? isRecommend;
  bool? isDiscount;
  bool? open;
  bool? verify;
  String? openTime;
  String? closeTime;
  String? backgroundImg;
  String? logoImg;
  bool? enableCod;
  num? minAmount;
  ShopStatus? status;
  String? type;
  DeliveryTime? deliveryTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  Location? location;
  num? productsCount;
  Translation? translation;
  List<String>? locales;
  List<TagsModel>? tags;
  Seller? seller;
  BonusModel? bonus;
  List<ShopWorkingDay>? shopWorkingDays;
  List<ShopClosedDate>? shopClosedDate;
  List<ShopPayment?>? shopPayments;

  factory ShopData.fromJson(Map<String, dynamic> json) {
    bool? openValue;
    if (json["open"] != null) {
      if (json["open"] is bool) {
        openValue = json["open"];
      } else if (json["open"] is int) {
        openValue = json["open"] == 1;
      } else if (json["open"] is String) {
        openValue = json["open"] == '1' || json["open"].toLowerCase() == 'true';
      } else {
        openValue = false;
      }
    } else {
      openValue = true; // Default value
    }

    return ShopData(
      id: json["id"]?.toString(),
      // uuid: json["uuid"]?.toString() ?? 0.toString(),
      userId: json["user_id"]?.toString(),
      tax: json["tax"] ?? 0,
      pricePerKm: json["price_per_km"] ?? 0,
      minPrice: json["price"] ?? 0,
      percentage: json["percentage"] ?? 0,
      phone: json["phone"].toString(),
      visibility: json["visibility"],
      //open: (json["open"].runtimeType == int ? (json["open"] == 1) : json["open"]) ?? true,
      open: openValue,
      verify: (json["verify"].runtimeType == int
              ? (json["verify"] == 1)
              : json["verify"]) ??
          false,
      openTime: json["open_time"] ?? "00:00",
      closeTime: json["close_time"] ?? "00:00",
      backgroundImg: json["background_img"] ?? "",
      logoImg: json["logo_img"] ?? "",
      enableCod: json["enable_cod"] ??
          true, // Default to true if not present for backward compat
      minAmount: json["min_amount"] ?? 0,
      status: ShopStatusExtension.fromString(json["status"]),
      type: json["type"]?.toString(),
      isRecommend: json["is_recommended"] ?? false,
      isDiscount:
          json["discount"] == null ? false : json["discount"].isNotEmpty,
      deliveryTime: json["delivery_time"] == null
          ? null
          : DeliveryTime.fromJson(json["delivery_time"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"])?.toLocal(),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.tryParse(json["updated_at"])?.toLocal(),
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
      productsCount: json["products_count"] ?? 0,
      translation: json["translation"] == null
          ? null
          : Translation.fromJson(json["translation"]),
      tags: json["tags"] == null
          ? null
          : List<TagsModel>.from(
              json["tags"].map((x) => TagsModel.fromJson(x)),
            ),
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      avgRate: (double.tryParse(json["rating_avg"].toString()) ?? 0.0)
          .toStringAsFixed(1),
      rateCount: (double.tryParse(json["reviews_count"].toString()) ?? 0.0)
          .toStringAsFixed(0),
      bonus: json["bonus"] != null ? BonusModel.fromJson(json["bonus"]) : null,
      shopWorkingDays: json["shop_working_days"] != null
          ? List<ShopWorkingDay>.from(
              json["shop_working_days"].map((x) => ShopWorkingDay.fromJson(x)),
            )
          : [],
      shopClosedDate: json["shop_closed_date"] != null
          ? List<ShopClosedDate>.from(
              json["shop_closed_date"].map((x) => ShopClosedDate.fromJson(x)),
            )
          : [],
      shopPayments: json["shop_payments"] == null
          ? []
          : List<ShopPayment?>.from(
              json["shop_payments"]!.map((x) {
                if (x["payment"]["active"]) {
                  return ShopPayment.fromJson(x);
                }
              }),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "tax": tax,
        "price_per_km": pricePerKm,
        "price": minPrice,
        "percentage": percentage,
        "phone": phone,
        "visibility": visibility,
        "open_time": openTime,
        "close_time": closeTime,
        "background_img": backgroundImg,
        "logo_img": logoImg,
        "min_amount": minAmount,
        "status": status?.name,
        "type": type,
        "delivery_time": deliveryTime?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "location": location?.toJson(),
        "products_count": productsCount,
        "translation": translation?.toJson(),
        "locales":
            locales == null ? null : List<dynamic>.from(locales!.map((x) => x)),
        "seller": seller?.toJson(),
        "bonus": bonus,
        "enable_cod": enableCod,
      };

  /// Local logic to check if shop is open based on working hours. 
  /// Essential for 'Blind Availability' offline resilience.
  Map<String, dynamic> checkWorkingDay() {
    if (this.open == false) return {"isOpen": false};
    if (shopWorkingDays == null || shopWorkingDays!.isEmpty) {
      return {"isOpen": this.open ?? true};
    }

    final now = DateTime.now();
    final dayName = _dayName(now).toLowerCase();

    // 1. Check if today is a working day
    final workingDay = shopWorkingDays!.firstWhere(
      (d) => d.day?.name == dayName && !(d.disabled ?? true),
      orElse: () => ShopWorkingDay(),
    );
    if (workingDay.day == null) return {"isOpen": false};

    // 2. Check for specific closed dates (holidays/etc)
    if (shopClosedDate != null) {
      for (final closed in shopClosedDate!) {
        if (closed.day != null &&
            closed.day!.year == now.year &&
            closed.day!.month == now.month &&
            closed.day!.day == now.day) {
          return {"isOpen": false};
        }
      }
    }

    // 3. Check time slots (format: "HH-mm")
    try {
      final fromStr = workingDay.from ?? "";
      final toStr = workingDay.to ?? "";
      if (fromStr.isEmpty || toStr.isEmpty) return {"isOpen": true};

      final startHour = int.tryParse(fromStr.substring(0, fromStr.indexOf("-"))) ?? 0;
      final startMin = int.tryParse(fromStr.substring(fromStr.indexOf("-") + 1)) ?? 0;
      final endHour = int.tryParse(toStr.substring(0, toStr.indexOf("-"))) ?? 0;
      final endMin = int.tryParse(toStr.substring(toStr.indexOf("-") + 1)) ?? 0;

      final start = DateTime(now.year, now.month, now.day, startHour, startMin);
      final end = DateTime(now.year, now.month, now.day, endHour, endMin);

      // Handle overnight shops (e.g., 22:00 to 02:00)
      if (end.isBefore(start)) {
        if (now.isAfter(start) || now.isBefore(end)) {
          return {"isOpen": true, "startTodayTime": start, "endTodayTime": end};
        }
      } else {
        if (now.isAfter(start) && now.isBefore(end)) {
          return {"isOpen": true, "startTodayTime": start, "endTodayTime": end};
        }
      }
      return {"isOpen": false, "startTodayTime": start, "endTodayTime": end};
    } catch (e) {
      return {"isOpen": true}; // Fallback to open if metadata is corrupt
    }
  }

  String _dayName(DateTime date) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[date.weekday - 1];
  }
}

class DeliveryTime {
  DeliveryTime({this.to, this.from, this.type});

  String? to;
  String? from;
  String? type;

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
        to: json["to"].toString(),
        from: json["from"].toString(),
        type: json["type"] ?? "min",
      );

  Map<String, dynamic> toJson() => {"to": to, "from": from, "type": type};
}

class Location {
  Location({this.latitude, this.longitude});

  double? latitude;
  double? longitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: double.tryParse(json["latitude"].toString()),
        longitude: double.tryParse(json["longitude"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Seller {
  Seller({this.id, this.firstname, this.lastname, this.active, this.role});

  String? id;
  String? firstname;
  String? lastname;
  bool? active;
  String? role;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"]?.toString(),
        firstname: json["firstname"],
        lastname: json["lastname"],
        active: json["active"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "active": active,
        "role": role,
      };
}

class ShopClosedDate {
  ShopClosedDate({this.id, this.day, this.createdAt, this.updatedAt});

  num? id;
  DateTime? day;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ShopClosedDate.fromJson(Map<String, dynamic>? json) => ShopClosedDate(
        id: json?["id"],
        day: DateTime.tryParse(json?["day"])?.toLocal(),
        createdAt: DateTime.tryParse(json?["created_at"])?.toLocal(),
        updatedAt: DateTime.tryParse(json?["updated_at"])?.toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day":
            "${day!.year.toString().padLeft(4, '0')}-${day!.month.toString().padLeft(2, '0')}-${day!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class ShopWorkingDay {
  ShopWorkingDay({
    this.id,
    this.day,
    this.from,
    this.to,
    this.disabled,
    this.createdAt,
    this.updatedAt,
  });

  num? id;
  DayOfWeek? day;
  String? from;
  bool? disabled;
  String? to;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ShopWorkingDay.fromJson(Map<String, dynamic>? json) => ShopWorkingDay(
        id: json?["id"],
        day: DayOfWeekExtension.fromString(json?["day"]),
        from: json?["from"],
        disabled: json?["disabled"],
        to: json?["to"],
        createdAt: DateTime.tryParse(json?["created_at"])?.toLocal(),
        updatedAt: DateTime.tryParse(json?["updated_at"])?.toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day?.name,
        "from": from,
        "to": to,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class ShopPayment {
  ShopPayment({
    this.id,
    this.shopId,
    this.status,
    this.clientId,
    this.secretId,
    this.payment,
  });

  String? id;
  String? shopId;
  int? status;
  dynamic clientId;
  dynamic secretId;
  Payment? payment;

  factory ShopPayment.fromJson(Map<String, dynamic> json) {
    return ShopPayment(
      id: json["id"]?.toString(),
      shopId: json["shop_id"]?.toString(),
      status: json["status"],
      clientId: json["client_id"]?.toString(),
      secretId: json["secret_id"]?.toString(),
      payment: Payment.fromJson(json["payment"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "status": status,
        "client_id": clientId,
        "secret_id": secretId,
        "payment": payment!.toJson(),
      };
}

class Payment {
  Payment({this.id, this.tag, this.active, this.translation, this.locales});

  String? id;
  String? tag;
  bool? active;
  dynamic translation;
  List<dynamic>? locales;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"]?.toString(),
        tag: json["tag"],
        active: json["active"],
        translation: json["translation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "active": active,
        "translation": translation,
        "locales":
            locales == null ? [] : List<dynamic>.from(locales!.map((x) => x)),
      };
}

class TagsModel {
  String? id;
  String? img;
  Translation? translation;
  List<String>? locales;

  TagsModel({this.id, this.img, this.translation, this.locales});

  TagsModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    img = json['img'];
    translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['img'] = img;
    if (translation != null) {
      data['translation'] = translation!.toJson();
    }
    data['locales'] = locales;
    return data;
  }
}
