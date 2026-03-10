import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venderfoodyman/application/billing/billing_provider.dart';
import 'package:venderfoodyman/application/billing/billing_state.dart';
import 'package:venderfoodyman/presentation/styles/style.dart';
import 'package:venderfoodyman/presentation/component/components.dart';

class ScanPrompt extends ConsumerWidget {
  const ScanPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billingProvider);
    final notifier = ref.read(billingProvider.notifier);

    if (state.promptType == ScanPromptType.none) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppStyle.blackColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _buildContent(context, state, notifier),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BillingState state,
    BillingNotifier notifier,
  ) {
    switch (state.promptType) {
      case ScanPromptType.found:
      case ScanPromptType.repeat:
        return _buildProductFound(state, notifier);
      case ScanPromptType.extras:
        return _buildExtrasSelection(state, notifier);
      case ScanPromptType.unknown:
        return _buildUnknownBarcode(state, notifier);
      case ScanPromptType.lowStock:
        return _buildLowStockWarning(state, notifier);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProductFound(BillingState state, BillingNotifier notifier) {
    final product = state.selectedProduct!;
    return Row(
      children: [
        CommonImage(url: product.img, width: 50, height: 50, radius: 8),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.translation?.title ?? 'Product',
                style: AppStyle.interNormal(
                  size: 14,
                  color: AppStyle.blackColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.verticalSpace,
              Text(
                '₹${product.stock?.totalPrice?.toStringAsFixed(2) ?? '0.00'} / ${product.unit?.translation?.title ?? 'unit'}',
                style: AppStyle.interNormal(
                  size: 12,
                  color: AppStyle.greyColor,
                ),
              ),
            ],
          ),
        ),
        if (state.scanCount > 1)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppStyle.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '×${state.scanCount}',
              style: AppStyle.interBold(size: 14, color: AppStyle.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildExtrasSelection(BillingState state, BillingNotifier notifier) {
    // Basic implementation for extras selection
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select Options: ${state.selectedProduct?.translation?.title}',
          style: AppStyle.interBold(size: 14),
        ),
        8.verticalSpace,
        // List extras here...
        Text('Extras UI TBD', style: AppStyle.interNormal(size: 12)),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              title: 'Cancel',
              onTap: notifier.dismissPrompt,
              background: AppStyle.transparent,
              textColor: AppStyle.blackColor,
              width: 80,
              height: 36,
            ),
            8.horizontalSpace,
            CustomButton(
              title: 'Confirm',
              onTap: () {
                notifier.addToCart(state.selectedProduct!);
                notifier.dismissPrompt();
              },
              width: 100,
              height: 36,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnknownBarcode(BillingState state, BillingNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            8.horizontalSpace,
            Expanded(
              child: Text(
                'Barcode: ${state.lastScannedBarcode}',
                style: AppStyle.interBold(size: 14),
              ),
            ),
          ],
        ),
        4.verticalSpace,
        Text(
          'Product not found in database.',
          style: AppStyle.interNormal(size: 12),
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              title: 'Dismiss',
              onTap: notifier.dismissPrompt,
              background: AppStyle.transparent,
              textColor: AppStyle.blackColor,
              width: 80,
              height: 36,
            ),
            8.horizontalSpace,
            CustomButton(
              title: 'Receive Stock',
              onTap: () {
                // Navigate to add product with barcode
                notifier.dismissPrompt();
              },
              width: 130,
              height: 36,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLowStockWarning(BillingState state, BillingNotifier notifier) {
    final product = state.selectedProduct!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CommonImage(url: product.img, width: 40, height: 40, radius: 4),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.translation?.title ?? '',
                    style: AppStyle.interBold(size: 14),
                  ),
                  Text(
                    '⚠️ Low stock: ${product.stock?.quantity ?? 0} remaining',
                    style: AppStyle.interNormal(size: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              title: 'Continue Selling',
              onTap: () {
                notifier.addToCart(product);
                notifier.dismissPrompt();
              },
              background: AppStyle.transparent,
              textColor: AppStyle.blackColor,
              width: 140,
              height: 36,
            ),
            8.horizontalSpace,
            CustomButton(
              title: 'Order More',
              onTap: () {
                // Feature TBD
                notifier.addToCart(product);
                notifier.dismissPrompt();
              },
              width: 110,
              height: 36,
            ),
          ],
        ),
      ],
    );
  }
}
