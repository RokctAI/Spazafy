import 'package:rokctapp/dummy_types.dart';
import 'local_location.dart';

class LocalAddressData {
  LocalAddressData({
    String? id,
    String? title,
    String? address,
    LocalLocation? location,
    bool? isDefault,
    bool? isSelected,
  }) {
    _id = id;
    _title = title;
    _address = address;
    _location = location;
    _default = isDefault;
    _isSelected = isSelected;
  }

  LocalAddressData.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _title = json['title'];
    _address = json['address'];
    _location = json['location'] != null
        ? LocalLocation.fromJson(json['location'])
        : null;
    _default = json['default'];
    _isSelected = json['selected'];
  }

  String? _id;
  String? _title;
  String? _address;
  LocalLocation? _location;
  bool? _default;
  bool? _isSelected;

  LocalAddressData copyWith({
    String? id,
    String? title,
    String? address,
    LocalLocation? location,
    bool? isDefault,
    bool? isSelected,
  }) =>
      LocalAddressData(
        id: id ?? _id,
        title: title ?? _title,
        address: address ?? _address,
        location: location ?? _location,
        isDefault: isDefault ?? _default,
        isSelected: isSelected ?? _isSelected,
      );

  String? get id => _id;

  String? get title => _title;

  String? get address => _address;

  LocalLocation? get location => _location;

  bool? get isDefault => _default;

  bool? get isSelected => _isSelected;

  Map<String, dynamic> toJson() => {
        'address': _address,
        'location': '${_location?.latitude},${_location?.longitude}',
        'active': 1,
        if (_title?.isNotEmpty ?? false) 'title': _title,
        'default': (_isSelected ?? false) ? 1 : 0,
      };

  @override
  String toString() {
    return 'LocalAddressData(title - $title})';
  }
}
