import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:venderfoodyman/application/billing/billing_provider.dart';
import 'package:venderfoodyman/application/billing/billing_state.dart';
import 'package:venderfoodyman/application/billing_printer/billing_printer_provider.dart';
import 'package:venderfoodyman/presentation/components/customer/components.dart';
import 'package:venderfoodyman/presentation/theme/customer/app_style.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';

@RoutePage()
class PosCheckoutPage extends ConsumerWidget {
  const PosCheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(billingProvider);
    final printerState = ref.watch(billingPrinterProvider);
    final notifier = ref.read(billingProvider.notifier);
    final printerNotifier = ref.read(billingPrinterProvider.notifier);

    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      appBar: AppBar(
        backgroundColor: AppStyle.white,
        elevation: 0,
        leading: const PopButton(heroTag: 'checkout_pop'),
        title: Text('Checkout', style: AppStyle.interBold(size: 18)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            24.verticalSpace,
            // ─── Order Summary Card ───
            _buildSummary(state),

            24.verticalSpace,
            // ─── Payment QR Code ───
            _buildQRCode(state),

            24.verticalSpace,
            Text(
              'Show this QR to the customer for UPI payment.',
              textAlign: TextAlign.center,
              style: AppStyle.interNormal(size: 14, color: AppStyle.greyColor),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottom(
        context,
        state,
        printerState,
        notifier,
        printerNotifier,
      ),
    );
  }

  Widget _buildSummary(BillingState state) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppStyle.interNormal(
                  size: 14,
                  color: AppStyle.greyColor,
                ),
              ),
              Text(
                '₹${state.totalAmount.toStringAsFixed(2)}',
                style: AppStyle.interNormal(size: 14),
              ),
            ],
          ),
          Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppStyle.interBold(size: 18)),
              Text(
                '₹${state.totalAmount.toStringAsFixed(2)}',
                style: AppStyle.interBold(size: 24, color: AppStyle.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode(BillingState state) {
    // UPI Address logic would go here, for now it's a demo QR or a specific shop UPI
    final String upiUrl =
        "upi://pay?pa=shop@upi&pn=ShopName&am=${state.totalAmount}&cu=INR";

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Center(
        child: PrettyQrView.data(
          data: upiUrl,
          decoration: const PrettyQrDecoration(
            image: PrettyQrDecorationImage(
              image: AssetImage(
                'assets/image/manager.png',
              ), // Using logo from pubspec
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottom(
    BuildContext context,
    BillingState state,
    dynamic printerState,
    dynamic notifier,
    dynamic printerNotifier,
  ) {
    final bool isPrinterConnected = printerState.connectedMac != null;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      decoration: const BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              title: isPrinterConnected ? 'Print & Done' : 'Complete Only',
              onPressed: () async {
                if (isPrinterConnected) {
                  await _handlePrint(state, printerNotifier);
                }
                notifier.clearCart();
                context.maybePop();
              },
            ),
          ),
          if (!isPrinterConnected) ...[
            12.horizontalSpace,
            ButtonsBouncingEffect(
              child: GestureDetector(
                onTap: () {
                  // Navigate to printer settings
                  // ref.read(mainProvider.notifier).selectIndex(3); // Profile/Settings
                },
                child: Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppStyle.blackColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(FlutterRemix.printer_line),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handlePrint(BillingState state, dynamic printerNotifier) async {
    final shop = LocalStorage.getShop();
    await printerNotifier.printReceipt(
      shopName: shop?.translation?.title ?? 'Spazafy Shop',
      address1: shop?.translation?.address ?? '',
      address2: '',
      phone: shop?.phone ?? '',
      total: state.totalAmount,
      footer: 'Thank you for shopping!',
      items: state.cartItems
          .map(
            (item) => {
              'name': item.name,
              'qty': item.quantity,
              'price': item.product.stock?.totalPrice ?? 0.0,
              'total': item.total,
            },
          )
          .toList(),
    );
  }
}
