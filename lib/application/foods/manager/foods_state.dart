import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'foods_state.freezed.dart';

@freezed
abstract class FoodsState with _$FoodsState {
  const factory FoodsState({
    @Default(false) bool isLoading,
    @Default([]) List<ProductData> foods,
    @Default('single') String productType,
  }) = _FoodsState;
  const FoodsState._();
}
