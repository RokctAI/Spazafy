import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/title_icon.dart';
import 'package:rokctapp/presentation/theme/theme.dart';


class RecommendShopShimmer extends StatelessWidget {
  const RecommendShopShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndIcon(
          rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
          isIcon: true,
          title: AppHelpers.getTranslation(TrKeys.recommended),
          titleColor: AppStyle.shimmerBase,
          rightTitleColor: AppStyle.white,
          containerColor: AppStyle.shimmerBase,
          borderColor: AppStyle.shimmerBase,
          iconColor: AppStyle.white,
          onRightTap: () {},
        ),
        12.verticalSpace,
        SizedBox(
          height: 170.h,
          child: AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 4,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Container(
                          margin: EdgeInsets.only(left: 0, right: 9.r),
                          width: MediaQuery.sizeOf(context).width / 3,
                          height: 190.h,
                          decoration: BoxDecoration(
                            color: AppStyle.shimmerBase,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
        30.verticalSpace,
      ],
    );
  }
}
