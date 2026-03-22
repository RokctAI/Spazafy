import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final bool scroll;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
    this.scroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      height: 48.h,
      decoration: BoxDecoration(
        color: AppStyle.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppStyle.tabBarBorderColor),
      ),
      child: TabBar(
        isScrollable: scroll,
        controller: tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppStyle.black,
        ),
        labelColor: AppStyle.white,
        unselectedLabelColor: AppStyle.textGrey,
        unselectedLabelStyle: AppStyle.interRegular(size: 14.sp),
        labelStyle: AppStyle.interSemi(size: 14.sp),
        tabs: tabs,
      ),
    );
  }
}
