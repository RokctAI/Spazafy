import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';

abstract class OrdersInterface {
  Future<ApiResult<OrderCalculate>> getCalculate({
    required List<Stock> stocks,
    required LocationData? location,
    required String type,
  });

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String? orderId,
    required String? paymentId,
  });

  Future<ApiResult<PaymentsResponse>> getPayments();

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
  });

  Future<ApiResult<OrderStatusResponse>> updateOrderStatus({
    required OrderStatus status,
    String? orderId,
  });

  Future<ApiResult<SingleOrderResponse>> getOrderDetails({String? orderId});

  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    OrderStatus? status,
    int? page,
    String? from,
    String? to,
  });

  Future<ApiResult<OrdersPaginateResponse>> getHistoryOrders({
    int? page,
    String? from,
    String? to,
    String? status,
  });
}
