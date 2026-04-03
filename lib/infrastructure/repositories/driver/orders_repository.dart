import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/orders.dart';
import 'package:rokctapp/infrastructure/models/data/driver/order_detail.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/data/driver/order_paginate_response.dart';

final ordersRepositoryFacade = driverOrderRepository;

class OrdersRepository implements OrdersRepositoryFacade {
  @override
  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page) async {
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
        '/api/v1/method/paas.api.driver_order.driver_order.get_driver_orders_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
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
  Future<ApiResult<OrderPaginateResponse>> getProgressOrders(int page) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()!.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'page': page,
      // "statuses[1]": "accepted",
      "statuses[2]": "ready",
      "statuses[3]": "on_a_way",
      "perPage": 10,
      "delivery_type": "delivery",
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_order.driver_order.get_driver_orders_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
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
  Future<ApiResult<List<OrderDetailData>>> getAvailableOrders(int page) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()!.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'page': page,
      "status": "ready",
      "empty-deliveryman": 1,
      "perPage": 10,
      "delivery_type": "delivery",
      "address": {
        "latitude":
            LocalStorage.getAddressSelected()?.latitude ??
            AppConstants.demoLatitude,
        "longitude":
            LocalStorage.getAddressSelected()?.longitude ??
            AppConstants.demoLongitude,
      },
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_order.driver_order.get_driver_orders_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data).data ?? [],
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
  Future<ApiResult<OrderDetailModel>> showOrders(dynamic id) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_order.driver_order.get_driver_order_details',
        queryParameters: {...data, 'order_id': id},
      );
      return ApiResult.success(data: OrderDetailModel.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get single order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<OrderDetailData>>> getHistoryOrders(
    int page, {
    DateTime? start,
    DateTime? end,
    List<String>? status,
  }) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()!.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'page': page,
      "status": status ?? ["ready", "on_a_way", "delivered", "canceled"],
      "perPage": 10,
      if (start != null)
        "delivery_date_from": DateFormat("yyyy-MM-dd").format(start),
      if (end != null) "delivery_date_to": DateFormat("yyyy-MM-dd").format(end),
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_order.driver_order.get_driver_orders_paginate',
        queryParameters: data,
      );

      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data).data ?? [],
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
        '/api/v1/method/paas.api.driver_order.driver_order.set_current_order',
        data: {'order_id': orderId},
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
  Future<ApiResult<OrderPaginateResponse>> fetchCurrentOrder() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.driver_order.driver_order.fetch_current_order',
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('===> error current order settings $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> updateOrder(
    dynamic orderId,
    String status,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.driver_order.driver_order.update_driver_order_status',
        data: {"order_id": orderId, "status": status},
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
  Future<ApiResult<dynamic>> uploadImage(dynamic orderId, String? image) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.driver_order.driver_order.upload_order_image',
        data: {"order_id": orderId, "img": image},
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
  Future<ApiResult<void>> addReview(
    dynamic orderId, {
    required double rating,
    required String comment,
  }) async {
    final data = {'rating': rating, if (comment.isNotEmpty) 'comment': comment};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.order.order.add_order_review',
        data: {...data, "order_id": orderId},
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
  Future<ApiResult<OrderDetailModel>> setOrder(String orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.driver_order.driver_order.attach_order_to_me',
        data: {'order_id': orderId},
      );
      return ApiResult.success(data: OrderDetailModel.fromJson(response.data));
    } catch (e) {
      debugPrint('===> error statistics settings $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> cancelOrder(dynamic orderId, [String? note]) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.driver_order.driver_order.update_driver_order_status',
        data: {"order_id": orderId, "status": "canceled", "note": note},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> post cancel order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
