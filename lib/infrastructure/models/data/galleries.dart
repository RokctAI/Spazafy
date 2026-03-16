class Galleries {
  Galleries({
    int? id,
    String? title,
    String? type,
    String? loadableType,
    int? loadableId,
    String? path,
    String? basePath,
  }) {
    _id = id;
    _title = title;
    _type = type;
    _loadableType = loadableType;
    _loadableId = loadableId;
    _path = path;
    _basePath = basePath;
  }

  Galleries.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _type = json['type'];
    _loadableType = json['loadable_type'];
    _loadableId = json['loadable_id'];
    _path = json['path'];
    _basePath = json['base_path'];
  }

  int? _id;
  String? _title;
  String? _type;
  String? _loadableType;
  int? _loadableId;
  String? _path;
  String? _basePath;

  Galleries copyWith({
    int? id,
    String? title,
    String? type,
    String? loadableType,
    int? loadableId,
    String? path,
    String? basePath,
  }) => Galleries(
    id: id ?? _id,
    title: title ?? _title,
    type: type ?? _type,
    loadableType: loadableType ?? _loadableType,
    loadableId: loadableId ?? _loadableId,
    path: path ?? _path,
    basePath: basePath ?? _basePath,
  );

  int? get id => _id;
  String? get title => _title;
  String? get type => _type;
  String? get loadableType => _loadableType;
  int? get loadableId => _loadableId;
  String? get path => _path;
  String? get basePath => _basePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['type'] = _type;
    map['loadable_type'] = _loadableType;
    map['loadable_id'] = _loadableId;
    map['path'] = _path;
    map['base_path'] = _basePath;
    return map;
  }
}
