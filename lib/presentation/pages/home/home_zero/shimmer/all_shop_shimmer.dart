import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rokctapp/presentation/components/title/title_icon.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/shimmer/market_shimmer.dart';

class AllShopShimmer extends StatelessWidget {
  final bool isTitle;

  const AllShopShimmer({super.key, this.isTitle = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isTitle
            ? TitleAndIcon(
                title: AppHelpers.getTranslation(TrKeys.allRestaurants),
              )
            : const SizedBox.shrink(),
        AnimationLimiter(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 6.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 2,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: MarketShimmer(isSimpleShop: true, index: index),
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
