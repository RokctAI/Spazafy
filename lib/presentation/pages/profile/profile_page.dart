import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:remixicon/remixicon.dart';
import 'package:rokctapp/application/home/home_provider.dart';
import 'package:rokctapp/application/language/language_provider.dart';
import 'package:rokctapp/application/notification/notification_provider.dart';
import 'package:rokctapp/application/orders_list/orders_list_provider.dart';
import 'package:rokctapp/application/parcels_list/parcel_list_provider.dart';
import 'package:rokctapp/application/profile/profile_provider.dart';
import 'package:rokctapp/application/shop_order/shop_order_provider.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/app_bars/common_app_bar.dart';
import 'package:rokctapp/presentation/components/badges/alert_dialog.dart';
import 'package:rokctapp/presentation/components/custom_network_image.dart';
import 'package:rokctapp/presentation/components/loading.dart';
import 'package:rokctapp/application/like/like_provider.dart';
import 'package:rokctapp/presentation/pages/profile/delete_screen.dart';
import 'package:rokctapp/presentation/pages/profile/help_page.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/presentation/pages/policy_term/policy_page.dart';
import 'package:rokctapp/presentation/pages/policy_term/term_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rokctapp/presentation/pages/profile/widgets/my_account.dart';

import '../../app_constants.dart';
import '../../components/buttons/second_button.dart';
import '../cards/payment_screen.dart';
import 'widgets/about_page.dart';
import 'widgets/app_usage_badge.dart';
import 'reservation_shops.dart';
import '../loans/loan_screen.dart';
import 'widgets/wallet_topup_screen.dart';
import 'widgets/wallet_send_screen.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  final bool isBackButton;
  final Function()? onCardAdded;
  const ProfilePage({super.key, this.onCardAdded, this.isBackButton = true});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late RefreshController refreshController;
  late Timer time;

  Future<bool> checkApiStatus() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/v1/rest/status'),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    refreshController = RefreshController();
    if (LocalStorage.getToken().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(profileProvider.notifier).fetchUser(context);
        ref.read(ordersListProvider.notifier).fetchActiveOrders(context);
        ref.read(parcelListProvider.notifier).fetchActiveOrders(context);
      });
      time = Timer.periodic(AppConstants.timeRefresh, (timer) {
        if (mounted) {
          ref.read(notificationProvider.notifier).fetchCount(context);
        }
      });
    }

    super.initState();
  }

  getAllInformation() {
    ref.read(homeProvider.notifier)
      ..setAddress()
      ..fetchBanner(context)
      ..fetchAllShops(context)
      ..fetchShopRecommend(context)
      ..fetchShop(context)
      ..fetchStories(context)
      ..fetchNewShops(context)
      ..fetchCategories(context);
    ref.read(shopOrderProvider.notifier).getCart(context, () {});

    ref.read(likeProvider.notifier).fetchLikeShop(context);

    ref.read(profileProvider.notifier).fetchUser(context);
  }

  @override
  void dispose() {
    refreshController.dispose();
    time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(profileProvider);
    final user = LocalStorage.getUser();

    // Check roles
    final bool isDriver = user?.role == 'deliveryman';
    final bool isSeller = user?.role == 'seller';
    final bool isCustomerOnly = !isDriver && !isSeller;

    final bool hasMembership = user?.membership != null;

    ref.listen(languageProvider, (previous, next) {
      if (next.isSuccess && next.isSuccess != previous?.isSuccess) {
        getAllInformation();
      }
    });

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
        body: state.isLoading
            ? const Loading()
            : Column(
                children: [
                  CommonAppBar(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 40.r,
                              width: 40.r,
                              child: CustomNetworkImage(
                                profile: true,
                                url: state.userData?.img ?? "",
                                height: 40.r,
                                width: 40.r,
                                radius: 30.r,
                              ),
                            ),
                            12.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width - 280.w,
                                  child: Text(
                                    state.userData?.firstname != null &&
                                            state.userData!.firstname!.length >
                                                10
                                        ? "${state.userData!.firstname![0]}."
                                        : state.userData?.firstname ?? "",
                                    style: AppStyle.interBold(
                                      size: 16.sp,
                                      color: AppStyle.black,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width - 280.w,
                                  child: Text(
                                    state.userData?.lastname ?? "",
                                    style: AppStyle.interBold(
                                      size: 16.sp,
                                      color: AppStyle.black,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            context.pushRoute(LikeRoute());
                          },
                          icon: Badge(
                            label: Text(
                              (ref.watch(likeProvider).likedShopsCount)
                                  .toString(),
                            ),
                            child: const Icon(
                              Remix.heart_3_line,
                              color: AppStyle.black,
                              size: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.pushRoute(const NotificationListRoute());
                          },
                          icon: Badge(
                            label: Text(
                              (ref
                                          .watch(notificationProvider)
                                          .countOfNotifications
                                          ?.notification ??
                                      0)
                                  .toString(),
                            ),
                            child: const Icon(
                              Remix.notification_line,
                              color: AppStyle.black,
                              size: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyAccount(isBackButton: false),
                              ),
                            );
                          },
                          icon: const Icon(
                            Remix.settings_3_line,
                            color: AppStyle.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            AppHelpers.showAlertDialog(
                              context: context,
                              child: DeleteScreen(
                                onDelete: () => time.cancel(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Remix.logout_circle_r_line,
                            color: AppStyle.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SmartRefresher(
                      onRefresh: () {
                        ref
                            .read(profileProvider.notifier)
                            .fetchUser(
                              context,
                              refreshController: refreshController,
                            );
                        ref
                            .read(ordersListProvider.notifier)
                            .fetchActiveOrders(context);
                      },
                      controller: refreshController,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top: 24.h,
                          right: 16.w,
                          left: 16.w,
                          bottom: 120.h,
                        ),
                        child: Column(
                          children: [
                            if (hasMembership)
                              Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width - 40.w,
                                    decoration: BoxDecoration(
                                      color: AppStyle.primary.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppHelpers.getTranslation(
                                              TrKeys.plan,
                                            ),
                                            style: AppStyle.interBold(
                                              size: 24,
                                              color: AppStyle.black,
                                            ),
                                          ),
                                          5.verticalSpace,
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        const ComingSoonDialog(),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${user?.membership?.title ?? ''} ${AppHelpers.getTranslation(TrKeys.benefits)}',
                                                  style: AppStyle.interNormal(
                                                    size: 16,
                                                    color: AppStyle.black,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_right_sharp,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                AppHelpers.getTranslation(
                                                  TrKeys.expire,
                                                ),
                                                style: AppStyle.interNormal(
                                                  size: 12,
                                                  color: AppStyle.textGrey,
                                                ),
                                              ),
                                              Text(
                                                ' ${(user?.membership?.endDate ?? '').substring(0, 10)}',
                                                style: AppStyle.interNormal(
                                                  size: 12,
                                                  color: AppStyle.textGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  10.verticalSpace,
                                ],
                              ),

                            // Wallet Section
                            Container(
                              width: MediaQuery.sizeOf(context).width - 40.w,
                              decoration: BoxDecoration(
                                color: AppStyle.primary.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () => context.pushRoute(
                                        WalletHistoryRoute(),
                                      ),
                                      child: const Icon(
                                        Remix.arrow_right_up_line,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            const Icon(Remix.wallet_3_line),
                                            16.horizontalSpace,
                                            Text(
                                              "${AppHelpers.getTranslation(TrKeys.wallet)}: ${AppHelpers.numberFormat(number: state.userData?.wallet?.price)}",
                                              style: AppStyle.interNoSemi(
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppStyle.red.withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.r),
                                            bottomRight: Radius.circular(20.r),
                                          ),
                                        ),
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SecondButton(
                                                title:
                                                    AppHelpers.getTranslation(
                                                      TrKeys.topup,
                                                    ),
                                                bgColor: AppStyle.primary,
                                                titleColor: AppStyle.white,
                                                onTap: () =>
                                                    AppHelpers.showCustomModalBottomSheet(
                                                      context: context,
                                                      modal: const ProviderScope(
                                                        child:
                                                            WalletTopUpScreen(),
                                                      ),
                                                      isDarkMode: false,
                                                    ),
                                              ),
                                            ),
                                            12.horizontalSpace,
                                            Expanded(
                                              child: SecondButton(
                                                title:
                                                    AppHelpers.getTranslation(
                                                      TrKeys.send,
                                                    ),
                                                bgColor: AppStyle.primary,
                                                titleColor: AppStyle.white,
                                                onTap: () =>
                                                    AppHelpers.showCustomModalBottomSheet(
                                                      context: context,
                                                      modal: const ProviderScope(
                                                        child:
                                                            WalletSendScreen(),
                                                      ),
                                                      isDarkMode: false,
                                                    ),
                                              ),
                                            ),
                                            if (AppHelpers.getLendingEnabled()) ...[
                                              12.horizontalSpace,
                                              Expanded(
                                                child: SecondButton(
                                                  title:
                                                      AppHelpers.getTranslation(
                                                        TrKeys.loan,
                                                      ),
                                                  bgColor: AppStyle.primary,
                                                  titleColor: AppStyle.white,
                                                  onTap: () =>
                                                      AppHelpers.showCustomModalBottomSheet(
                                                        context: context,
                                                        modal:
                                                            const ProviderScope(
                                                              child:
                                                                  LoanScreen(),
                                                            ),
                                                        isDarkMode: false,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Driver-specific Statistics
                            if (isDriver) ...[
                              15.verticalSpace,
                              Container(
                                width: MediaQuery.sizeOf(context).width - 40.w,
                                decoration: BoxDecoration(
                                  color: AppStyle.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppStyle.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(16.r),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem(
                                      TrKeys.lastProfit,
                                      AppHelpers.numberFormat(
                                        number: user?.wallet?.price ?? 0,
                                      ),
                                      color: AppStyle.primary,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40.h,
                                      color: AppStyle.bgGrey,
                                    ),
                                    _buildStatItem(
                                      TrKeys.deliveredOrder,
                                      "0", // This would ideally come from driver statistics provider
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            15.verticalSpace,

                            // Main Grid of Buttons
                            Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              alignment: WrapAlignment.start,
                              children: [
                                // Standard Buttons
                                _buildSquareButton(
                                  context,
                                  icon: Remix.file_list_3_line,
                                  title: AppHelpers.getTranslation(
                                    TrKeys.order,
                                  ),
                                  onTap: () => context.pushRoute(
                                    const OrdersListRoute(),
                                  ),
                                  badgeText: ref
                                      .watch(ordersListProvider)
                                      .totalActiveCount
                                      .toString(),
                                ),
                                if (AppHelpers.getParcel())
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.instance_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.parcels,
                                    ),
                                    onTap: () => context.pushRoute(
                                      const ParcelListRoute(),
                                    ),
                                    badgeText: ref
                                        .watch(parcelListProvider)
                                        .totalActiveCount
                                        .toString(),
                                  ),

                                _buildSquareButton(
                                  context,
                                  icon: Remix.bank_card_2_line,
                                  title: AppHelpers.getTranslation(
                                    TrKeys.cards,
                                  ),
                                  onTap: () =>
                                      AppHelpers.showCustomModalBottomSheet(
                                        context: context,
                                        modal: PaymentScreen(
                                          tokenizeOnly: true,
                                          onPaymentComplete: (success) {
                                            Navigator.pop(context);
                                            if (success &&
                                                widget.onCardAdded != null)
                                              widget.onCardAdded!();
                                            if (success) {
                                              AppHelpers.showCheckTopSnackBarDone(
                                                context,
                                                AppHelpers.getTranslation(
                                                  TrKeys.cardAddedSuccessfully,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        isDarkMode: isDarkMode,
                                      ),
                                ),

                                _buildSquareButton(
                                  context,
                                  icon: Remix.hand_coin_line,
                                  title: AppHelpers.getTranslation(
                                    TrKeys.inviteFriend,
                                  ),
                                  onTap: () => context.pushRoute(
                                    const ShareReferralRoute(),
                                  ),
                                ),

                                // Role-specific Buttons
                                if (isDriver) ...[
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.navigation_fill,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.deliveryZone,
                                    ),
                                    onTap: () => context.pushRoute(
                                      const DeliveryZoneRoute(),
                                    ),
                                  ),
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.line_chart_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.income,
                                    ),
                                    onTap: () =>
                                        context.pushRoute(const IncomeRoute()),
                                  ),
                                ],

                                if (isSeller) ...[
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.store_2_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.shop,
                                    ),
                                    onTap: () {
                                      // Navigate to shop settings or selection
                                      if (user?.shop != null) {
                                        context.pushRoute(const ShopRoute());
                                      } else {
                                        context.pushRoute(
                                          const BecomeSellerRoute(),
                                        );
                                      }
                                    },
                                    iconColor: AppStyle.primary,
                                  ),
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.bank_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.billing,
                                    ),
                                    onTap: () =>
                                        context.pushRoute(const PosRoute()),
                                  ),
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.vip_diamond_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.subscription,
                                    ),
                                    onTap: () => context.pushRoute(
                                      const SubscriptionsRoute(),
                                    ),
                                  ),
                                ],

                                // Registration Buttons (if not already that role)
                                if (!isDriver)
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.walk_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.signUpToDeliver,
                                    ),
                                    onTap: () => context.pushRoute(
                                      const BecomeDriverRoute(),
                                    ),
                                  ),
                                if (!isSeller)
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.store_fill,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.becomeSeller,
                                    ),
                                    onTap: () => context.pushRoute(
                                      const BecomeSellerRoute(),
                                    ),
                                  ),

                                // More Info Buttons
                                _buildSquareButton(
                                  context,
                                  icon: Remix.lightbulb_flash_fill,
                                  iconColor: AppStyle.starColor,
                                  title: AppHelpers.getTranslation(
                                    TrKeys.about,
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AboutPage(),
                                    ),
                                  ),
                                ),

                                if (AppHelpers.getReservationEnable())
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.reserved_line,
                                    title: AppHelpers.getTranslation(
                                      TrKeys.reservation,
                                    ),
                                    onTap: () => AppHelpers.showAlertDialog(
                                      context: context,
                                      child: const SizedBox(
                                        child: ReservationShops(),
                                      ),
                                    ),
                                  ),

                                // Delete Account
                                _buildSquareButton(
                                  context,
                                  icon: Remix.logout_box_r_line,
                                  title: AppHelpers.getTranslation(
                                    TrKeys.deleteAccount,
                                  ),
                                  onTap: () => AppHelpers.showAlertDialog(
                                    context: context,
                                    child: DeleteScreen(
                                      isDeleteAccount: true,
                                      onDelete: () => time.cancel(),
                                    ),
                                  ),
                                  backgroundColor: Colors.pink[50],
                                  iconColor: Colors.red,
                                  textColor: Colors.pink[700],
                                ),
                              ],
                            ),

                            // App Version and Status Info
                            10.verticalSpace,
                            _buildAppInfoSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: widget.isBackButton
            ? Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: const PopButton(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStatItem(String labelKey, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          AppHelpers.getTranslation(labelKey),
          style: AppStyle.interNormal(size: 12.sp, color: AppStyle.textGrey),
        ),
        Text(
          value,
          style: AppStyle.interSemi(
            size: 16.sp,
            color: color ?? AppStyle.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSquareButton(
    BuildContext context, {
    IconData? icon,
    String? title,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    Color? borderColor,
    String? badgeText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppStyle.white,
          borderRadius: BorderRadius.circular(20.r),
          border: borderColor != null ? Border.all(color: borderColor) : null,
          boxShadow: [
            if (backgroundColor != Colors.transparent)
              BoxShadow(
                color: AppStyle.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Badge(
                isLabelVisible: badgeText != null && badgeText != "0",
                label: Text(badgeText ?? ''),
                child: Icon(
                  icon,
                  size: 30.r,
                  color: iconColor ?? AppStyle.black,
                ),
              ),
            if (icon != null && title != null) 8.verticalSpace,
            if (title != null)
              Text(
                title,
                style: AppStyle.interNormal(
                  size: 12.sp,
                  color: textColor ?? AppStyle.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                ),
                child: Text(
                  AppHelpers.getTranslation(TrKeys.help),
                  style: const TextStyle(
                    color: AppStyle.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Icon(Icons.circle_rounded, color: AppStyle.black, size: 7),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermPage()),
                ),
                child: Text(
                  AppHelpers.getTranslation(TrKeys.terms),
                  style: const TextStyle(
                    color: AppStyle.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Icon(Icons.circle_rounded, color: AppStyle.black, size: 7),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PolicyPage()),
                ),
                child: Text(
                  AppHelpers.getTranslation(TrKeys.privacyPolicy),
                  style: const TextStyle(
                    color: AppStyle.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<bool>(
            future: checkApiStatus(),
            builder: (context, snapshot) {
              final bool isOnline = snapshot.data ?? false;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppHelpers.getAppName() ?? "",
                    style: AppStyle.interBold(color: AppStyle.primary),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Remix.checkbox_blank_circle_fill,
                    size: 8,
                    color: AppStyle.black,
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, packageSnapshot) {
                      if (packageSnapshot.hasData) {
                        return Text(
                          " Version ${packageSnapshot.data!.version}",
                          style: AppStyle.interNormal(color: AppStyle.black),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Remix.checkbox_blank_circle_fill,
                    size: 12,
                    color: isOnline ? Colors.green : Colors.red,
                  ),
                  Text(
                    isOnline ? ' Online' : ' Offline',
                    style: TextStyle(
                      color: isOnline ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  const AppUsageBadge(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
