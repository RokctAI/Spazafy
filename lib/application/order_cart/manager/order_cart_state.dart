import 'package:rokctapp/infrastructure/models/data/driver/order_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'order_cart_state.freezed.dart';

@freezed
abstract class OrderCartState with _$OrderCartState {
  const factory OrderCartState({
    @Default([]) List<Stock> stocks,
    @Default(0) num totalPrice,
  }) = _OrderCartState;

  const OrderCartState._();
}
