// Copyright (c) 2024 RokctAI
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:remixicon/remixicon.dart';

import 'package:rokctapp/application/main/main_notifier.dart';
import 'package:rokctapp/application/main/main_provider.dart';
import 'package:rokctapp/application/profile/profile_provider.dart';
import 'package:rokctapp/application/shops/shop_order/shop_order_provider.dart';
import 'package:rokctapp/application/home/home_provider.dart';
import 'package:rokctapp/application/providers/providers.dart';

import 'package:rokctapp/infrastructure/models/data/cart_data.dart';
import 'package:rokctapp/infrastructure/models/data/profile_data.dart';
import 'package:rokctapp/infrastructure/models/data/remote_message_data.dart';
import 'package:rokctapp/infrastructure/models/data/shop_data.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as manager_services;

import 'package:rokctapp/presentation/components/buttons/animation_button_effect.dart';
import 'package:rokctapp/presentation/components/custom_network_image.dart';
import 'package:rokctapp/presentation/components/keyboard_dismisser.dart';
import 'package:rokctapp/presentation/components/blur_wrap.dart';
import 'package:rokctapp/presentation/theme/theme.dart';

import 'package:rokctapp/presentation/pages/home/home_zero/home_page_zero.dart';
import 'package:rokctapp/presentation/pages/home/home_four/home_page_four.dart';
import 'package:rokctapp/presentation/pages/home/pos_page.dart';
import 'package:rokctapp/presentation/pages/main/orders/orders_home_page.dart';
import 'package:rokctapp/presentation/pages/main/foods/foods_page.dart';
import 'package:rokctapp/presentation/pages/like/like_page.dart';
import 'package:rokctapp/presentation/pages/search/search_page.dart';
import 'package:rokctapp/presentation/pages/parcel/parcel_page.dart';
import 'package:rokctapp/presentation/pages/profile/wallet_history.dart';
import 'package:rokctapp/presentation/pages/profile/profile_page.dart';
import 'package:rokctapp/presentation/pages/main/foods/create/create_product_modal.dart';
import 'package:rokctapp/presentation/pages/main/foods/addons/create/create_addon_modal.dart';
import 'package:rokctapp/presentation/pages/main/foods/extras/create/create_extras_group_modal.dart';

import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/presentation/routes/app_router.dart' as manager_routes;
import 'package:rokctapp/utils/app_usage_service.dart';
import 'package:rokctapp/infrastructure/services/utils/app_constants.dart';
import 'widgets/bottom_navigator_item.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final player = AudioPlayer();
  Timer? audioTimer;
  int audioCallCount = 0;
  bool isCustomerMode = false;

  List<IndexedStackChild> sellerPages = [
    IndexedStackChild(child: const PosPage(), preload: true),
    IndexedStackChild(child: const OrdersHomePage(), preload: false),
    IndexedStackChild(child: const FoodsPage(), preload: false),
    IndexedStackChild(
      child: const ProfilePage(isBackButton: false),
      preload: true,
    ),
  ];

  List listPages = [
    [
      IndexedStackChild(child: const HomePageZero(), preload: true),
      (AppHelpers.getParcel())
          ? IndexedStackChild(
              child: const ParcelPage(isBackButton: false),
              preload: true,
            )
          : IndexedStackChild(child: const SearchPage(isBackButton: false)),
      LocalStorage.getToken().isNotEmpty
          ? IndexedStackChild(
              child: const WalletHistoryPage(isBackButton: false),
            )
          : IndexedStackChild(child: const LikePage(isBackButton: false)),
      IndexedStackChild(
        child: const ProfilePage(isBackButton: false),
        preload: true,
      ),
    ],
    [],
    [],
    [],
    [
      IndexedStackChild(child: const HomePageFour(), preload: true),
      (AppHelpers.getParcel())
          ? IndexedStackChild(
              child: const ParcelPage(isBackButton: false),
              preload: true,
            )
          : IndexedStackChild(child: const SearchPage(isBackButton: false)),
      LocalStorage.getToken().isNotEmpty
          ? IndexedStackChild(
              child: const WalletHistoryPage(isBackButton: false),
            )
          : IndexedStackChild(child: const LikePage(isBackButton: false)),
      IndexedStackChild(
        child: const ProfilePage(isBackButton: false),
        preload: true,
      ),
    ],
  ];

  Future playMusic() async {
    audioTimer?.cancel();
    audioTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await player.play(AssetSource("audio/notification.wav"));
    });
  }

  @override
  void initState() {
    final user = LocalStorage.getUser();
    final bool isSeller = user?.role == 'seller';

    if (!isSeller || isCustomerMode) {
      initDynamicLinks();
    }

    // Record app usage if user is logged in
    if (LocalStorage.getToken().isNotEmpty) {
      debugPrint('MainPage: Recording app usage for logged in user');
      AppUsageService.recordAppUsage();
    } else {
      debugPrint('MainPage: User not logged in, skipping app usage tracking');
    }

    FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
      badge: false,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteMessageData data = RemoteMessageData.fromJson(message.data);
      if (data.type == "news_publish") {
        if (!mounted) return;
        context.router.popUntilRoot();
        await launch(
          "${AppConstants.webUrl}/blog/${message.data["uuid"]}",
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        if (!mounted) return;
        context.router.popUntilRoot();
        context.pushRoute(OrderProgressRoute(orderId: data.id?.toString()));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteMessageData data = RemoteMessageData.fromJson(message.data);

      if (isSeller) {
        if (data.type == "new_order" ||
            AppConstants.playMusicOnOrderStatusChange) {
          player.play(AssetSource("audio/notification.wav"));
        }
        if (mounted) {
          AppHelpers.showCheckTopSnackBar(
            context,
            type: SnackBarType.success,
            text:
                "${AppHelpers.getTranslation(TrKeys.id)} #${message.notification?.title} ${message.notification?.body}",
          );
        }
        return;
      }

      if (data.type == "news_publish") {
        if (!mounted) return;
        AppHelpers.showCheckTopSnackBarInfoCustom(
          context,
          "${message.notification?.body}",
          onTap: () async {
            if (!context.mounted) return;
            context.router.popUntilRoot();
            await launch(
              "${AppConstants.webUrl}/blog/${message.data["uuid"]}",
              forceSafariVC: true,
              forceWebView: true,
              enableJavaScript: true,
            );
          },
        );
      } else {
        if (!mounted) return;
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          "${AppHelpers.getTranslation(TrKeys.id)} #${message.notification?.title} ${message.notification?.body}",
          onTap: () async {
            if (!mounted) return;
            context.router.popUntilRoot();
            if (!mounted) return;
            context.pushRoute(OrderProgressRoute(orderId: data.id?.toString()));
          },
        );
      }
    });
    super.initState();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink
        .listen((dynamicLinkData) {
          Uri link = dynamicLinkData.link;
          if (link.queryParameters.keys.contains('group')) {
            if (!mounted) return;
            context.router.popUntilRoot();
            if (!mounted) return;
            context.pushRoute(
              ShopRoute(
                shopId: link.pathSegments.last,
                cartId: link.queryParameters['group'],
                ownerId: link.queryParameters['owner_id'] ?? '',
              ),
            );
          } else if (!link.queryParameters.keys.contains("product") &&
              link.pathSegments.contains("shop")) {
            if (!mounted) return;
            context.router.popUntilRoot();
            context.pushRoute(ShopRoute(shopId: link.pathSegments.last));
          } else if (link.pathSegments.contains("shop")) {
            if (!mounted) return;
            context.router.popUntilRoot();
            if (!mounted) return;
            context.pushRoute(
              ShopRoute(
                shopId: link.pathSegments.last,
                productId: link.queryParameters['product'],
              ),
            );
          }
        })
        .onError((error) {
          debugPrint(error.message);
        });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance
        .getInitialLink();
    if (!mounted) return;
    final Uri? deepLink = data?.link;
    if (deepLink?.queryParameters.keys.contains("group") ?? false) {
      if (!context.mounted) return;
      context.router.popUntilRoot();
      if (!mounted) return;
      context.pushRoute(
        ShopRoute(
          shopId: deepLink?.pathSegments.last ?? '',
          cartId: deepLink?.queryParameters['group'],
          ownerId: deepLink?.queryParameters['owner_id'] ?? "",
        ),
      );
    } else if (!(deepLink?.queryParameters.keys.contains("product") ?? false) &&
        (deepLink?.pathSegments.contains("shop") ?? false)) {
      if (!context.mounted) return;
      context.pushRoute(ShopRoute(shopId: deepLink?.pathSegments.last ?? ""));
    } else if (deepLink?.pathSegments.contains("shop") ?? false) {
      context.pushRoute(
        ShopRoute(
          shopId: deepLink?.pathSegments.last ?? "",
          productId: deepLink?.queryParameters['product'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage.getUser();
    final bool isSeller = user?.role == 'seller';

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final index = ref.watch(mainProvider).selectIndex;

            if (isSeller && !isCustomerMode) {
              if (AppConstants.keepPlayingOnNewOrder) {
                ref.listen(newOrdersProvider, (previous, next) async {
                  if (next.orders.isEmpty) {
                    await player.stop();
                    audioTimer?.cancel();
                  }
                  if (audioCallCount != 0 && next.orders.isNotEmpty) {
                    await playMusic();
                  }
                  audioCallCount++;
                });
              }
              return ProsteIndexedStack(index: index, children: sellerPages);
            }

            return ProsteIndexedStack(
              index: index,
              children: listPages[AppHelpers.getType()],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Consumer(
          builder: (context, ref, child) {
            final index = ref.watch(mainProvider).selectIndex;
            final userData = ref.watch(profileProvider).userData;
            final event = ref.read(mainProvider.notifier);
            return _bottom(index, ref, event, context, userData);
          },
        ),
        bottomNavigationBar: const SizedBox(),
      ),
    );
  }

  Widget _bottom(
    int index,
    WidgetRef ref,
    MainNotifier event,
    BuildContext context,
    ProfileData? user,
  ) {
    final curUser = LocalStorage.getUser();
    final bool isSeller = curUser?.role == 'seller';
    final orders = ref.watch(shopOrderProvider).cart;
    final bool isCartEmpty =
        orders == null ||
        (orders.userCarts?.isEmpty ?? true) ||
        ((orders.userCarts?.isEmpty ?? true)
            ? true
            : (orders.userCarts?.first.cartDetails?.isEmpty ?? true)) ||
        orders.ownerId != LocalStorage.getUser()?.id;

    // Check if fixed navigation is enabled
    final bool isFixed = AppConstants.fixed;

    // If fixed is true, always pass false for isScrolling
    final bool isScrollingValue = isFixed
        ? false
        : ref.watch(mainProvider).isScrolling;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cart info bar - only show when fixed is true and cart has items
        if (isFixed && !isCartEmpty && (!isSeller || isCustomerMode))
          GestureDetector(
            onTap: () {
              if (LocalStorage.getToken().isEmpty) {
                context.pushRoute(LoginRoute());
                return;
              }
              context.pushRoute(OrderRoute());
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Main container
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(
                    bottom: 16.h,
                  ), // Extra margin for the tooltip pointer
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      // In the cart info bar
                      Expanded(
                        child: Text(
                          '${AppHelpers.getTranslation(TrKeys.shopping)} ${AppHelpers.getType() == 0 || AppHelpers.getType() == 4 ? _getCartShopName(orders, ref) : ""}',
                          style: AppStyle.interRegular(
                            size: 14,
                            color: AppStyle.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          // Check if currency is loaded
                          final isLoading = ref
                              .watch(shopOrderProvider)
                              .isLoading;
                          final totalPrice = ref
                              .watch(shopOrderProvider)
                              .cart
                              ?.totalPrice;
                          final currency = LocalStorage.getSelectedCurrency();

                          if (isLoading) {
                            return CupertinoActivityIndicator(
                              color: AppStyle.white,
                              radius: 10.r,
                            );
                          } else {
                            // Currency is loaded, format properly
                            return Text(
                              AppHelpers.numberFormat(number: totalPrice),
                              style: AppStyle.interSemi(
                                size: 16,
                                color: AppStyle.white,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Tooltip pointer (triangle)
                Positioned(
                  bottom: 6.h,
                  right: 20.w, // Position near the cart icon
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      width: 16.h,
                      height: 10.h,
                      color: AppStyle.primary.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Main bottom navigation row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlurWrap(
              radius: BorderRadius.circular(100.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: AppStyle.bottomNavigationBarColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(100.r)),
                ),
                height: 60.r,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BottomNavigatorItem(
                        isScrolling: index == 3 ? false : isScrollingValue,
                        selectItem: () {
                          event.changeScrolling(false);
                          event.selectIndex(0);
                        },
                        index: 0,
                        currentIndex: index,
                        selectIcon: (isSeller && !isCustomerMode)
                            ? FlutterRemix.money_dollar_circle_fill
                            : FlutterRemix.store_fill,
                        unSelectIcon: (isSeller && !isCustomerMode)
                            ? FlutterRemix.money_dollar_circle_line
                            : FlutterRemix.store_line,
                        label: (isSeller && !isCustomerMode)
                            ? AppHelpers.getTranslation(TrKeys.sell)
                            : AppHelpers.getTranslation(TrKeys.stores),
                      ),
                      BottomNavigatorItem(
                        isScrolling: index == 3 ? false : isScrollingValue,
                        selectItem: () {
                          event.changeScrolling(false);
                          event.selectIndex(1);
                        },
                        currentIndex: index,
                        index: 1,
                        label: (isSeller && !isCustomerMode)
                            ? AppHelpers.getTranslation(TrKeys.orders)
                            : (AppHelpers.getParcel())
                            ? AppHelpers.getTranslation(TrKeys.send)
                            : AppHelpers.getTranslation(TrKeys.search),
                        selectIcon: (isSeller && !isCustomerMode)
                            ? FlutterRemix.file_list_2_fill
                            : (AppHelpers.getParcel())
                            ? Remix.instance_fill
                            : FlutterRemix.search_fill,
                        unSelectIcon: (isSeller && !isCustomerMode)
                            ? FlutterRemix.file_list_2_line
                            : (AppHelpers.getParcel())
                            ? Remix.instance_line
                            : FlutterRemix.search_line,
                      ),
                      BottomNavigatorItem(
                        isScrolling: index == 3 ? false : isScrollingValue,
                        selectItem: () {
                          event.changeScrolling(false);
                          event.selectIndex(2);
                        },
                        currentIndex: index,
                        index: 2,
                        label: (isSeller && !isCustomerMode)
                            ? AppHelpers.getTranslation(TrKeys.foods)
                            : LocalStorage.getToken().isNotEmpty
                            ? AppHelpers.getTranslation(TrKeys.wallet)
                            : AppHelpers.getTranslation(TrKeys.liked),
                        selectIcon: (isSeller && !isCustomerMode)
                            ? FlutterRemix.restaurant_fill
                            : LocalStorage.getToken().isNotEmpty
                            ? FlutterRemix.wallet_2_fill
                            : FlutterRemix.heart_fill,
                        unSelectIcon: (isSeller && !isCustomerMode)
                            ? FlutterRemix.restaurant_line
                            : LocalStorage.getToken().isNotEmpty
                            ? FlutterRemix.wallet_2_line
                            : FlutterRemix.heart_line,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (event.checkGuest()) {
                            event.selectIndex(0);
                            event.changeScrolling(false);
                            context.replaceRoute(LoginRoute());
                          } else {
                            event.changeScrolling(false);
                            event.selectIndex(3);
                          }
                        },
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: index == 3
                                  ? AppStyle.primary
                                  : AppStyle.transparent,
                              width: 2.w,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: (isSeller && !isCustomerMode)
                              ? CustomNetworkImage(
                                  profile: true,
                                  url: LocalStorage.getShop()?.logoImg,
                                  height: 40.r,
                                  width: 40.r,
                                  radius: 20.r,
                                )
                              : CustomNetworkImage(
                                  profile: true,
                                  url: user?.img ?? LocalStorage.getUser()?.img,
                                  height: 40.r,
                                  width: 40.r,
                                  radius: 20.r,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Left Floating Add Button (Manager mode only)
            if (isSeller && !isCustomerMode && (index == 1 || index == 2))
              ButtonsBouncingEffect(
                child: Hero(
                  tag: AppConstants.heroTagAddOrderButton,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final foodTabState = ref.watch(foodTabsProvider);
                      return GestureDetector(
                        onTap: () {
                          index == 1
                              ? context.pushRoute(const CreateOrderRoute())
                              : (foodTabState.selectedIndex == 0
                                    ? AppHelpers.showCustomModalBottomSheet(
                                        paddingTop:
                                            MediaQuery.paddingOf(context).top +
                                            64.h,
                                        context: context,
                                        modal: const CreateProductModal(),
                                        isDarkMode: false,
                                      )
                                    : (foodTabState.selectedIndex == 1
                                          ? AppHelpers.showCustomModalBottomSheet(
                                              paddingTop:
                                                  MediaQuery.paddingOf(
                                                    context,
                                                  ).top +
                                                  64.h,
                                              context: context,
                                              modal: const CreateAddonModal(),
                                              isDarkMode: false,
                                            )
                                          : AppHelpers.showCustomModalBottomSheet(
                                              paddingTop:
                                                  MediaQuery.paddingOf(
                                                    context,
                                                  ).top +
                                                  64.h,
                                              context: context,
                                              modal:
                                                  const CreateExtrasGroupModal(),
                                              isDarkMode: false,
                                            )));
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.only(start: 8.r),
                          width: 56.r,
                          height: 56.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyle.primary,
                          ),
                          child: const Icon(
                            FlutterRemix.add_line,
                            color: AppStyle.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Right Floating Button (Mode Toggle / Cart)
            if (!isSeller)
              // Standard Customer Cart
              if (!isCartEmpty)
                _cartButton(context, ref, isCartEmpty)
              else
                const SizedBox.shrink()
            else
              // Seller Adaptive Toggle
              AnimationButtonEffect(
                child: GestureDetector(
                  onTap: () {
                    if (isCustomerMode && !isCartEmpty) {
                      context.pushRoute(OrderRoute());
                    } else {
                      setState(() {
                        isCustomerMode = !isCustomerMode;
                        event.selectIndex(0);
                        event.changeScrolling(false);
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 8.w),
                    width: 56.r,
                    height: 56.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(0, 0, 0, 0.8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          (isCustomerMode && !isCartEmpty)
                              ? FlutterRemix.shopping_basket_2_fill
                              : (isCustomerMode
                                    ? FlutterRemix.arrow_left_line
                                    : FlutterRemix.shopping_bag_3_fill),
                          color: AppStyle.white,
                        ),
                        if (isCustomerMode && !isCartEmpty)
                          Positioned(
                            top: 9,
                            right: 8,
                            child: Badge(
                              label: Text(
                                (ref
                                            .watch(shopOrderProvider)
                                            .cart
                                            ?.userCarts
                                            ?.first
                                            .cartDetails
                                            ?.length ??
                                        0)
                                    .toString(),
                                style: const TextStyle(color: AppStyle.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _cartButton(BuildContext context, WidgetRef ref, bool isCartEmpty) {
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap: () {
          if (LocalStorage.getToken().isEmpty) {
            context.pushRoute(LoginRoute());
            return;
          }
          context.pushRoute(OrderRoute());
        },
        child: Container(
          margin: EdgeInsets.only(left: 8.w),
          width: 56.r,
          height: 56.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(0, 0, 0, 0.8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                FlutterRemix.shopping_basket_2_fill,
                color: AppStyle.white,
              ),
              Positioned(
                top: 9,
                right: 8,
                child: Badge(
                  label: Text(
                    isCartEmpty
                        ? "0"
                        : (ref
                                      .watch(shopOrderProvider)
                                      .cart
                                      ?.userCarts
                                      ?.first
                                      .cartDetails
                                      ?.length ??
                                  0)
                              .toString(),
                    style: const TextStyle(color: AppStyle.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getCartShopName(Cart? cart, WidgetRef ref) {
  if (cart == null || cart.shopId == null) return "";

  // Use the shopId from the cart, not the current shop being viewed
  final shopId = cart.shopId;
  final homeState = ref.read(homeProvider);

  // Look for the shop in homeState
  final shop = homeState.shops.firstWhere(
    (s) => s.id == shopId,
    orElse: () => homeState.newShops.firstWhere(
      (s) => s.id == shopId,
      orElse: () => homeState.allShops.firstWhere(
        (s) => s.id == shopId,
        orElse: () => homeState.shopsRecommend.firstWhere(
          (s) => s.id == shopId,
          orElse: () => homeState.filterShops.firstWhere(
            (s) => s.id == shopId,
            orElse: () => ShopData(),
          ),
        ),
      ),
    ),
  );

  return shop.translation?.title ?? "";
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
