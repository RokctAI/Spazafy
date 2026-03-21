import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/data/cart_data.dart';
import 'package:rokctapp/infrastructure/models/data/cart_product_data.dart';
part 'shop_order_state.freezed.dart';



@freezed
class ShopOrderState with _$ShopOrderState {
  const factory ShopOrderState({
    @Default(false) bool isLoading,
    @Default(false) bool isStartGroupLoading,
    @Default(false) bool isStartGroup,
    @Default(false) bool isOtherShop,
    @Default(false) bool isDeleteLoading,
    @Default(false) bool isCheckShopOrder,
    @Default(false) bool isAddAndRemoveLoading,
    @Default(false) bool isEditOrder,
    @Default("") String shareLink,
    @Default({}) Map<String, Cart?> carts,
    @Default([]) List<CartProductData> productList,
  }) = _ShopOrderState;

  const ShopOrderState._();
}
