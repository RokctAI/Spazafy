import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/presentation/components/driver/restaurant_item.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart' as help;
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/app_assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/application/providers_driver.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
// ignore_for_file: deprecated_member_use

class BarCodeScreen extends StatelessWidget {
  const BarCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          const RestaurantItem(
            shopName: "Evos",
            shopImage:
                "https://dostavkainfo.uz/wp-content/uploads/2020/03/evos.png",
            shopText: "Combo #1",
            shopUid: "0",
            shopId: "0",
          ),
          16.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppStyle.shimmerBase),
            ),
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                const Icon(
                  FlutterRemix.error_warning_fill,
                  color: AppStyle.blue,
                ),
                12.horizontalSpace,
                RichText(
                  text: TextSpan(
                    text: help.AppHelpers.getTranslation(TrKeys.youWillShow),
                    style: AppStyle.interRegular(
                      size: 14.sp,
                      letterSpacing: -0.3,
                    ),
                    children: [
                      TextSpan(
                        text: help.AppHelpers.getTranslation(TrKeys.qRCode),
                        style: AppStyle.interSemi(
                          size: 14.sp,
                          letterSpacing: -0.3,
                        ),
                      ),
                      TextSpan(
                        text: help.AppHelpers.getTranslation(TrKeys.toTheRestaurant),
                        style: AppStyle.interRegular(
                          size: 14.sp,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          24.verticalSpace,
          Image.asset(Assets.imageQr),
          24.verticalSpace,
          Consumer(
            builder: (context, ref, child) {
              return CustomButton(
                title: help.AppHelpers.getTranslation(TrKeys.showOnMap),
                icon: const Icon(
                  FlutterRemix.map_pin_range_fill,
                  color: AppStyle.black,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  final Uint8List markerMarketIcon =
                      await help.AppHelpers.getBytesFromAsset(
                        Assets.imageMarker,
                        100,
                      ).whenComplete(() {});
                  ref
                      .read(homeProvider.notifier)
                      .getRoutingAll(
                        // ignore: use_build_context_synchronously
                        context: context,
                        start: LatLng(
                          LocalStorage.getAddressSelected()?.latitude ??
                              AppConstants.demoLatitude,
                          LocalStorage.getAddressSelected()?.longitude ??
                              AppConstants.demoLongitude,
                        ),
                        end: const LatLng(41.285127, 69.172530),
                        market: Marker(
                          markerId: const MarkerId("Shop"),
                          position: const LatLng(41.285127, 69.172530),
                          icon: BitmapDescriptor.fromBytes(markerMarketIcon),
                        ),
                      );
                },
              );
            },
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
