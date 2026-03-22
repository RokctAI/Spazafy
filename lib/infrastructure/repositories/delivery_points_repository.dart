import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/domain/interface/delivery_points.dart';
import 'package:rokctapp/infrastructure/models/data/delivery_point_data.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:flutter/material.dart';

class DeliveryPointsRepository implements DeliveryPointsRepositoryFacade {
  /// Fetches delivery points near a specific location.
  @override
  Future<ApiResult<List<DeliveryPointData>>> getDeliveryPoints({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.shop.shop.get_nearest_delivery_points',
        queryParameters: {'latitude': latitude, 'longitude': longitude},
      );
      final List<dynamic> data = response.data['message'];
      final List<DeliveryPointData> deliveryPoints = data
          .map((e) => DeliveryPointData.fromJson(e))
          .toList();
      return ApiResult.success(data: deliveryPoints);
    } catch (e) {
      debugPrint('==> get delivery points failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// Fetches all active delivery points, regardless of location.
  @override
  Future<ApiResult<List<DeliveryPointData>>> getAllDeliveryPoints() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.delivery.delivery.get_delivery_points',
      );
      final List<dynamic> data = response.data['message'];
      final List<DeliveryPointData> deliveryPoints = data
          .map((e) => DeliveryPointData.fromJson(e))
          .toList();
      return ApiResult.success(data: deliveryPoints);
    } catch (e) {
      debugPrint('==> get all delivery points failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}


