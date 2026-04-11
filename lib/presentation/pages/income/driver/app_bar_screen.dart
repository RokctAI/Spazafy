import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/filter/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/exports/components_driver.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

class AbbBarScreen extends StatelessWidget {
  const AbbBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      bottomPadding: 16.h,
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  help.AppHelpers.getTranslation(TrKeys.income),
                  style: AppStyle.interSemi(size: 18.sp),
                ),
                Text(
                  help.AppHelpers.getTranslation(TrKeys.earningsRestaurant),
                  style: AppStyle.interRegular(
                    size: 12.sp,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                help.AppHelpers.showCustomModalBottomSheet(
                  paddingTop: MediaQuery.paddingOf(context).top,
                  context: context,
                  radius: 12,
                  modal: const FilterScreen(isTabBar: false),
                  isDarkMode: true,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: AppStyle.bgGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FlutterRemix.calendar_event_fill,
                  color: AppStyle.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
