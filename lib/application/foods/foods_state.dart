import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';

part 'foods_state.freezed.dart';

@freezed
abstract class FoodsState with _$FoodsState {
  const factory FoodsState({
    @Default(false) bool isLoading,
    @Default([]) List<ProductData> foods,
    @Default('single') String productType,
    @Default(true) bool toggle,
    @Default(0) int timeIndex,
  }) = _FoodsState;
  const FoodsState._();
}
