import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/models/data/manager/group.dart' hide Group;

class ExtrasGroupsResponse {
  ExtrasGroupsResponse({List<Group>? data}) {
    _data = data;
  }

  ExtrasGroupsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Group.fromJson(v));
      });
    }
  }

  List<Group>? _data;

  ExtrasGroupsResponse copyWith({List<Group>? data}) =>
      ExtrasGroupsResponse(data: data ?? _data);

  List<Group>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
