import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:rokctapp/application/order_cart/manager/order_cart_provider.dart';
import 'package:rokctapp/application/pos/pos_provider.dart';
import 'package:rokctapp/printer/providers/billing_printer_provider.dart';
import 'package:rokctapp/presentation/components/components_manager.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';

import 'package:rokctapp/infrastructure/services/utils/pay_verification_helper.dart';

class ManagerCheckoutPage extends ConsumerStatefulWidget {
  const ManagerCheckoutPage({super.key});

  @override
  ConsumerState<ManagerCheckoutPage> createState() => _ManagerCheckoutPageState();
}

class _ManagerCheckoutPageState extends ConsumerState<ManagerCheckoutPage> {
  bool isWaitingForPayment = false;
  final TextEditingController otpController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(orderCartProvider);
    final isSaving = ref.watch(posProvider);

    final shopData = LocalStorage.getShop();
    final shopId = shopData?.id ?? "0";
    final shopIdSegment = shopId.length > 4 
        ? shopId.substring(shopId.length - 4)
        : shopId;
    
    // Using a stable order ID for this checkout session
    final orderId = "POS-${DateTime.now().millisecondsSinceEpoch}";
    final uniqueOrderCode = "PZ$shopIdSegment${orderId.substring(orderId.length - 4)}";
    
    // Construct Payment URL with mandatory parameters for the backend
    final paymentUrl =
        "${AppConstants.webUrl}/pay/$uniqueOrderCode?amount=${cartState.totalPrice}&shop_id=$shopId&order_id=$orderId";

    return Scaffold(
      backgroundColor: AppStyle.white,
      appBar: AppBar(
        backgroundColor: AppStyle.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FlutterRemix.arrow_left_line, color: AppStyle.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppHelpers.getTranslation(TrKeys.checkout),
          style: AppStyle.interSemi(size: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Restaurant/Shop Item
              RestaurantItem(
                shopName: shopData?.translation?.title ?? "Manager POS",
                shopImage: shopData?.logoImg ?? "",
                shopText: isWaitingForPayment ? "Waiting for Payment..." : "Active Transaction",
                shopUid: shopId,
                shopId: shopId,
              ),
              24.verticalSpace,

              if (!isWaitingForPayment) ...[
                // 2. Scan QR Section
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppStyle.shimmerBase),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Row(
                    children: [
                      const Icon(FlutterRemix.qr_code_line, color: AppStyle.blue),
                      12.horizontalSpace,
                      Expanded(
                        child: Text(
                          "Let the customer scan this QR to pay online.",
                          style: AppStyle.interRegular(size: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                32.verticalSpace,
                Center(
                  child: SizedBox(
                    width: 220.r,
                    height: 220.r,
                    child: PrettyQrView.data(
                      data: paymentUrl,
                      decoration: PrettyQrDecoration(
                        image: PrettyQrDecorationImage(
                          image: shopData?.logoImg != null && shopData!.logoImg!.isNotEmpty
                              ? NetworkImage(shopData.logoImg!) as ImageProvider
                              : const AssetImage('assets/image/manager.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                24.verticalSpace,
                CustomButton(
                  title: "I've Scanned, Wait for Code",
                  background: AppStyle.blue.withOpacity(0.1),
                  textColor: AppStyle.blue,
                  onPressed: () => setState(() => isWaitingForPayment = true),
                ),
              ] else ...[
                // 3. Enter OTP Section
                Container(
                  decoration: BoxDecoration(
                    color: AppStyle.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppStyle.blue.withOpacity(0.2)),
                  ),
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    children: [
                      Text(
                        "Waiting for Payment",
                        style: AppStyle.interSemi(size: 18.sp, color: AppStyle.blue),
                      ),
                      12.verticalSpace,
                      Text(
                        "Enter the 5-digit verification code provided by the customer after successful payment.",
                        textAlign: TextAlign.center,
                        style: AppStyle.interRegular(size: 14.sp, color: AppStyle.textGrey),
                      ),
                      24.verticalSpace,
                      CustomTextField(
                        controller: otpController,
                        label: "5-Digit Code",
                        inputType: TextInputType.number,
                        maxLength: 5,
                        textAlign: TextAlign.center,
                        onChanged: (val) {
                          if (val.length == 5) {
                            setState(() => errorMessage = null);
                          }
                        },
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            errorMessage!,
                            style: AppStyle.interRegular(size: 12.sp, color: AppStyle.red),
                          ),
                        ),
                    ],
                  ),
                ),
                16.verticalSpace,
                TextButton(
                  onPressed: () => setState(() => isWaitingForPayment = false),
                  child: Text("Show QR Code Again", style: AppStyle.interRegular(color: AppStyle.textGrey)),
                ),
              ],

              32.verticalSpace,

              // 4. Order Summary
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppStyle.bgGray,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.total),
                      style: AppStyle.interSemi(size: 16.sp),
                    ),
                    Text(
                      AppHelpers.numberFormat(num: cartState.totalPrice),
                      style: AppStyle.interBold(size: 18.sp, color: AppStyle.blue),
                    ),
                  ],
                ),
              ),
              40.verticalSpace,

              // 5. Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        side: const BorderSide(color: AppStyle.blue),
                      ),
                      onPressed: () {
                        ref.read(billingPrinterProvider.notifier).printReceipt(
                          shopName: shopData?.translation?.title ?? "My Shop",
                          address1: shopData?.location != null 
                              ? "${shopData?.location?.latitude}, ${shopData?.location?.longitude}"
                              : "Main St 123",
                          address2: "",
                          phone: shopData?.phone ?? "555-0101",
                          items: cartState.stocks.map((s) => {
                            'name': s.product?.translation?.title ?? '',
                            'qty': s.cartCount,
                            'price': s.totalPrice,
                            'total': (s.totalPrice ?? 0) * (s.cartCount ?? 0),
                          }).toList(),
                          total: cartState.totalPrice.toDouble(),
                          footer: "Thank you for shopping!",
                        );
                      },
                      child: Text(
                        AppHelpers.getTranslation(TrKeys.print),
                        style: AppStyle.interSemi(size: 16.sp, color: AppStyle.blue),
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      title: isWaitingForPayment ? "Verify & Finish" : AppHelpers.getTranslation(TrKeys.finish),
                      isLoading: isSaving,
                      onPressed: () async {
                        if (isWaitingForPayment) {
                          // Verify OTP locally
                          final isValid = PayVerificationHelper.verifyCode(
                            enteredCode: otpController.text,
                            orderId: orderId,
                            amount: cartState.totalPrice.toDouble(),
                            shopId: shopId,
                            secret: shopData?.sharedSecret,
                          );

                          if (!isValid) {
                            setState(() => errorMessage = "Invalid Verification Code. Please try again.");
                            return;
                          }
                        }

                        // Proceed to finish sale
                        await ref.read(posProvider.notifier).finishSale(
                          paymentType: isWaitingForPayment ? 'online' : 'cash',
                          amountPaid: cartState.totalPrice.toDouble(),
                        );
                        
                        if (context.mounted) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          AppHelpers.showCheckTopSnackBarDone(context, "Sale Completed Successfully");
                        }
                      },
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
