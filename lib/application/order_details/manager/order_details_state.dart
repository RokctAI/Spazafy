import 'package:rokctapp/infrastructure/models/data/order_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/data/order_data.dart';

part 'order_details_state.freezed.dart';

@freezed
abstract class OrderDetailsState with _$OrderDetailsState {
  const factory OrderDetailsState({
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,
    OrderData? order,
  }) = _OrderDetailsState;

  const OrderDetailsState._();
}
