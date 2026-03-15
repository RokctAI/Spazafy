import '../data/extras_data.dart';
import '../data/meta.dart';
import '../data/links.dart';

class ExtrasGroupsResponse {
  ExtrasGroupsResponse({
    dynamic timestamp,
    bool? status,
    String? message,
    List<Group>? data,
    Links? links,
    Meta? meta,
  }) {
    _timestamp = timestamp;
    _status = status;
    _message = message;
    _data = data;
    _links = links;
    _meta = meta;
  }

  ExtrasGroupsResponse.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Group.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  dynamic _timestamp;
  bool? _status;
  String? _message;
  List<Group>? _data;
  Links? _links;
  Meta? _meta;

  ExtrasGroupsResponse copyWith({
    dynamic timestamp,
    bool? status,
    String? message,
    List<Group>? data,
    Links? links,
    Meta? meta,
  }) =>
      ExtrasGroupsResponse(
        timestamp: timestamp ?? _timestamp,
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );

  dynamic get timestamp => _timestamp;
  bool? get status => _status;
  String? get message => _message;
  List<Group>? get data => _data;
  Links? get links => _links;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = _timestamp;
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_links != null) {
      map['links'] = _links?.toJson();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class GroupExtrasResponse {
  GroupExtrasResponse({
    dynamic timestamp,
    bool? status,
    String? message,
    Group? data,
  }) {
    _timestamp = timestamp;
    _status = status;
    _message = message;
    _data = data;
  }

  GroupExtrasResponse.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Group.fromJson(json['data']) : null;
  }

  dynamic _timestamp;
  bool? _status;
  String? _message;
  Group? _data;

  GroupExtrasResponse copyWith({
    dynamic timestamp,
    bool? status,
    String? message,
    Group? data,
  }) =>
      GroupExtrasResponse(
        timestamp: timestamp ?? _timestamp,
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  dynamic get timestamp => _timestamp;
  bool? get status => _status;
  String? get message => _message;
  Group? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = _timestamp;
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
