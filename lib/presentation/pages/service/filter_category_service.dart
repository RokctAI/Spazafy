import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/home/home_notifier.dart';
import 'package:rokctapp/application/home/home_state.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/loading.dart';
import 'package:rokctapp/presentation/components/market_item.dart';
import 'package:rokctapp/presentation/components/title_icon.dart';
import 'package:rokctapp/presentation/pages/home/home_four/widgets/market_one_item.dart';
import 'package:rokctapp/presentation/pages/home/home_four/widgets/market_three_item.dart';
import 'package:rokctapp/presentation/pages/service/widgets/service_one_category.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/presentation/pages/home/home_four/widgets/market_two_item.dart';
import 'widgets/service_three_category.dart';
import 'widgets/service_two_category.dart';

class FilterCategoryService extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final int categoryIndex;
  final RefreshController restaurantController;

  const FilterCategoryService({
    super.key,
    required this.state,
    required this.event,
    required this.categoryIndex,
    required this.restaurantController,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      physics: const BouncingScrollPhysics(),
      controller: restaurantController,
      header: WaterDropMaterialHeader(
        distance: 160.h,
        backgroundColor: AppStyle.white,
        color: AppStyle.textGrey,
      ),
      onLoading: () {
        event.fetchFilterShops(context, controller: restaurantController);
      },
      onRefresh: () {
        event.fetchFilterShops(
          context,
          controller: restaurantController,
          isRefresh: true,
        );
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            AppHelpers.getType() == 1
                ? ServiceOneCategory(
                    state: state,
                    event: event,
                    categoryIndex: categoryIndex,
                  )
                : AppHelpers.getType() == 2
                ? ServiceTwoCategory(
                    state: state,
                    event: event,
                    categoryIndex: categoryIndex,
                  )
                : AppHelpers.getType() == 3
                ? ServiceThreeCategory(
                    state: state,
                    event: event,
                    categoryIndex: categoryIndex,
                  )
                : ServiceTwoCategory(
                    state: state,
                    event: event,
                    categoryIndex: categoryIndex,
                  ),
            TitleAndIcon(
              title: AppHelpers.getTranslation(TrKeys.restaurants),
              rightTitle:
                  "${AppHelpers.getTranslation(TrKeys.found)} ${state.filterShops.length.toString()} ${AppHelpers.getTranslation(TrKeys.results)}",
            ),
            state.isSelectCategoryLoading == -1
                ? const Loading()
                : state.filterShops.isNotEmpty
                ? ListView.builder(
                    padding: REdgeInsets.symmetric(vertical: 12),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: state.filterShops.length,
                    itemBuilder: (context, index) => Padding(
                      padding: REdgeInsets.only(bottom: 12),
                      child: AppHelpers.getType() == 1
                          ? MarketOneItem(
                              shop: state.filterShops[index],
                              isSimpleShop: true,
                            )
                          : AppHelpers.getType() == 2
                          ? MarketTwoItem(
                              shop: state.filterShops[index],
                              isSimpleShop: true,
                              isFilter: true,
                            )
                          : AppHelpers.getType() == 3
                          ? MarketThreeItem(
                              shop: state.filterShops[index],
                              isSimpleShop: true,
                            )
                          : MarketItem(
                              shop: state.filterShops[index],
                              isSimpleShop: true,
                            ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: _resultEmpty(),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _resultEmpty() {
  return Column(
    children: [
      Image.asset("assets/images/notFound.png"),
      Text(
        AppHelpers.getTranslation(TrKeys.nothingFound),
        style: AppStyle.interSemi(size: 18.sp),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Text(
          AppHelpers.getTranslation(TrKeys.trySearchingAgain),
          style: AppStyle.interRegular(size: 14.sp),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
