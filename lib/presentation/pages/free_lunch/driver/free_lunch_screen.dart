import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';
import 'package:rokctapp/presentation/theme/driver/app_style.dart';
import 'bar_code_screen.dart';

class FreeLunchScreen extends StatelessWidget {
  const FreeLunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppStyle.shimmerBase),
            ),
            padding: EdgeInsets.all(10.r),
            child: Row(
              children: [
                SizedBox(
                  height: 56.h,
                  child: Stack(
                    children: [
                      Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppStyle.orangeColor,
                        ),
                        child: Center(
                          child: Text(
                            "4.5",
                            style: AppStyle.interSemi(
                              size: 16.sp,
                              color: AppStyle.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 10.w,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppStyle.black,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppStyle.white),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 3.h,
                            horizontal: 7.w,
                          ),
                          child: Icon(
                            FlutterRemix.star_fill,
                            color: AppStyle.white,
                            size: 12.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: AppHelpers.getTranslation(TrKeys.freeLunches),
                          style: AppStyle.interSemi(
                            size: 14.sp,
                            letterSpacing: -0.3,
                          ),
                          children: [
                            TextSpan(
                              text: AppHelpers.getTranslation(
                                TrKeys.matchingYourRank,
                              ),
                              style: AppStyle.interRegular(
                                size: 14.sp,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: AppHelpers.getTranslation(TrKeys.onlyOne),
                          style: AppStyle.interSemi(
                            size: 14.sp,
                            letterSpacing: -0.3,
                          ),
                          children: [
                            TextSpan(
                              text: AppHelpers.getTranslation(TrKeys.lunchCan),
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
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 2,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 32.h),
              itemCount: 8,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    AppHelpers.showCustomModalBottomSheet(
                      paddingTop: MediaQuery.paddingOf(context).top,
                      context: context,
                      modal: const BarCodeScreen(),
                      isDarkMode: false,
                    );
                  },
                  child: RestaurantItem(
                    shopName: "Evos",
                    shopImage:
                        "https://dostavkainfo.uz/wp-content/uploads/2020/03/evos.png",
                    shopText: "Combo #1",
                    shopUid: index.toString(),
                    shopId: index.toString(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
