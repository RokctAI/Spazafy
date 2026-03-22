import 'package:rokctapp/infrastructure/models/data/driver/setting.dart';
import 'package:rokctapp/infrastructure/models/data/manager/settings_data.dart'
    hide SettingsData;

class SettingsResponse {
  SettingsResponse({List<SettingsData>? data}) {
    _data = data;
  }

  SettingsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(SettingsData.fromJson(v));
      });
    }
  }

  List<SettingsData>? _data;

  SettingsResponse copyWith({List<SettingsData>? data}) =>
      SettingsResponse(data: data ?? _data);

  List<SettingsData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
