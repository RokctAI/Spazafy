import 'translation.dart';

class KitchenModel {
  String? id;
  int? active;
  String? shopId;
  Translation? translation;

  KitchenModel({this.id, this.active, this.shopId, this.translation});

  KitchenModel copyWith({
    String? id,
    int? active,
    String? shopId,
    Translation? translation,
  }) => KitchenModel(
    id: id ?? this.id,
    active: active ?? this.active,
    shopId: shopId ?? this.shopId,
    translation: translation ?? this.translation,
  );

  factory KitchenModel.fromJson(Map<String, dynamic> json) => KitchenModel(
    id: json["id"]?.toString(),
    active: json["active"],
    shopId: json["shop_id"]?.toString(),
    translation: json["translation"] == null
        ? null
        : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "shop_id": shopId,
    "translation": translation?.toJson(),
  };
}
