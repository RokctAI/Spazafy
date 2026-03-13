import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';
import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/domain/interface/interfaces.dart';

class OrdersRepository implements OrdersInterface {
  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String? orderId,
    required String? paymentId,
  }) async {
    final data = {'payment_sys_id': paymentId};
    debugPrint('===> create transaction body: ${jsonEncode(data)}');
    debugPrint('===> create transaction order id: $orderId');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/payments/order/$orderId/transactions',
        data: data,
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
        '/api/v1/dashboard/seller/shop-payments',
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
    // 1. Snapshot and Sync Logic
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/seller/orders',
        data: data,
      );
      
      final result = CreateOrderResponse.fromJson(response.data);
      if (result.data != null) {
        // High-Quality Upsert (includes snapshots of items)
        await appDatabase.upsertOrder(result.data!.toJson());
      }
      return ApiResult.success(data: result);
    } catch (e) {
      debugPrint('==> create order failure: $e');
      // TODO: Implement SyncQueue saving if API fails (Phase 3)
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderStatusResponse>> updateOrderStatus({
    required OrderStatus status,
    String? orderId,
  }) async {
    String? statusText;
    switch (status) {
      case OrderStatus.newOrder:
        statusText = 'new';
        break;
      case OrderStatus.accepted:
        statusText = 'accepted';
        break;
      case OrderStatus.cooking:
        statusText = 'cooking';
        break;
      case OrderStatus.ready:
        statusText = 'ready';
        break;
      case OrderStatus.onAWay:
        statusText = 'on_a_way';
        break;
      case OrderStatus.delivered:
        statusText = 'delivered';
        break;
      case OrderStatus.canceled:
        statusText = 'canceled';
        break;
    }
    final data = {'status': statusText};
    debugPrint('===> update order status request ${jsonEncode(data)}');
    // 1. Update Local Status
    try {
      final local = await appDatabase.getItem('orders', orderId ?? '');
      if (local != null) {
        local['status'] = statusText;
        await appDatabase.upsertOrder(local);
      }
    } catch (e) {
      debugPrint('==> Local status update failed: $e');
    }

    // 2. Sync to API
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/seller/order/$orderId/status',
        data: data,
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
      final local = await appDatabase.getItem('orders', orderId ?? '');
      if (local != null) {
        debugPrint('===> Returning local order details for $orderId');
        return ApiResult.success(
          data: SingleOrderResponse.fromJson({'data': local}),
        );
      }
    } catch (e) {
      debugPrint('==> Local order details fetch failed: $e');
    }

    try {
      final client = dioHttp.client(requireAuth: true);
      final data = {'lang': LocalStorage.getLanguage()?.locale};
      final response = await client.get(
        '/api/v1/dashboard/seller/orders/$orderId',
        queryParameters: data,
      );
      final result = SingleOrderResponse.fromJson(response.data);
      if (result.data != null) {
        appDatabase.upsertOrder(result.data!.toJson());
      }
      return ApiResult.success(data: result);
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
    OrderStatus? status,
    int? page,
    String? from,
    String? to,
  }) async {
    String? statusText;
    switch (status) {
      case OrderStatus.accepted:
        statusText = 'accepted';
        break;
      case OrderStatus.ready:
        statusText = 'ready';
        break;
      case OrderStatus.onAWay:
        statusText = 'on_a_way';
        break;
      case OrderStatus.delivered:
        statusText = 'delivered';
        break;
      case OrderStatus.canceled:
        statusText = 'canceled';
        break;
      case OrderStatus.newOrder:
        statusText = 'new';
      case OrderStatus.cooking:
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
    // 1. Return Local Results Immediately
    try {
      final localResults = await appDatabase.getOrdersLocally(
        status: statusText,
      );

      if (localResults.isNotEmpty) {
        final orders = localResults.map((e) => OrderData.fromJson(jsonDecode(e.data))).toList();
        debugPrint('===> Returning ${localResults.length} local orders');
        _backgroundSyncOrders(data); // Refresh in background
        return ApiResult.success(
          data: OrdersPaginateResponse(
            data: orders,
            meta: Meta(total: orders.length, lastPage: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('==> Local orders fetch failed: $e');
    }

    // 2. Fallback to API / Background Sync
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/seller/orders/paginate',
        queryParameters: data,
      );
      
      final result = OrdersPaginateResponse.fromJson(response.data);
      for (final order in result.data ?? []) {
        appDatabase.upsertOrder(order.toJson());
      }
      return ApiResult.success(data: result);
    } catch (e) {
      debugPrint('==> get order $status failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  void _backgroundSyncOrders(Map<String, dynamic> data) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/seller/orders/paginate',
        queryParameters: data,
      );
      final result = OrdersPaginateResponse.fromJson(response.data);
      for (final order in result.data ?? []) {
        await appDatabase.upsertOrder(order.toJson());
      }
    } catch (e) {
      debugPrint('==> Background order sync failed: $e');
    }
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
        '/api/v1/dashboard/seller/orders/paginate',
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
        '/api/v1/dashboard/seller/order/products/calculate',
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
