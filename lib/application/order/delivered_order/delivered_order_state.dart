import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:venderfoodyman/infrastructure/models/customer/models.dart';

part 'delivered_order_state.freezed.dart';

@freezed
abstract class DeliveredOrderState with _$DeliveredOrderState {
  const factory DeliveredOrderState({
    @Default(false) bool isLoading,
    @Default([]) List<OrderDetailData> deliveredOrders,
    @Default(0) num totalDeliveredOrder,
  }) = _DeliveredOrderState;

  const DeliveredOrderState._();
}




