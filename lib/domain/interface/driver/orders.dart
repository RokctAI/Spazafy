import 'package:rokctapp/infrastructure/models/data/driver/order_detail.dart';
import 'package:rokctapp/infrastructure/models/data/driver/order_paginate_response.dart';

import 'package:rokctapp/domain/handlers/driver/handlers.dart';

abstract class OrdersRepositoryFacade {
  Future<ApiResult<OrderDetailModel>> showOrders(String id);

  Future<ApiResult<dynamic>> setCurrentOrder(String? orderId);

  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getProgressOrders(int page);

  Future<ApiResult<List<OrderDetailData>>> getAvailableOrders(int page);

  Future<ApiResult<List<OrderDetailData>>> getHistoryOrders(
    int page, {
    DateTime? start,
    DateTime? end,
    List<String>? status,
  });

  Future<ApiResult<dynamic>> updateOrder(String? orderId, String? status);

  Future<ApiResult<dynamic>> uploadImage(String? orderId, String? image);

  Future<ApiResult<void>> addReview(
    String orderId, {
    required double rating,
    required String comment,
  });

  Future<ApiResult<void>> cancelOrder(String orderId, String note);

  Future<ApiResult<OrderPaginateResponse>> fetchCurrentOrder();

  Future<ApiResult<OrderDetailModel>> setOrder(String orderId);
}
