import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';

import 'package:venderfoodyman/infrastructure/driver/services/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/driver/services/tr_keys.dart';
import '../styles/style.dart';

class ProductItem extends StatelessWidget {
  final Product? product;
  final num? amount;
  final String price;

  const ProductItem({
    super.key,
    required this.product,
    required this.amount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.translation?.title ?? "",
                    style: AppStyle.interSemi(size: 14.sp, color: AppStyle.blackColor),
                  ),
                  4.verticalSpace,
                  Text(
                    "${AppHelpers.getTranslation(TrKeys.amount)} — ${(amount ?? 1) * (product?.interval ?? 1)} ${(product?.unit?.translation?.title ?? "")}",
                    style: AppStyle.interRegular(size: 14.sp, color: AppStyle.blackColor),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: AppStyle.interSemi(size: 14.sp, color: AppStyle.blackColor),
            ),
          ],
        ),
        product?.translation?.description != null
            ? Column(
                children: [
                  16.verticalSpace,
                  SizedBox(
                    width: 200.w,
                    child: RichText(
                      text: TextSpan(
                        text: "${AppHelpers.getTranslation(TrKeys.sideDish)}:",
                        style: AppStyle.interSemi(size: 14.sp, color: AppStyle.blackColor),
                        children: [
                          TextSpan(
                            text: product?.translation?.description ?? "",
                            style: AppStyle.interRegular(
                              size: 14.sp,
                              color: AppStyle.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}





