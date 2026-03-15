import 'translation.dart';

class Group {
  Group({
    String? id,
    String? shopId,
    String? type,
    bool? isChecked,
    Translation? translation,
    List<Extras>? fetchedExtras,
    List<Extras>? extraValues,
  }) {
    _id = id;
    _shopId = shopId;
    _type = type;
    _isChecked = isChecked;
    _translation = translation;
    _fetchedExtras = fetchedExtras;
    _extraValues = extraValues;
  }

  Group.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _type = json['type'];
    _shopId = json['shop_id']?.toString();
    _isChecked = false;
    _translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
    _fetchedExtras = [];
    if (json['extra_values'] != null) {
      _extraValues = [];
      json['extra_values'].forEach((v) {
        _extraValues?.add(Extras.fromJson(v));
      });
    }
  }

  String? _id;
  String? _shopId;
  String? _type;
  bool? _isChecked;
  Translation? _translation;
  List<Extras>? _fetchedExtras;
  List<Extras>? _extraValues;

  Group copyWith({
    String? id,
    String? shopId,
    String? type,
    bool? isChecked,
    Translation? translation,
    List<Extras>? fetchedExtras,
    List<Extras>? extraValues,
  }) => Group(
    id: id ?? _id,
    shopId: shopId ?? _shopId,
    type: type ?? _type,
    isChecked: isChecked ?? _isChecked,
    translation: translation ?? _translation,
    fetchedExtras: fetchedExtras ?? _fetchedExtras,
    extraValues: extraValues ?? _extraValues,
  );

  String? get id => _id;
  String? get shopId => _shopId;
  String? get type => _type;
  bool? get isChecked => _isChecked;
  Translation? get translation => _translation;
  List<Extras>? get fetchedExtras => _fetchedExtras;
  List<Extras>? get extraValues => _extraValues;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['shop_id'] = _shopId;
    map['type'] = _type;
    if (_translation != null) {
      map['translation'] = _translation?.toJson();
    }
    if (_extraValues != null) {
      map['extra_values'] = _extraValues?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Extras {
  Extras({
    dynamic id,
    dynamic extraGroupId,
    String? value,
    bool? active,
    Group? group,
  }) {
    _id = id;
    _extraGroupId = extraGroupId;
    _value = value;
    _active = active;
    _group = group;
  }

  Extras.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _extraGroupId = json['extra_group_id']?.toString();
    _value = json["value"] ?? "";
    _group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }

  dynamic _id;
  dynamic _extraGroupId;
  String? _value;
  bool? _active;
  Group? _group;

  Extras copyWith({
    dynamic id,
    dynamic extraGroupId,
    String? value,
    bool? active,
    Group? group,
  }) => Extras(
    id: id ?? _id,
    extraGroupId: extraGroupId ?? _extraGroupId,
    value: value ?? _value,
    group: group ?? _group,
    active: active ?? _active,
  );

  dynamic get id => _id;
  dynamic get extraGroupId => _extraGroupId;
  String? get value => _value;
  bool? get active => _active;
  Group? get group => _group;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['extra_group_id'] = _extraGroupId;
    map['value'] = _value;
    map['active'] = _active;
    if (_group != null) {
      map['group'] = _group?.toJson();
    }
    return map;
  }
}
