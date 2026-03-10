import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/domain/interface/orders.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/hive_database.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';

/// Offline-first implementation of [OrdersInterface].
/// All orders stored in Hive. No API calls.
class OfflineOrdersRepository implements OrdersInterface {
  @override
  Future<ApiResult<CreateOrderResponse>> createOrder({
    required String deliveryType,
    UserData? user,
    required List<Stock> stocks,
    required String deliveryTime,
    required String address,
    String? entrance,
    String? tableId,
    String? floor,
    String? house,
    LocationData? location,
  }) async {
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch;
      final orderJson = <String, dynamic>{
        'id': orderId.toString(),
        'user_id': user?.id,
        'delivery_type': deliveryType,
        'delivery_time': deliveryTime,
        'address': address,
        'entrance': entrance,
        'table_id': tableId,
        'floor': floor,
        'house': house,
        'status': 'new',
        'created_at': DateTime.now().toIso8601String(),
        'stocks': stocks.map((s) => s.toJson()).toList(),
        'price': stocks.fold<num>(
          0,
          (sum, s) => sum + ((s.totalPrice ?? 0) * (s.cartCount ?? 1)),
        ),
      };

      await HiveDatabase.putItem(
        HiveDatabase.orderBox,
        orderId.toString(),
        orderJson,
      );

      return ApiResult.success(
        data: CreateOrderResponse(
          data: CreatedOrder(
            id: orderId.toString(),
            userId: user?.id,
            price: orderJson['price'] as num?,
          ),
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    OrderStatus? status,
    int? page,
    String? from,
    String? to,
  }) async {
    try {
      final allJson = HiveDatabase.getAll(HiveDatabase.orderBox);
      List<OrderData> orders =
          allJson.map((json) => OrderData.fromJson(json)).toList();

      // Sort by creation date, newest first
      orders.sort((a, b) {
        final aDate = a.createdAt ?? '';
        final bDate = b.createdAt ?? '';
        return bDate.compareTo(aDate);
      });

      return ApiResult.success(
        data: OrdersPaginateResponse(
          data: OrderResponseData(
            orders: orders,
            statistic: OrdersStatistic(
              ordersCount: orders.length,
              newOrdersCount:
                  orders.where((o) => o.status == 'new').length,
            ),
          ),
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<OrdersPaginateResponse>> getHistoryOrders({
    int? page,
    String? from,
    String? to,
    String? status,
  }) async {
    // Same as getOrders for offline — all orders are local
    return getOrders(page: page, from: from, to: to);
  }

  @override
  Future<ApiResult<SingleOrderResponse>> getOrderDetails({
    String? orderId,
  }) async {
    try {
      if (orderId == null) {
        return const ApiResult.failure(error: 'Order ID required');
      }
      final json = HiveDatabase.getItem(
        HiveDatabase.orderBox,
        orderId.toString(),
      );
      if (json == null) {
        return const ApiResult.failure(error: 'Order not found');
      }
      return ApiResult.success(
        data: SingleOrderResponse(data: OrderData.fromJson(json)),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<OrderStatusResponse>> updateOrderStatus({
    required OrderStatus status,
    String? orderId,
  }) async {
    try {
      if (orderId == null) {
        return const ApiResult.failure(error: 'Order ID required');
      }
      final existing = HiveDatabase.getItem(
        HiveDatabase.orderBox,
        orderId ?? '',
      );
      if (existing == null) {
        return const ApiResult.failure(error: 'Order not found');
      }

      existing['status'] = status.name;
      await HiveDatabase.putItem(
        HiveDatabase.orderBox,
        orderId ?? '',
        existing,
      );

      return ApiResult.success(
        data: OrderStatusResponse.fromJson({'data': existing}),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<OrderCalculate>> getCalculate({
    required List<Stock> stocks,
    required LocationData? location,
    required String type,
  }) async {
    // Offline calculation — sum of stock prices
    try {
      final totalPrice = stocks.fold<num>(
        0,
        (sum, s) => sum + ((s.totalPrice ?? 0) * (s.cartCount ?? 1)),
      );
      return ApiResult.success(
        data: OrderCalculate.fromJson({
          'data': {
            'total_price': totalPrice,
            'price': totalPrice,
            'total_tax': 0,
            'total_discount': 0,
            'delivery_fee': 0,
          },
        }),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String? orderId,
    required String? paymentId,
  }) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<PaymentsResponse>> getPayments() async {
    return const ApiResult.failure(error: 'Not available offline');
  }
}
