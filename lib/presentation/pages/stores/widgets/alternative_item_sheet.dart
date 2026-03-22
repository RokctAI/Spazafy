import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/shop/shop_provider.dart';
import 'package:rokctapp/application/shop_order/shop_order_provider.dart';
import 'package:rokctapp/infrastructure/models/data/cart_data.dart';
import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/custom_network_image.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/infrastructure/models/response/all_products_response.dart';

class AlternativeItemSheet extends ConsumerWidget {
  final String shopId;
  final String stockId;
  final ScrollController controller;

  const AlternativeItemSheet({
    super.key,
    required this.shopId,
    required this.stockId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopProvider);
    final cartState = ref.watch(shopOrderProvider);
    final currentCart = cartState.carts[shopId];

    // Find the current item category
    String? categoryId;
    if (currentCart != null) {
      for (final userCart in currentCart.userCarts ?? []) {
        for (final detail in userCart.cartDetails ?? []) {
          if (detail.stock?.id == stockId) {
            categoryId = detail.stock?.product?.categoryId;
            break;
          }
        }
        if (categoryId != null) break;
      }
    }

    // Find products in the same category from shopState.allData
    List<ProductData> alternatives = [];
    if (categoryId != null) {
      for (final section in shopState.allData) {
        // If the section title matches the category or if we just want all other products
        // Actually, we can look through all products and find those with same categoryId
        for (final product in section.products ?? []) {
          if (product.categoryId == categoryId &&
              product.stock?.id != stockId) {
            // Convert Product to ProductData (if necessary) or just use its fields
            // The allData products are of type Product (from AllProductsResponse)
            // ProductData is used in CartDetail.
            // Let's assume they are compatible or create a simple mapper
            alternatives.add(ProductData.fromJson(product.toJson()));
          }
        }
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      child: Column(
        children: [
          8.verticalSpace,
          Container(
            height: 4.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: AppStyle.dragElement,
              borderRadius: BorderRadius.circular(40.r),
            ),
          ),
          24.verticalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.chooseAlternative),
            style: AppStyle.interSemi(size: 18),
          ),
          16.verticalSpace,
          if (alternatives.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  AppHelpers.getTranslation(TrKeys.noAlternativesFound),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: alternatives.length,
                itemBuilder: (context, index) {
                  final item = alternatives[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    leading: CustomNetworkImage(
                      url: item.img ?? "",
                      height: 50.h,
                      width: 50.h,
                      radius: 8.r,
                    ),
                    title: Text(
                      item.translation?.title ?? "",
                      style: AppStyle.interNormal(size: 14),
                    ),
                    subtitle: Text(
                      AppHelpers.numberFormat(number: item.stock?.totalPrice),
                      style: AppStyle.interSemi(
                        size: 14,
                        color: AppStyle.primary,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppStyle.textGrey,
                    ),
                    onTap: () {
                      if (item.stock != null) {
                        ref
                            .read(shopOrderProvider.notifier)
                            .setAlternativeStock(
                              shopId: shopId,
                              stockId: stockId,
                              alternativeStock: item.stock!,
                            );
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
