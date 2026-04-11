import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/restaurant/manager/income/statistics/statistics_notifier.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/manager/custom_app_bar.dart';
import 'package:rokctapp/presentation/components/manager/filter_screen.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class AppbarScreen extends StatelessWidget {
  final StatisticsNotifier event;

  const AppbarScreen({super.key, required this.event});

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
                  style: AppStyle.interSemi(size: 18),
                ),
                Text(
                  help.AppHelpers.getTranslation(TrKeys.earningsRestaurant),
                  style: AppStyle.interRegular(size: 12, letterSpacing: -0.3),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                help.AppHelpers.showCustomModalBottomSheet(
                  paddingTop: MediaQuery.paddingOf(context).top,
                  context: context,
                  radius: 12,
                  modal: FilterScreen(
                    isTabBar: false,
                    onChangeDay: (rangeDatePicker) {
                      event.fetchStatistics(
                        startTime: rangeDatePicker.last ?? DateTime.now(),
                        endTime: rangeDatePicker.first ?? DateTime.now(),
                      );
                    },
                  ),
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
                  color: AppStyle.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
