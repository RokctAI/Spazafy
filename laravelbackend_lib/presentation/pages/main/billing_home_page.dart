import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:venderfoodyman/application/billing/billing_provider.dart';
import 'package:venderfoodyman/application/billing/billing_state.dart';
import 'package:venderfoodyman/presentation/component/components.dart';
import 'package:venderfoodyman/presentation/component/billing_browse_modal.dart';
import 'package:venderfoodyman/presentation/styles/style.dart';
import 'package:venderfoodyman/presentation/routes/app_router.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';
import '../component/scan_prompt.dart';

@RoutePage()
class BillingHomePage extends ConsumerStatefulWidget {
  const BillingHomePage({super.key});

  @override
  ConsumerState<BillingHomePage> createState() => _BillingHomePageState();
}

class _BillingHomePageState extends ConsumerState<BillingHomePage> {
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
  );
  bool _isTorchOn = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleCamera() {
    final notifier = ref.read(billingProvider.notifier);
    final isScanning = ref.read(billingProvider).isScanning;
    
    if (isScanning) {
      _scannerController.stop();
      notifier.setScanning(false);
    } else {
      _scannerController.start();
      notifier.setScanning(true);
    }
  }

  void _toggleTorch() {
    setState(() {
      _isTorchOn = !_isTorchOn;
      _scannerController.toggleTorch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billingProvider);
    final notifier = ref.read(billingProvider.notifier);

    return Scaffold(
      backgroundColor: AppStyle.bg,
      body: Stack(
        children: [
          // ─── Camera / Camera-Off Area ───
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.4.sh,
            child: _buildCameraArea(state),
          ),

          // ─── Fixed Controls on Camera Area ───
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: _buildFixedControls(state),
          ),

          // ─── Scan Prompt (Floating) ───
          Positioned(
            bottom: 0.6.sh - 80.h, // Positioned just above the cart panel handle
            left: 0,
            right: 0,
            child: const ScanPrompt(),
          ),

          // ─── Draggable Cart Panel ───
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppStyle.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyle.blackColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        width: 40.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: AppStyle.greyColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    
                    // Cart Summary Header
                    _buildCartHeader(state),
                    
                    // Cart Items List
                    Expanded(
                      child: state.cartItems.isEmpty
                          ? _buildEmptyCart()
                          : ListView.separated(
                              controller: scrollController,
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              itemCount: state.cartItems.length,
                              separatorBuilder: (context, index) => Divider(height: 24.h),
                              itemBuilder: (context, index) {
                                final item = state.cartItems[index];
                                return _buildCartItem(item, notifier);
                              },
                            ),
                    ),
                    
                    // Contextual Bottom Button
                    _buildBottomButton(state),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCameraArea(BillingState state) {
    if (!state.isScanning) {
      return Container(
        color: AppStyle.blackColor.withOpacity(0.05),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FlutterRemix.shopping_cart_2_line, size: 64.r, color: AppStyle.greyColor),
              16.verticalSpace,
              Text(
                'Start a Sale',
                style: AppStyle.interBold(size: 20, color: AppStyle.blackColor),
              ),
              24.verticalSpace,
              CustomButton(
                title: 'Turn on Camera',
                onTap: _toggleCamera,
                width: 180,
                icon: Icon(FlutterRemix.camera_line, color: AppStyle.white, size: 20.r),
              ),
            ],
          ),
        ),
      );
    }

    return MobileScanner(
      controller: _scannerController,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            Vibration.vibrate(duration: 100);
            ref.read(billingProvider.notifier).onBarcodeScanned(barcode.rawValue!);
          }
        }
      },
    );
  }

  Widget _buildFixedControls(BillingState state) {
    return Column(
      children: [
        _buildCircleIcon(
          icon: _isTorchOn ? FlutterRemix.flashlight_fill : FlutterRemix.flashlight_line,
          onTap: _toggleTorch,
          enabled: state.isScanning,
        ),
        8.verticalSpace,
        _buildCircleIcon(
          icon: state.isScanning ? FlutterRemix.camera_off_line : FlutterRemix.camera_line,
          onTap: _toggleCamera,
        ),
        8.verticalSpace,
        _buildCircleIcon(
          icon: FlutterRemix.search_line,
          onTap: () {
            AppHelpers.showCustomModalBottomDragSheet(
              context: context,
              modal: (c) => BillingBrowseModal(controller: c),
              maxChildSize: 0.9,
              initSize: 0.8,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCircleIcon({required IconData icon, required VoidCallback onTap, bool enabled = true}) {
    return ButtonsBouncingEffect(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppStyle.white.withOpacity(enabled ? 0.9 : 0.5),
            boxShadow: [
              BoxShadow(
                color: AppStyle.blackColor.withOpacity(0.1),
                blurRadius: 5,
              ),
            ],
          ),
          child: Icon(icon, size: 20.r, color: AppStyle.blackColor),
        ),
      ),
    );
  }

  Widget _buildCartHeader(BillingState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scanned Items',
                style: AppStyle.interBold(size: 16),
              ),
              Text(
                '${state.cartItems.length} items total',
                style: AppStyle.interNormal(size: 12, color: AppStyle.greyColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL PRICE',
                style: AppStyle.interNormal(size: 10, color: AppStyle.greyColor),
              ),
              Text(
                '₹${state.totalAmount.toStringAsFixed(2)}',
                style: AppStyle.interBold(size: 20, color: AppStyle.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FlutterRemix.inbox_line, size: 48.r, color: AppStyle.greyColor.withOpacity(0.5)),
          8.verticalSpace,
          Text('Cart is empty', style: AppStyle.interNormal(color: AppStyle.greyColor)),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic item, BillingNotifier notifier) {
    return Row(
      children: [
        CommonImage(url: item.imageUrl, width: 40, height: 40, radius: 8),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: AppStyle.interBold(size: 14)),
              Text('₹${item.product.stock?.totalPrice?.toStringAsFixed(1)} / ${item.uom ?? 'unit'}', 
                   style: AppStyle.interNormal(size: 12, color: AppStyle.greyColor)),
            ],
          ),
        ),
        Row(
          children: [
            _qtyBtn(FlutterRemix.subtract_line, () => notifier.updateQuantity(item.product, item.quantity - 1)),
            SizedBox(
              width: 30.w,
              child: Center(child: Text('${item.quantity}', style: AppStyle.interBold())),
            ),
            _qtyBtn(FlutterRemix.add_line, () => notifier.updateQuantity(item.product, item.quantity + 1)),
          ],
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppStyle.greyColor.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 16.r),
      ),
    );
  }

  Widget _buildBottomButton(BillingState state) {
    final bool isEmpty = state.cartItems.isEmpty;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: CustomButton(
        title: isEmpty ? 'Manage Stock' : 'Review Order',
        icon: Icon(isEmpty ? FlutterRemix.archive_line : FlutterRemix.check_line, 
                  color: AppStyle.white, size: 20.r),
        isLoading: false,
        onTap: () {
          if (isEmpty) {
            // Navigate to products/stock (FoodsPage is index 2 in MainPage)
            ref.read(mainProvider.notifier).selectIndex(2);
          } else {
            context.pushRoute(const BillingCheckoutRoute());
          }
        },
      ),
    );
  }
}
