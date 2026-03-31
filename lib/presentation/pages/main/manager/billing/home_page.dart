import 'package:rokctapp/infrastructure/models/data/manager/stock.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rokctapp/application/order_cart/manager/order_cart_provider.dart';
import 'package:rokctapp/presentation/components/components_manager.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'checkout_page.dart';

class ManagerBillingPage extends ConsumerStatefulWidget {
  const ManagerBillingPage({super.key});

  @override
  ConsumerState<ManagerBillingPage> createState() => _ManagerBillingPageState();
}

class _ManagerBillingPageState extends ConsumerState<ManagerBillingPage> {
  final MobileScannerController scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderCartProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(orderCartProvider);

    return Scaffold(
      backgroundColor: AppStyle.bgGray,
      body: Column(
        children: [
          // 1. Scanner Section
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppStyle.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              child: MobileScanner(
                controller: scannerController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      ref
                          .read(orderCartProvider.notifier)
                          .addStockByBarcode(barcode.rawValue!);
                      // Optional: provide haptic feedback or sound
                    }
                  }
                },
              ),
            ),
          ),

          // 2. Cart Items Header
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.cart),
                  style: AppStyle.interSemi(size: 18.sp),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(orderCartProvider.notifier).clearAll(),
                  child: Text(
                    AppHelpers.getTranslation(TrKeys.clearAll),
                    style: AppStyle.interRegular(color: AppStyle.red),
                  ),
                ),
              ],
            ),
          ),

          // 3. Cart Items List
          Expanded(
            child: cartState.stocks.isEmpty
                ? Center(
                    child: Text(
                      AppHelpers.getTranslation(TrKeys.cartIsEmpty),
                      style: AppStyle.interRegular(color: AppStyle.hintColor),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    itemCount: cartState.stocks.length,
                    itemBuilder: (context, index) {
                      final item = cartState.stocks[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.r),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppStyle.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppStyle.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CommonImage(
                              url: item.product?.img,
                              width: 50.w,
                              height: 50.h,
                              radius: 8.r,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossorigin: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product?.translation?.title ?? '',
                                    style: AppStyle.interSemi(size: 14.sp),
                                  ),
                                  Text(
                                    '${item.totalPrice} x ${item.cartCount}',
                                    style: AppStyle.interRegular(
                                      size: 12.sp,
                                      color: AppStyle.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => ref
                                  .read(orderCartProvider.notifier)
                                  .deleteStockFromCart(stock: item),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppStyle.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // 4. Summary & Checkout
          if (cartState.stocks.isNotEmpty)
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppStyle.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppStyle.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.total),
                        style: AppStyle.interSemi(size: 16.sp),
                      ),
                      Text(
                        AppHelpers.numberFormat(num: cartState.totalPrice),
                        style: AppStyle.interBold(
                          size: 18.sp,
                          color: AppStyle.blue,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  CustomButton(
                    title: AppHelpers.getTranslation(TrKeys.continueText),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManagerCheckoutPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
