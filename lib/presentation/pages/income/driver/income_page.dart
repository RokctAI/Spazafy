import 'package:rokctapp/application/restaurant/manager/income/statistics/statistics_state.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/presentation/components/buttons/pop_button.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:auto_route/auto_route.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/statistics/driver/statistics_provider.dart';
import 'package:rokctapp/application/statistics/driver/statistics_state.dart'
    hide StatisticsState;
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart'
    hide AppHelpers;
import 'package:rokctapp/presentation/components/exports/components_driver.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/pages/income/driver/app_bar_screen.dart';
import 'package:rokctapp/presentation/pages/income/driver/statistics_screen.dart';
import 'package:rokctapp/presentation/pages/income/driver/widgets/income_item.dart';

@RoutePage()
class DriverIncomePage extends ConsumerStatefulWidget {
  const DriverIncomePage({super.key});

  @override
  ConsumerState<DriverIncomePage> createState() => _DriverIncomePageState();
}

class _DriverIncomePageState extends ConsumerState<DriverIncomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    Tab(child: Text(help.AppHelpers.getTranslation(TrKeys.today))),
    Tab(child: Text(help.AppHelpers.getTranslation(TrKeys.weekly))),
    Tab(child: Text(help.AppHelpers.getTranslation(TrKeys.monthly))),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        ref
            .read(statisticsProvider.notifier)
            .fetchStatistics(
              startTime: DateTime.now(),
              endTime: DateTime.now(),
            );
      } else if (_tabController.index == 1) {
        ref
            .read(statisticsProvider.notifier)
            .fetchStatistics(
              startTime: DateTime.now(),
              endTime: DateTime.now().subtract(const Duration(days: 7)),
            );
      } else {
        ref
            .read(statisticsProvider.notifier)
            .fetchStatistics(
              startTime: DateTime.now(),
              endTime: DateTime.now().subtract(const Duration(days: 30)),
            );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(statisticsProvider.notifier)
          .fetchStatistics(startTime: DateTime.now(), endTime: DateTime.now());
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statisticsProvider);
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          const AbbBarScreen(),
          16.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                right: 16.w,
                left: 16.w,
                bottom: MediaQuery.paddingOf(context).bottom + 56.h,
              ),
              child: Column(
                children: [
                  CustomTabBar(tabController: _tabController, tabs: _tabs),
                  24.verticalSpace,
                  _orderPrices(context, state),
                  // TitleAndIcon(
                  //   title: help.AppHelpers.getTranslation(TrKeys.remittanceIncome),
                  // ),
                  // 12.verticalSpace,
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.servicePrice),
                  //   price: "\$0",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.tax),
                  //   price: "\$2",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.shippingCost),
                  //   price: "\$500",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.adminBenefit),
                  //   price: "\$5.8",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.yourBenefit),
                  //   price: "\$560",
                  // ),
                  // 24.verticalSpace,
                  TitleAndIcon(
                    title: help.AppHelpers.getTranslation(
                      TrKeys.deliverymanTransactions,
                    ),
                  ),
                  12.verticalSpace,
                  IncomeItem(
                    title: help.AppHelpers.getTranslation(TrKeys.wallet),
                    price: help.AppHelpers.numberFormat(
                      number: LocalStorage.getUser()?.wallet?.price ?? 0,
                    ),
                  ),
                  IncomeItem(
                    title: help.AppHelpers.getTranslation(TrKeys.rating),
                    price:
                        "${LocalStorage.getUser()?.rate?.toStringAsFixed(1) ?? 0}",
                  ),
                  24.verticalSpace,
                  // TitleAndIcon(
                  //   title: help.AppHelpers.getTranslation(TrKeys.payment),
                  // ),
                  // 12.verticalSpace,
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.grossProfit),
                  //   price: "\$580",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.earningsWallet),
                  //   price: "\$100",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.paid),
                  //   price: "\$0",
                  // ),
                  // IncomeItem(
                  //   title: help.AppHelpers.getTranslation(TrKeys.paidCourier),
                  //   price: "\$560",
                  //   isBlack: true,
                  // ),
                  // 24.verticalSpace,
                  StatisticsScreen(
                    totalOrders: (state.countData?.data?.totalCount ?? 0)
                        .toString(),
                    todayOrders: (state.countData?.data?.totalTodayCount ?? 0)
                        .toString(),
                    acceptedOrders:
                        (state.countData?.data?.totalAcceptedCount ?? 0)
                            .toString(),
                    rejectedOrders:
                        (state.countData?.data?.totalCanceledCount ?? 0)
                            .toString(),
                    doneOrders:
                        (state.countData?.data?.totalDeliveredCount ?? 0)
                            .toString(),
                    canceledOrders: (state.countData?.data?.totalNewCount ?? 0)
                        .toString(),
                    acceptedPer:
                        "${((state.countData?.data?.totalAcceptedCount ?? 0) / (state.countData?.data?.totalCount ?? 1) * 100).toStringAsFixed(1)}%",
                    rejectedPer:
                        "${((state.countData?.data?.totalCanceledCount ?? 0) / (state.countData?.data?.totalCount ?? 1) * 100).toStringAsFixed(1)}%",
                    donePer:
                        "${((state.countData?.data?.totalDeliveredCount ?? 0) / (state.countData?.data?.totalCount ?? 1) * 100).toStringAsFixed(1)}%",
                    canceledPer:
                        "${((state.countData?.data?.totalNewCount ?? 0) / (state.countData?.data?.totalCount ?? 1) * 100).toStringAsFixed(1)}%",
                  ),
                  32.verticalSpace,
                  _chart(state),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const PopButton(),
    );
  }

  Column _chart(StatisticsState state) {
    return Column(
      children: [
        TitleAndIcon(
          title: help.AppHelpers.getTranslation(TrKeys.earningsChart),
        ),
        16.verticalSpace,
        Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: BarChart(
            state.list,
            animate: true,
            vertical: false,
            animationDuration: const Duration(seconds: 1),
            defaultRenderer: BarRendererConfig(
              cornerStrategy: const ConstCornerStrategy(6),
            ),
          ),
        ),
        32.verticalSpace,
      ],
    );
  }

  Column _orderPrices(BuildContext context, StatisticsState state) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                help.AppHelpers.getTranslation(TrKeys.orderPrice),
                style: AppStyle.interNormal(
                  size: 14.sp,
                  color: AppStyle.black,
                  letterSpacing: -0.3,
                ),
              ),
              16.verticalSpace,
              Text(
                help.AppHelpers.numberFormat(
                  number: state.countData?.data?.lastOrderTotalPrice ?? 0,
                ),
                style: AppStyle.interSemi(
                  size: 32.sp,
                  color: AppStyle.black,
                  letterSpacing: -0.3,
                ),
              ),
              4.verticalSpace,
              RichText(
                text: TextSpan(
                  text: help.AppHelpers.getTranslation(TrKeys.lastIncome),
                  style: AppStyle.interNormal(
                    size: 12.sp,
                    color: AppStyle.black,
                    letterSpacing: -0.3,
                  ),
                  children: [
                    TextSpan(
                      text: help.AppHelpers.numberFormat(
                        number: state.countData?.data?.lastOrderIncome ?? 0,
                      ),
                      style: AppStyle.interSemi(
                        size: 12.sp,
                        color: AppStyle.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 10.verticalSpace,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //       width: (MediaQuery.sizeOf(context).width - 40) / 2,
        //       decoration: BoxDecoration(
        //         color: Style.blackColor,
        //         borderRadius: BorderRadius.circular(10.r),
        //       ),
        //       padding: EdgeInsets.all(16.r),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             AppHelpers.getTranslation(TrKeys.restaurantRevenue),
        //             style: Style.interNormal(
        //                 size: 12.sp, color: Style.white, letterSpacing: -0.3),
        //           ),
        //           Text(
        //             "\$79",
        //             style: Style.interSemi(
        //                 size: 22.sp, color: Style.white, letterSpacing: -0.3),
        //           )
        //         ],
        //       ),
        //     ),
        //     Container(
        //       width: (MediaQuery.sizeOf(context).width - 40) / 2,
        //       decoration: BoxDecoration(
        //         color: Style.blackColor,
        //         borderRadius: BorderRadius.circular(10.r),
        //       ),
        //       padding: EdgeInsets.all(16.r),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             AppHelpers.getTranslation(TrKeys.fMRevenue),
        //             style: Style.interNormal(
        //                 size: 12.sp, color: Style.white, letterSpacing: -0.3),
        //           ),
        //           Text(
        //             "\$7",
        //             style: Style.interSemi(
        //                 size: 22.sp, color: Style.white, letterSpacing: -0.3),
        //           )
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        32.verticalSpace,
      ],
    );
  }
}
