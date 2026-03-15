import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:venderfoodyman/infrastructure/models/customer/models.dart';

part 'canceled_order_state.freezed.dart';

@freezed
abstract class CanceledOrderState with _$CanceledOrderState {
  const factory CanceledOrderState({
    @Default(false) bool isLoading,
    @Default([]) List<OrderDetailData> canceledOrders,
    @Default(0) num totalCanceledOrder,
  }) = _CanceledOrderState;

  const CanceledOrderState._();
}




