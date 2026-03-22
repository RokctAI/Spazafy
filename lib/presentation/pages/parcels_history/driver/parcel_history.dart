import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart' as help;
import 'package:rokctapp/presentation/components/buttons/pop_button.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/driver/filter_screen.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/parcel/driver/parcel_provider.dart';
import 'package:rokctapp/presentation/pages/parcel/driver/parcel_item.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';
import 'package:rokctapp/presentation/components/driver/loading.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

@RoutePage()
class DriverParcelHistoryPage extends ConsumerStatefulWidget {
  const DriverParcelHistoryPage({super.key});

  @override
  ConsumerState<DriverParcelHistoryPage> createState() =>
      _DriverParcelHistoryPageState();
}

class _DriverParcelHistoryPageState
    extends ConsumerState<DriverParcelHistoryPage> {
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
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CustomAppBar(
            bottomPadding: 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  help.AppHelpers.getTranslation(TrKeys.orderHistory),
                  style: AppStyle.interSemi(size: 18.sp),
                ),
                Text(
                  help.AppHelpers.getTranslation(TrKeys.thereAreOrders),
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
                help.AppHelpers.showCustomModalBottomSheet(
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
                  color: AppStyle.buttonFontColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
