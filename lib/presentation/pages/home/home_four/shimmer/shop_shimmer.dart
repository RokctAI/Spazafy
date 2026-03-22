import 'package:rokctapp/dummy_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rokctapp/presentation/components/title_icon.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/pages/home/home_four/shimmer/market_shimmer.dart';
//import '../../../../infrastructure/services/app_helpers.dart';
//import '../../../../infrastructure/services/tr_keys.dart';

class ShopShimmer extends StatelessWidget {
  final String title;

  const ShopShimmer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndIcon(
          rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
          isIcon: true,
          title: title,
          titleColor: AppStyle.shimmerBase,
          rightTitleColor: AppStyle.white,
          containerColor: AppStyle.shimmerBase,
          borderColor: AppStyle.shimmerBase,
          iconColor: AppStyle.white,
          onRightTap: () {},
        ),
        12.verticalSpace,
        SizedBox(
          height: 100.h,
          child: AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: MarketShimmer(index: index, isShop: true),
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
