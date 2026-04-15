import 'package:rokctapp/domain/handlers/driver/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/driver/order_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/data/order_detail.dart';
import 'package:rokctapp/infrastructure/models/data/get_calculate_data.dart';
import 'package:rokctapp/infrastructure/models/data/order_body_data.dart';
import 'package:rokctapp/infrastructure/models/data/cashback_model.dart';
import 'package:rokctapp/infrastructure/models/response/coupon_response.dart';
import 'package:rokctapp/infrastructure/models/data/refund_data.dart';
import 'package:rokctapp/infrastructure/models/data/local_location.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/infrastructure/models/data/order_active_model.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
    hide OrderPaginateResponse;
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class OrdersRepositoryFacade {
  Future<ApiResult<GetCalculateModel>> getCalculate({
    required String cartId,
    required double lat,
    required double long,
    required DeliveryTypeEnum type,
    String? coupon,
  });

  Future<ApiResult<OrderActiveModel>> createOrder(OrderBodyData orderBody);

  Future<ApiResult> createAutoOrder({
    required String from,
    required String orderId,
    String? to,
    String? cronPattern,
    String? paymentMethod,
    String? savedCardId,
  });

  Future<ApiResult> pauseAutoOrder(String autoOrderId);

  Future<ApiResult> resumeAutoOrder(String autoOrderId);

  Future<ApiResult> deleteAutoOrder(String orderId);

  Future<ApiResult<void>> createRepeatingOrder({
    required String orderId,
    required String startDate,
    required String cronPattern,
    String? endDate,
  });

  Future<ApiResult<void>> deleteRepeatingOrder({
    required String repeatingOrderId,
  });

  Future<ApiResult<dynamic>> getCompletedOrders(int page);

  Future<ApiResult<dynamic>> getActiveOrders(int page);

  Future<ApiResult<dynamic>> getAvailableOrders(int page);

  Future<ApiResult<dynamic>> getHistoryOrders(
    int page, {
    DateTime? start,
    DateTime? end,
    List<String>? status,
  });

  Future<ApiResult<RefundOrdersModel>> getRefundOrders(int page);

  Future<ApiResult<OrderActiveModel>> getSingleOrder(String orderId);

  Future<ApiResult<OrderDetailModel>> showOrders(dynamic id);

  Future<ApiResult<LocalLocation>> getDriverLocation(String deliveryId);

  Future<ApiResult<void>> cancelOrder(dynamic orderId, [String? note]);

  Future<ApiResult<void>> refundOrder(String orderId, String title);

  Future<ApiResult<void>> addReview(
    dynamic orderId, {
    required double rating,
    required String comment,
  });

  Future<ApiResult<String>> process(
    OrderBodyData orderBody,
    String name, {
    BuildContext? context,
    bool forceCardPayment = false,
    bool enableTokenization = false,
  });

  Future<ApiResult<String>> tipProcess({
    required String orderId,
    required double tip,
  });

  Future<ApiResult<CouponResponse>> checkCoupon({
    required String coupon,
    required String shopId,
  });

  Future<ApiResult<CashbackModel>> checkCashback({
    required String shopId,
    required double amount,
  });

  Future<ApiResult<OrderPaginateResponse>> fetchCurrentOrder();

  Future<ApiResult<dynamic>> updateOrder(dynamic orderId, String status);

  Future<ApiResult<dynamic>> uploadImage(dynamic orderId, String? image);

  Future<ApiResult<dynamic>> setCurrentOrder(String? orderId);

  Future<ApiResult<dynamic>> setOrder(String orderId);
}
