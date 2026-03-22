import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

class ProductRequest {
  final String shopId;
  final int page;

  ProductRequest({required this.shopId, required this.page});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["shop_id"] = shopId;
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    map["page"] = page;
    map["perPage"] = 10;
    return map;
  }
}
