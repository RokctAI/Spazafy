import 'package:rokctapp/infrastructure/models/data/driver/user_data.dart';
import 'package:rokctapp/infrastructure/models/data/user_data.dart'
    hide UserData;

class ProfileResponse {
  ProfileResponse({UserData? data}) {
    _data = data;
  }

  ProfileResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  UserData? _data;

  ProfileResponse copyWith({UserData? data}) =>
      ProfileResponse(data: data ?? _data);

  UserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
