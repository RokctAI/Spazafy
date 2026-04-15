import 'package:rokctapp/infrastructure/models/response/orders_paginate_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/order_detail.dart'
    hide Stock;
import 'package:rokctapp/infrastructure/models/data/order_calculate_data.dart';
import 'package:rokctapp/infrastructure/models/data/stock.dart';
import 'package:rokctapp/infrastructure/models/response/manager/payments_response.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart' as mgr;
import 'package:rokctapp/infrastructure/models/data/user_data.dart';
import 'package:rokctapp/infrastructure/models/response/order_status_response.dart';
import 'package:rokctapp/infrastructure/models/data/location_data.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/create_order_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_order_response.dart';
import 'package:rokctapp/infrastructure/models/response/transactions_response.dart';
import 'package:rokctapp/infrastructure/models/models.dart'
    hide UserData, OrderPaginateResponse, PaymentsResponse, Stock;
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart'
    hide OrderStatus;

abstract class OrdersInterface {
  Future<ApiResult<OrderCalculate>> getCalculate({
    required List<Stock> stocks,
    required LocationData? location,
    required String type,
  });

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
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
    required mgr.OrderStatus status,
    String? orderId,
  });

  Future<ApiResult<SingleOrderResponse>> getOrderDetails({String? orderId});

  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    mgr.OrderStatus? status,
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
