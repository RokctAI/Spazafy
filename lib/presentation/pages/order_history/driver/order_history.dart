import 'package:auto_route/annotations.dart';
import 'package:rokctapp/application/order/driver/canceled_order/canceled_order_provider.dart';
import 'package:rokctapp/application/order/driver/delivered_order/delivery_order_provider.dart';
import 'package:rokctapp/presentation/pages/order_history/driver/widgets/all_orders.dart';
import 'package:rokctapp/presentation/pages/order_history/driver/widgets/canceled_body.dart';
import 'package:rokctapp/presentation/pages/order_history/driver/widgets/derliverd_body.dart';
import 'package:rokctapp/presentation/pages/order_history/driver/widgets/progress_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/order/driver/all_order/order_provider.dart';

import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';
import 'package:rokctapp/presentation/components/driver/loading.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

import 'package:rokctapp/application/order/driver/progress_ordedr/progress_order_provider.dart';

@RoutePage()
class DriverOrderHistoryPage extends ConsumerStatefulWidget {
  const DriverOrderHistoryPage({super.key});

  @override
  ConsumerState<DriverOrderHistoryPage> createState() =>
      _DriverOrderHistoryPageState();
}

class _DriverOrderHistoryPageState extends ConsumerState<DriverOrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late RefreshController historyController;
  late RefreshController deliveredController;
  late RefreshController canceledController;
  late RefreshController progressController;
  late TabController _tabController;

  final tabs = [
    Tab(child: Text(AppHelpers.getTranslation(TrKeys.allOrders))),
    Tab(child: Text(AppHelpers.getTranslation(TrKeys.progressOrder))),
    Tab(child: Text(AppHelpers.getTranslation(TrKeys.deliveredOrder))),
    Tab(child: Text(AppHelpers.getTranslation(TrKeys.canceledOrder))),
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    historyController = RefreshController();
    deliveredController = RefreshController();
    canceledController = RefreshController();
    progressController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(orderProvider.notifier)
          .fetchHistoryOrdersPage(context, historyController, isRefresh: true);
      ref
          .read(deliveredOrderProvider.notifier)
          .fetchDeliveredOrdersPage(
            context,
            deliveredController,
            isRefresh: true,
          );
      ref
          .read(canceledOrderProvider.notifier)
          .fetchCanceledOrdersPage(
            context,
            canceledController,
            isRefresh: true,
          );
      ref
          .read(progressOrderProvider.notifier)
          .fetchProgressOrdersPage(
            context,
            progressController,
            isRefresh: true,
          );
    });
    super.initState();
  }

  @override
  void dispose() {
    historyController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CustomAppBar(
            bottomPadding: 16.h,
            height: 110,
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
                  style: AppStyle.interRegular(size: 12.sp, letterSpacing: -0.3),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CustomTabBar(
              tabController: _tabController,
              tabs: tabs,
              scroll: true,
            ),
          ),
          if (state.isHistoryLoading)
            const Padding(padding: EdgeInsets.only(top: 32), child: Loading())
          else
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  AllOrdersBody(refreshController: historyController),
                  ProgressOrdersBody(refreshController: progressController),
                  DeliveredOrdersBody(refreshController: deliveredController),
                  CanceledOrdersBody(refreshController: canceledController),
                ],
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
                  modal: const FilterScreen(),
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
