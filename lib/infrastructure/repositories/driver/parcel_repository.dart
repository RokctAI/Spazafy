import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/parcel_paginate_response.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/parcel.dart';
import 'package:rokctapp/infrastructure/models/data/parcel_order.dart';
import 'package:rokctapp/infrastructure/models/response/driver/parcel_paginate_response.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

final parcelRepositoryFacade = driverParcelRepository;

class ParcelRepository implements ParcelRepositoryFacade {
  @override
  Future<ApiResult<List<ParcelOrder>>> getActiveOrders(int page) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()!.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'page': page,
      "statuses[1]": "accepted",
      "statuses[2]": "ready",
      "statuses[3]": "on_a_way",
      "perPage": 10,
      "delivery_type": "delivery",
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.get_driver_parcel_orders_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelPaginateResponse.fromJson(response.data).data ?? [],
      );
    } catch (e) {
      debugPrint('==> get active orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<ParcelOrder>>> getAvailableOrders(int page) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()!.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'page': page,
      "status": "ready",
      "empty-deliveryman": 1,
      "perPage": 10,
      "delivery_type": "delivery",
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.get_driver_parcel_orders_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelPaginateResponse.fromJson(response.data).data ?? [],
      );
    } catch (e) {
      debugPrint('==> get canceled orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelOrder>> showParcel(String id) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.get_driver_parcel_order_details',
        queryParameters: {...data, 'parcel_id': id},
      );
      return ApiResult.success(data: ParcelOrder.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get single order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<ParcelOrder>>> getHistoryOrders(
    int page, {
    DateTime? start,
    DateTime? end,
  }) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()!.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'page': page,
      "status": "delivered",
      "perPage": 10,
      if (start != null)
        "delivery_date_from": DateFormat("yyyy-MM-dd").format(start),
      if (end != null) "delivery_date_to": DateFormat("yyyy-MM-dd").format(end),
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.get_driver_parcel_orders_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelPaginateResponse.fromJson(response.data).data ?? [],
      );
    } catch (e) {
      debugPrint('==> get delivered orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> setCurrentOrder(String? orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.set_current_parcel_order',
        data: {'parcel_id': orderId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> get delivered orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> updateParcel(
    dynamic parcelId,
    String status,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.update_driver_parcel_order_status',
        data: {"parcel_id": parcelId, "status": status},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('===> error statistics settings $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> addReviewParcel(
    dynamic orderId, {
    required double rating,
    required String comment,
  }) async {
    final data = {'rating': rating, if (comment.isNotEmpty) 'comment': comment};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.add_parcel_order_review',
        data: {...data, "parcel_id": orderId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add order review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelOrder>> setParcel(String parcelId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.driver_parcel.driver_parcel.attach_parcel_order_to_me',
        data: {'parcel_id': parcelId},
      );
      return ApiResult.success(data: ParcelOrder.fromJson(response.data));
    } catch (e) {
      debugPrint('===> error statistics settings $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
