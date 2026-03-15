import '../data/extras_data.dart';

class SingleExtrasGroupResponse {
  SingleExtrasGroupResponse({
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

  SingleExtrasGroupResponse.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Group.fromJson(json['data']) : null;
  }

  dynamic _timestamp;
  bool? _status;
  String? _message;
  Group? _data;

  SingleExtrasGroupResponse copyWith({
    dynamic timestamp,
    bool? status,
    String? message,
    Group? data,
  }) =>
      SingleExtrasGroupResponse(
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

class CreateGroupExtrasResponse {
  CreateGroupExtrasResponse({
    dynamic timestamp,
    bool? status,
    String? message,
    Extras? data,
  }) {
    _timestamp = timestamp;
    _status = status;
    _message = message;
    _data = data;
  }

  CreateGroupExtrasResponse.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Extras.fromJson(json['data']) : null;
  }

  dynamic _timestamp;
  bool? _status;
  String? _message;
  Extras? _data;

  CreateGroupExtrasResponse copyWith({
    dynamic timestamp,
    bool? status,
    String? message,
    Extras? data,
  }) =>
      CreateGroupExtrasResponse(
        timestamp: timestamp ?? _timestamp,
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  dynamic get timestamp => _timestamp;
  bool? get status => _status;
  String? get message => _message;
  Extras? get data => _data;

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
