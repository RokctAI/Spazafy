import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:rokctapp/application/billing/billing_provider.dart';
import 'package:rokctapp/application/billing/billing_state.dart';
import 'package:rokctapp/presentation/components/components.dart';
import 'package:rokctapp/presentation/components/billing_browse_modal.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import '../../components/scan_prompt.dart';
import 'package:rokctapp/application/main/main_provider.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

@RoutePage()
class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
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
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
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
              top: 0.35.sh, // Positioned at the bottom of the camera area
              left: 16.w,
              right: 16.w,
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
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
                                padding: EdgeInsets.fromLTRB(
                                  16.w,
                                  8.h,
                                  16.w,
                                  140.h, // Bottom padding to keep items visible above floating button
                                ),
                                itemCount: state.cartItems.length,
                                separatorBuilder: (context, index) =>
                                    12.verticalSpace,
                                itemBuilder: (context, index) {
                                  final item = state.cartItems[index];
                                  return _buildCartItem(item, notifier);
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),

            Positioned(
              left: 16.w,
              right: 16.w,
              bottom:
                  MediaQuery.of(context).padding.bottom +
                  100.h, // Higher clearance for bottom nav
              child: _buildBottomButton(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraArea(BillingState state) {
    if (!state.isScanning) {
      return Container(
        color: const Color(0xFF1E293B),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Retain the icons/style as requested
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FlutterRemix.camera_off_line,
                  size: 40.r,
                  color: AppStyle.white,
                ),
              ),
              24.verticalSpace,
              Text(
                'Camera is turned off',
                style: AppStyle.interBold(size: 20, color: AppStyle.white),
              ),
              8.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Turn on your camera to start scanning barcodes and items automatically.',
                  textAlign: TextAlign.center,
                  style: AppStyle.interNormal(
                    size: 13,
                    color: AppStyle.white.withOpacity(0.7),
                  ),
                ),
              ),
              24.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    title: 'Start a Sale',
                    onPressed: _toggleCamera,
                    width: 180.w,
                    icon: Icon(
                      FlutterRemix.camera_line,
                      color: AppStyle.white,
                      size: 20.r,
                    ),
                  ),
                  12.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      // Browse items
                      ref.read(mainProvider.notifier).selectIndex(2);
                    },
                    child: Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppStyle.white.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        FlutterRemix.search_line,
                        color: AppStyle.white,
                        size: 24.r,
                      ),
                    ),
                  ),
                ],
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
            ref
                .read(billingProvider.notifier)
                .onBarcodeScanned(barcode.rawValue!);
          }
        }
      },
    );
  }

  Widget _buildFixedControls(BillingState state) {
    return Column(
      children: [
        _buildCircleIcon(
          icon: FlutterRemix.lock_line,
          onTap: () {
            context.pushRoute(PinRoute(type: PinPageType.lock));
          },
        ),
        8.verticalSpace,
        _buildCircleIcon(
          icon: _isTorchOn
              ? FlutterRemix.flashlight_fill
              : FlutterRemix.flashlight_line,
          onTap: _toggleTorch,
          enabled: state.isScanning,
        ),
        8.verticalSpace,
        _buildCircleIcon(
          icon: state.isScanning
              ? FlutterRemix.camera_off_line
              : FlutterRemix.camera_line,
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

  Widget _buildCircleIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
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
              Text('Scanned Items', style: AppStyle.interBold(size: 16)),
              Text(
                '${state.cartItems.length} items total',
                style: AppStyle.interNormal(
                  size: 12,
                  color: AppStyle.greyColor,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL PRICE',
                style: AppStyle.interBold(
                  size: 11,
                  color: AppStyle.greyColor.withOpacity(0.8),
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '₹${state.totalAmount.toStringAsFixed(2)}',
                style: AppStyle.interBold(size: 22, color: AppStyle.primary),
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
          Icon(
            FlutterRemix.inbox_line,
            size: 48.r,
            color: AppStyle.greyColor.withOpacity(0.5),
          ),
          8.verticalSpace,
          Text(
            'Cart is empty',
            style: AppStyle.interNormal(color: AppStyle.greyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic item, BillingNotifier notifier) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppStyle.differBorderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppStyle.blackColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CommonImage(
            url: item.product.img,
            width: 50.r,
            height: 50.r,
            radius: 12.r,
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.translation?.title ?? '',
                  style: AppStyle.interBold(size: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  '₹${item.product.stock?.totalPrice?.toStringAsFixed(1)} / ${item.product.unit?.translation?.title ?? 'unit'}',
                  style: AppStyle.interNormal(
                    size: 13,
                    color: AppStyle.greyColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppStyle.greyColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                _qtyBtn(
                  FlutterRemix.subtract_line,
                  () =>
                      notifier.updateQuantity(item.product, item.quantity - 1),
                ),
                SizedBox(
                  width: 36.w,
                  child: Center(
                    child: Text(
                      '${item.quantity}',
                      style: AppStyle.interBold(size: 14),
                    ),
                  ),
                ),
                _qtyBtn(
                  FlutterRemix.add_line,
                  () =>
                      notifier.updateQuantity(item.product, item.quantity + 1),
                ),
              ],
            ),
          ),
        ],
      ),
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
    return CustomButton(
      title: isEmpty ? 'Manage Stock' : 'Review Order',
      icon: Icon(
        isEmpty ? FlutterRemix.archive_line : FlutterRemix.check_line,
        color: AppStyle.white,
        size: 20.r,
      ),
      isLoading: false,
      onPressed: () {
        if (isEmpty) {
          ref.read(mainProvider.notifier).selectIndex(2);
        } else {
          context.pushRoute(const PosCheckoutRoute());
        }
      },
    );
  }
}
