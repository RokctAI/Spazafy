import 'translation.dart';

class UnitData {
  UnitData({
    String? id,
    bool? active,
    String? position,
    Translation? translation,
    List<String>? locales,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _active = active;
    _position = position;
    _translation = translation;
    _locales = locales;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  UnitData.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _active = json['active'] is bool ? json['active'] : (json['active'] == 1);
    _position = json['position']?.toString();
    _translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
    _locales =
        json['locales'] != null ? List<String>.from(json['locales']) : [];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _id;
  bool? _active;
  String? _position;
  Translation? _translation;
  List<String>? _locales;
  String? _createdAt;
  String? _updatedAt;

  UnitData copyWith({
    String? id,
    bool? active,
    String? position,
    Translation? translation,
    List<String>? locales,
    String? createdAt,
    String? updatedAt,
  }) =>
      UnitData(
        id: id ?? _id,
        active: active ?? _active,
        position: position ?? _position,
        translation: translation ?? _translation,
        locales: locales ?? _locales,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;
  bool? get active => _active;
  String? get position => _position;
  Translation? get translation => _translation;
  List<String>? get locales => _locales;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['active'] = _active;
    map['position'] = _position;
    if (_translation != null) {
      map['translation'] = _translation?.toJson();
    }
    map['locales'] = _locales;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
