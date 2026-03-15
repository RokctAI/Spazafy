import '../data/meta.dart';
import '../data/category_data.dart';

class CategoriesPaginateResponse {
  CategoriesPaginateResponse({List<CategoryData>? data, Meta? meta}) {
    _data = data;
    _meta = meta;
  }

  CategoriesPaginateResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(CategoryData.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  List<CategoryData>? _data;
  Meta? _meta;

  CategoriesPaginateResponse copyWith({List<CategoryData>? data, Meta? meta}) =>
      CategoriesPaginateResponse(data: data ?? _data, meta: meta ?? _meta);

  List<CategoryData>? get data => _data;

  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}
