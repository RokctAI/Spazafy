import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/orders.dart';
import 'package:foodyman/infrastructure/models/customer/data/order_active_model.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:foodyman/infrastructure/services/app_database.dart';
import 'package:uuid/uuid.dart';

class OrdersRepository implements OrdersFacade {
  // --- Common ---
  
  @override
  Future<ApiResult<void>> addReview(
    String orderId, {
    required double rating,
    required String comment,
  }) async {
    // Note: Customer usually uses paas.api, Driver uses v1/dashboard/deliveryman
    // We check the role or just try the customer one as default if not specified
    final data = {
      'order_id': orderId,
      'rating': rating,
      if (comment.isNotEmpty) 'comment': comment,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.order.order.add_order_review',
        data: data,
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
  Future<ApiResult<void>> cancelOrder(String orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.order.order.cancel_order',
        data: {'order_id': orderId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> get cancel order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Customer Specific ---

  @override
  Future<ApiResult<OrderActiveModel>> createOrder(OrderBodyData orderBody) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.order.order.create_order',
        data: orderBody.toJson(),
      );
      return ApiResult.success(data: OrderActiveModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderActiveModel>> getSingleOrder(String orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.order.order.get_order_details',
        queryParameters: {'order_id': orderId},
      );
      return ApiResult.success(data: OrderActiveModel.fromJson(response.data));
    } catch (e, s) {
      debugPrint('==> get single order failure: $e,$s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderPaginateResponse>> getCompletedOrders(int page) {
    return _getOrdersCustomer(page: page, status: 'delivered');
  }

  @override
  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page) {
    return _getOrdersCustomer(page: page, status: 'accepted');
  }

  @override
  Future<ApiResult<OrderPaginateResponse>> getHistoryOrders(int page) {
    return _getOrdersCustomer(page: page);
  }

  Future<ApiResult<OrderPaginateResponse>> _getOrdersCustomer({
    required int page,
    String? status,
  }) async {
    final data = {
      'page': page,
      'limit_page_length': 10,
      if (status != null) 'status': status,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.order.order.list_orders',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Driver Specific ---

  @override
  Future<ApiResult<OrderDetailModel>> showOrders(int id) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/deliveryman/orders/$id',
        queryParameters: data,
      );
      return ApiResult.success(data: OrderDetailModel.fromJson(response.data));
    } catch (e) {
      debugPrint('==> driver get single order failure: $e');
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
      "statuses[2]": "ready",
      "statuses[3]": "on_a_way",
      "perPage": 10,
      "delivery_type": "delivery",
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/deliveryman/orders/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> driver get progress orders failure: $e');
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
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/deliveryman/orders/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data).data ?? [],
      );
    } catch (e) {
      debugPrint('==> driver get available orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> setCurrentOrder(int? orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/deliveryman/orders/$orderId/current',
      );
      return const ApiResult.success(data: null);
    } catch (e) {
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
        '/api/v1/dashboard/deliveryman/orders/paginate?perPage=1&lang=en&current=1',
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> updateOrder(int? orderId, String? status) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/deliveryman/order/$orderId/status/update',
        data: {"status": status},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> uploadImage(int? orderId, String? image) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/deliveryman/orders/$orderId/image',
        data: {"img": image},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
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
        '/api/v1/dashboard/deliveryman/order/$orderId/attach/me',
      );
      return ApiResult.success(data: OrderDetailModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Manager Specific ---

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String? orderId,
    required String? paymentId,
  }) async {
    final data = {'payment_sys_id': paymentId};
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
    String statusText = status.name; 
    final data = {'status': statusText};
    
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
    final data = {
      if (page != null) 'page': page,
      if (status != null) 'status': status.name,
      if (from != null) 'date_from': from,
      if (to != null) 'date_to': to,
      'perPage': 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    
    // 1. Return Local Results Immediately (Manager Path)
    try {
      final localResults = await appDatabase.getOrdersLocally(
        status: status?.name,
      );

      if (localResults.isNotEmpty) {
        final orders = localResults.map((e) => OrderData.fromJson(jsonDecode(e.data))).toList();
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

    // 2. Fallback to API
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

  // --- Offline Order Methods (Manager) ---
  
  Future<ApiResult<CreateOrderResponse>> createOfflineOrder({
    required String deliveryType,
    UserData? user,
    required List<Stock> stocks,
    required String deliveryTime,
    required String address,
  }) async {
    try {
      final orderId = const Uuid().v4();
      final orderJson = <String, dynamic>{
        'id': orderId,
        'user_id': user?.id,
        'delivery_type': deliveryType,
        'delivery_time': deliveryTime,
        'address': address,
        'status': 'new',
        'created_at': DateTime.now().toIso8601String(),
        'stocks': stocks.map((s) => s.toJson()).toList(),
        'price': stocks.fold<num>(0, (sum, s) => sum + ((s.totalPrice ?? 0) * (s.cartCount ?? 1))),
      };
      await appDatabase.putItem('orders', orderId, orderJson);
      return ApiResult.success(
        data: CreateOrderResponse(
          data: CreatedOrder(id: orderId, userId: user?.id, price: orderJson['price'] as num?),
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  // --- Support Methods (Customer) ---

  @override
  Future<ApiResult<GetCalculateModel>> getCalculate({
    required String cartId,
    required double lat,
    required double long,
    required DeliveryTypeEnum type,
    String? coupon,
  }) async {
    final data = {
      'cart_id': cartId,
      'address': {'latitude': lat, 'longitude': long},
      if (coupon != null) 'coupon': coupon,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.order.order.get_calculate',
        data: data,
      );
      return ApiResult.success(data: GetCalculateModel.fromJson(response.data["message"]));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CouponResponse>> checkCoupon({
    required String coupon,
    required String shopId,
  }) async {
    final data = {'coupon': coupon, 'shop': shopId};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.coupon.coupon.check_coupon',
        data: data,
      );
      return ApiResult.success(data: CouponResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> refundOrder(String orderId, String title) async {
    try {
      final data = {"order": orderId, "cause": title};
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.user.user.create_order_refund',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> process(
    OrderBodyData orderBody,
    String name, {
    BuildContext? context,
    bool forceCardPayment = false,
    bool enableTokenization = false,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      var res = await client.post(
        '/api/method/paas.api.payment.payment.initiate_${name.toLowerCase()}_payment',
        data: {'order_id': orderBody.cartId},
      );
      return ApiResult.success(data: res.data["redirect_url"]);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<LocalLocation>> getDriverLocation(String deliveryId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.get_driver_location',
        queryParameters: {'order_id': deliveryId},
      );
      return ApiResult.success(data: LocalLocation.fromJson(response.data['message']));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Auto/Repeating Orders ---

  @override
  Future<ApiResult> createAutoOrder({
    required String from,
    required String orderId,
    String? to,
    String? cronPattern,
    String? paymentMethod,
    String? savedCardId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.repeating_order.create_repeating_order',
        data: {
          'original_order': orderId,
          'start_date': from,
          'cron_pattern': cronPattern ?? '0 0 * * *',
          if (to != null) 'end_date': to,
          if (paymentMethod != null) 'payment_method': paymentMethod,
          if (savedCardId != null) 'saved_card': savedCardId,
        },
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> pauseAutoOrder(String autoOrderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.repeating_order.pause_repeating_order',
        data: {'repeating_order_id': autoOrderId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> resumeAutoOrder(String autoOrderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.repeating_order.resume_repeating_order',
        data: {'repeating_order_id': autoOrderId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> deleteAutoOrder(String orderId) {
    return deleteRepeatingOrder(repeatingOrderId: orderId);
  }

  @override
  Future<ApiResult<void>> createRepeatingOrder({
    required String orderId,
    required String startDate,
    required String cronPattern,
    String? endDate,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.repeating_order.create_repeating_order',
        data: {
          'original_order': orderId,
          'start_date': startDate,
          'cron_pattern': cronPattern,
          if (endDate != null) 'end_date': endDate,
        },
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteRepeatingOrder({
    required String repeatingOrderId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.repeating_order.delete_repeating_order',
        data: {'repeating_order_id': repeatingOrderId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<RefundOrdersModel>> getRefundOrders(int page) async {
    final data = {'page': page};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.user.user.get_user_order_refunds',
        queryParameters: data,
      );
      return ApiResult.success(data: RefundOrdersModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> tipProcess({
    required String orderId,
    required double tip,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.tip_process',
        data: {'order_id': orderId, 'tip': tip},
      );
      return ApiResult.success(data: response.data['redirect_url']);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CashbackModel>> checkCashback({
    required String shopId,
    required double amount,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.check_cashback',
        data: {'shop_id': shopId, 'amount': amount},
      );
      return ApiResult.success(data: CashbackModel.fromJson(response.data['message']));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
