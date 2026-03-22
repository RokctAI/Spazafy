import 'package:rokctapp/dummy_types.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/application/parcel/driver/parcel_notifier.dart';
import 'package:rokctapp/application/parcel/driver/parcel_provider.dart';
import 'package:rokctapp/presentation/components/driver/loading.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'parcel_item.dart';


@RoutePage()
class DriverParcelsPage extends ConsumerStatefulWidget {
  const DriverParcelsPage({super.key});

  @override
  ConsumerState<DriverParcelsPage> createState() => _DriverParcelsPageState();
}

class _DriverParcelsPageState extends ConsumerState<DriverParcelsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RefreshController activeController;
  late RefreshController availableController;
  late ParcelNotifier event;

  final _tabs = [
    Tab(child: Text(AppHelpers.getTranslation(TrKeys.activeParcels))),
    Tab(child: Text(AppHelpers.getTranslation(TrKeys.availableParcels))),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    activeController = RefreshController();
    availableController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parcelProvider.notifier)
        ..fetchActiveOrders(context)
        ..fetchAvailableOrders(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(parcelProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    activeController.dispose();
    availableController.dispose();
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
                  AppHelpers.getTranslation(TrKeys.orders),
                  style: AppStyle.interSemi(size: 18.sp),
                ),
                Row(
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.thereAreOrders),
                      style: AppStyle.interRegular(
                        size: 12.sp,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      " ${state.totalActiveOrder} ",
                      style: AppStyle.interRegular(
                        size: 12.sp,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      AppHelpers.getTranslation(TrKeys.orders).toLowerCase(),
                      style: AppStyle.interRegular(
                        size: 12.sp,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          16.verticalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  CustomTabBar(tabController: _tabController, tabs: _tabs),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        state.isActiveLoading
                            ? const Loading()
                            : SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                onRefresh: () {
                                  event.fetchActiveOrdersPage(
                                    context,
                                    activeController,
                                    isRefresh: true,
                                  );
                                },
                                onLoading: () {
                                  event.fetchActiveOrdersPage(
                                    context,
                                    activeController,
                                  );
                                },
                                controller: activeController,
                                child: state.activeOrders.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(
                                          top: 30.h,
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).padding.bottom +
                                              42.h,
                                        ),
                                        shrinkWrap: true,
                                        itemCount: state.activeOrders.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return ParcelItem(
                                            parcel: state.activeOrders[index],
                                            isOrder: true,
                                            isSet: false,
                                          );
                                        },
                                      )
                                    : _resultEmpty(),
                              ),
                        state.isAvailableLoading
                            ? const Loading()
                            : SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                onRefresh: () {
                                  event.fetchAvailableOrdersPage(
                                    context,
                                    availableController,
                                    isRefresh: true,
                                  );
                                },
                                onLoading: () {
                                  event.fetchAvailableOrdersPage(
                                    context,
                                    availableController,
                                  );
                                },
                                controller: availableController,
                                child: state.availableOrders.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(
                                          top: 30.h,
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).padding.bottom +
                                              42.h,
                                        ),
                                        shrinkWrap: true,
                                        itemCount: state.availableOrders.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return ParcelItem(
                                            parcel:
                                                state.availableOrders[index],
                                            isOrder: true,
                                            isSet: true,
                                          );
                                        },
                                      )
                                    : _resultEmpty(),
                              ),
                      ],
                    ),
                  ),
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
}

Widget _resultEmpty() {
  return Column(
    children: [
      16.verticalSpace,
      Lottie.asset("assets/lottie/empty-box.json"),
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
