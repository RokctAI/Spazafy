import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/domain/interface/interfaces.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';

class ShopsRepository implements ShopsInterface {
  @override
  Future<ApiResult<void>> createShop({
    required double tax,
    required List<String> documents,
    required double deliveryTo,
    required double deliveryFrom,
    required String deliveryType,
    required String phone,
    required String name,
    required num category,
    required String description,
    required double startPrice,
    required double perKm,
    required AddressData address,
    String? logoImage,
    String? backgroundImage,
  }) async {
    final data = {
      "price_per_km": perKm,
      'tax': tax,
      'documents': documents,
      //'categories[0]': category,
      'delivery_time_type': deliveryType,
      'location': address.location?.toJson(),
      'phone': phone.replaceAll('+', ""),
      'delivery_time_from': deliveryFrom,
      'delivery_time_to': deliveryTo,
      'title': {LocalStorage.getLanguage()?.locale ?? "": name},
      'description': {LocalStorage.getLanguage()?.locale ?? "": description},
      'price': startPrice,
      'address': {
        LocalStorage.getLanguage()?.locale ?? "":
            "${address.title}, ${address.address}",
      },
      if (logoImage != null) 'images': [logoImage, backgroundImage],
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.shop.shop.create_shop',
        data: {'shop_data': data},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> create shop failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}

