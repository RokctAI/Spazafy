import 'package:rokctapp/infrastructure/models/data/order_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'cooking_orders_state.freezed.dart';

@freezed
abstract class CookingOrdersState with _$CookingOrdersState {
  const factory CookingOrdersState({
    @Default(false) bool isLoading,
    @Default([]) List<OrderData> orders,
    @Default(0) int totalCount,
  }) = _CookingOrdersState;

  const CookingOrdersState._();
}
