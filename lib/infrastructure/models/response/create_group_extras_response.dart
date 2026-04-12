import 'package:rokctapp/infrastructure/models/data/group.dart';
import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/models/data/extras.dart' hide Extras;

class CreateGroupExtrasResponse {
  CreateGroupExtrasResponse({Extras? data}) {
    _data = data;
  }

  CreateGroupExtrasResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? Extras.fromJson(json['data']) : null;
  }

  Extras? _data;

  CreateGroupExtrasResponse copyWith({Extras? data}) =>
      CreateGroupExtrasResponse(data: data ?? _data);

  Extras? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
