import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/parcel_paginate_response.dart';

import 'package:rokctapp/infrastructure/models/models.dart';

abstract class ParcelFacade {
  Future<ApiResult<ParcelTypeResponse>> getTypes();

  Future<ApiResult<ParcelCalculateResponse>> getCalculate({
    required String typeId,
    required LocationModel from,
    required LocationModel to,
  });

  Future<ApiResult> orderParcel({
    required String typeId,
    required LocationModel from,
    required String fromTitle,
    required LocationModel to,
    required String toTitle,
    required String time,
    required String note,
    required String phoneFrom,
    required String phoneTo,
    required String usernameTo,
    required String usernameFrom,
    required String floorTo,
    required String floorFrom,
    required String houseFrom,
    required String houseTo,
    required String comment,
    required String value,
    required String instruction,
    required bool notify,
  });

  Future<ApiResult<ParcelPaginateResponse>> getActiveParcel(int page);

  Future<ApiResult<ParcelPaginateResponse>> getHistoryParcel(int page);

  Future<ApiResult<ParcelOrder>> getSingleParcel(String orderId);

  Future<ApiResult<void>> addReview(
    String orderId, {
    required double rating,
    required String comment,
  });

  Future<ApiResult<String>> process(String orderId, String name);

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
  });

  // Driver Methods
  Future<ApiResult<ParcelOrder>> showParcel(int id);
  Future<ApiResult<dynamic>> setCurrentOrder(int? orderId);
  Future<ApiResult<List<ParcelOrder>>> getAvailableOrders(int page);
  Future<ApiResult<dynamic>> updateParcel(int? parcelId, String? status);
  Future<ApiResult<void>> addReviewParcel(
    num orderId, {
    required double rating,
    required String comment,
  });
  Future<ApiResult<ParcelOrder>> setParcel(String orderId);
}
