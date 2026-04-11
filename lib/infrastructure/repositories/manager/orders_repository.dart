import 'package:rokctapp/infrastructure/models/response/orders_paginate_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/models/response/single_order_response.dart';
import 'package:rokctapp/infrastructure/models/data/manager/product_data.dart';
import 'package:rokctapp/infrastructure/models/data/stock.dart';
import 'package:rokctapp/infrastructure/models/data/order_calculate_data.dart';
import 'package:rokctapp/infrastructure/models/response/create_order_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/payments_response.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/data/user_data.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart' as mgr;
import 'package:rokctapp/infrastructure/models/response/order_status_response.dart';
import 'package:rokctapp/infrastructure/models/response/transactions_response.dart';
import 'package:rokctapp/domain/interface/manager_orders.dart';
import 'package:rokctapp/infrastructure/models/data/location_data.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/models.dart'
    hide UserData, Stock, AddonData, OrderPaginateResponse, PaymentsResponse;
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

import 'package:rokctapp/infrastructure/models/response/login_response.dart'
    hide UserData;

class OrdersRepository implements OrdersInterface {
  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
  }) async {
    final data = {'payment_sys_id': paymentId};
    debugPrint('===> create transaction body: ${jsonEncode(data)}');
    debugPrint('===> create transaction order id: $orderId');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.payment.payment.create_transaction',
        data: data,
        queryParameters: {'order_id': orderId},
      );
      return ApiResult.success(
        data: TransactionsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create transaction failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<PaymentsResponse>> getPayments() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.payment.payment.get_payment_gateways',
      );
      return ApiResult.success(data: PaymentsResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get payments error: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CreateOrderResponse>> createOrder({
    required String deliveryType,
    required List<Stock> stocks,
    required String deliveryTime,
    required String address,
    UserData? user,
    LocationData? location,
    String? entrance,
    String? tableId,
    String? floor,
    String? house,
  }) async {
    List<Map<String, dynamic>> products = [];
    for (final stock in stocks) {
      List<Map<String, dynamic>> addons = [];
      for (AddonData addon
          in stock.addons?.where((e) => e.active ?? false) ?? []) {
        addons.add({
          'stock_id': addon.product?.stock?.id,
          'quantity': addon.quantity ?? 1,
        });
      }
      products.add({
        'stock_id': stock.id,
        'quantity': stock.quantity ?? 1,
        if (addons.isNotEmpty) 'addons': addons,
        if (stock.bonus ?? false) 'bonus': true,
        if (stock.shopBonus ?? false) 'bonus_shop': true,
      });
    }
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'rate': LocalStorage.getSelectedCurrency()?.rate,
      'shop_id': LocalStorage.getShop()?.id,
      if (user?.phone != null) 'phone': user?.phone?.replaceAll('+', ""),
      'delivery_type': deliveryType,
      if (user?.id != null) 'user_id': user?.id,
      'products': products,
      if (deliveryType == TrKeys.dineIn) 'table_id': tableId,
      'delivery_date': deliveryTime,
      if (address.isNotEmpty && deliveryType == TrKeys.delivery)
        'address': {
          'address': address,
          if (entrance != null) 'office': entrance,
          if (house != null) 'house': house,
          if (floor != null) 'floor': floor,
        },
      if (location != null && deliveryType == TrKeys.delivery)
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
    };
    debugPrint('===> create order body ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.order.order.create_order',
        data: data,
      );
      return ApiResult.success(
        data: CreateOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderStatusResponse>> updateOrderStatus({
    required mgr.OrderStatus status,
    String? orderId,
  }) async {
    String? statusText;
    switch (status) {
      case mgr.OrderStatus.newOrder:
        statusText = 'new';
        break;
      case mgr.OrderStatus.open:
        statusText = 'new';
        break;
      case mgr.OrderStatus.accepted:
        statusText = 'accepted';
        break;
      case mgr.OrderStatus.cooking:
        statusText = 'cooking';
        break;
      case mgr.OrderStatus.ready:
        statusText = 'ready';
        break;
      case mgr.OrderStatus.onAWay:
        statusText = 'on_a_way';
        break;
      case mgr.OrderStatus.delivered:
        statusText = 'delivered';
        break;
      case mgr.OrderStatus.canceled:
        statusText = 'canceled';
        break;
    }
    final data = {'status': statusText};
    debugPrint('===> update order status request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_order.seller_order.update_seller_order_status',
        data: {'order_id': orderId, 'status': statusText},
      );
      return ApiResult.success(
        data: OrderStatusResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update order status failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleOrderResponse>> getOrderDetails({
    String? orderId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final data = {
        'lang': LocalStorage.getLanguage()?.locale,
        'order_id': orderId,
      };
      final response = await client.get(
        '/api/v1/method/paas.api.seller_order.seller_order.get_seller_order_details',
        queryParameters: data,
      );
      return ApiResult.success(
        data: SingleOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get order details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    mgr.OrderStatus? status,
    int? page,
    String? from,
    String? to,
  }) async {
    String? statusText;
    switch (status) {
      case mgr.OrderStatus.accepted:
        statusText = 'accepted';
        break;
      case mgr.OrderStatus.ready:
        statusText = 'ready';
        break;
      case mgr.OrderStatus.onAWay:
        statusText = 'on_a_way';
        break;
      case mgr.OrderStatus.delivered:
        statusText = 'delivered';
        break;
      case mgr.OrderStatus.canceled:
        statusText = 'canceled';
        break;
      case mgr.OrderStatus.newOrder:
        statusText = 'new';
        break;
      case mgr.OrderStatus.cooking:
        statusText = 'cooking';
        break;
      default:
        statusText = null;
        break;
    }
    final data = {
      if (page != null) 'page': page,
      if (statusText != null) 'status': statusText,
      if (from != null) 'date_from': from,
      if (to != null) 'date_to': to,
      'perPage': 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_order.seller_order.get_seller_orders',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrdersPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get order $status failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrdersPaginateResponse>> getHistoryOrders({
    int? page,
    String? from,
    String? to,
    String? status,
  }) async {
    final data = {
      if (page != null) 'page': page,
      'statuses[0]': status,
      // 'statuses[1]': 'canceled',
      if (from != null) 'date_from': from,
      if (to != null) 'date_to': to,
      'perPage': 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_order.seller_order.get_seller_orders',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrdersPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderCalculate>> getCalculate({
    required List<Stock> stocks,
    required String type,
    required LocationData? location,
  }) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'shop_id': LocalStorage.getShop()?.id,
      for (int i = 0; i < stocks.length; i++)
        'products[$i][stock_id]': '${stocks[i].id}',
      for (int i = 0; i < stocks.length; i++)
        'products[$i][quantity]': '${stocks[i].cartCount}',
      'type': type,
      if (location != null) 'address[latitude]': location.latitude,
      if (location != null) 'address[longitude]': location.longitude,
    };
    for (int i = 0; i < (stocks.length); i++) {
      data['products[$i][stock_id]'] = stocks[i].id;
      data['products[$i][quantity]'] = stocks[i].cartCount ?? 1;
      final addons =
          stocks[i].addons?.where((e) => e.active ?? false).toList() ?? [];
      for (int j = 0; j < (addons.length); j++) {
        data['products[$i][addons][$j][stock_id]'] =
            addons[j].product?.stock?.id;
        data['products[$i][addons][$j][quantity]'] = addons[j].quantity ?? 1;
      }
    }
    debugPrint('==> order calculate request: ${jsonEncode(data)}');

    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.order.order.get_calculate',
        queryParameters: data,
      );
      return ApiResult.success(data: OrderCalculate.fromJson(response.data));
    } catch (e, s) {
      debugPrint('==> get order failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}

