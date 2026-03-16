import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/parcel/parcel_provider.dart';
import 'package:rokctapp/presentation/pages/driver/parcel/parcel_item.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/presentation/components/components.dart';
import 'package:rokctapp/presentation/components/loading.dart';
import 'package:rokctapp/presentation/theme/theme.dart';

@RoutePage()
class ParcelHistoryPage extends ConsumerStatefulWidget {
  const ParcelHistoryPage({super.key});

  @override
  ConsumerState<ParcelHistoryPage> createState() => _ParcelHistoryPageState();
}

class _ParcelHistoryPageState extends ConsumerState<ParcelHistoryPage> {
  late RefreshController historyController;

  @override
  void initState() {
    historyController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parcelProvider.notifier).fetchHistoryOrders(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    historyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parcelProvider);
    return Scaffold(
      backgroundColor: AppStyle.greyColor,
      body: Column(
        children: [
          CustomAppBar(
            bottomPadding: 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.orderHistory),
                  style: AppStyle.interSemi(size: 18.sp),
                ),
                Text(
                  AppHelpers.getTranslation(TrKeys.thereAreOrders),
                  style: AppStyle.interRegular(
                    size: 12.sp,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          state.isHistoryLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Loading(),
                )
              : Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      ref
                          .read(parcelProvider.notifier)
                          .fetchHistoryOrdersPage(
                            context,
                            historyController,
                            isRefresh: true,
                          );
                    },
                    onLoading: () {
                      ref
                          .read(parcelProvider.notifier)
                          .fetchHistoryOrdersPage(context, historyController);
                    },
                    controller: historyController,
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        left: 16.r,
                        right: 16.r,
                        top: 30.h,
                        bottom: MediaQuery.paddingOf(context).bottom + 42.h,
                      ),
                      shrinkWrap: true,
                      itemCount: state.historyOrders.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ParcelItem(
                          isOrder: false,
                          parcel: state.historyOrders[index],
                          isSet: false,
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PopButton(),
            GestureDetector(
              onTap: () {
                AppHelpers.showCustomModalBottomSheet(
                  paddingTop: MediaQuery.paddingOf(context).top,
                  context: context,
                  radius: 12,
                  modal: const FilterScreen(parcel: true),
                  isDarkMode: true,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.primary,
                ),
                padding: EdgeInsets.all(16.r),
                child: Icon(
                  FlutterRemix.equalizer_fill,
                  color: Style.buttonFontColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
