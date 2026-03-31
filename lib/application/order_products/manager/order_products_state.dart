import 'package:rokctapp/infrastructure/models/data/manager/product_data.dart';
import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
part 'order_products_state.freezed.dart';

@freezed
abstract class OrderProductsState with _$OrderProductsState {
  const factory OrderProductsState({
    @Default(false) bool isLoading,
    @Default([]) List<ProductData> products,
    @Default('single') String productType,
  }) = _OrderProductsState;

  const OrderProductsState._();
}
