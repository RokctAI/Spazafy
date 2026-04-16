import 'package:rokctapp/application/main/manager/main_provider.dart';
import 'package:rokctapp/app_constants.dart';

import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/foods_page.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/pages/main/manager/orders/orders_home_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/billing/home_page.dart';
import 'package:rokctapp/presentation/components/buttons/manager/buttons_bouncing_effect.dart';
import 'package:rokctapp/presentation/components/helper/blur_wrap.dart';
import 'package:rokctapp/presentation/components/helper/common_image.dart';
import 'package:rokctapp/presentation/components/helper/keyboard_disable.dart';
import 'package:rokctapp/presentation/pages/main/widgets/bottom_navigator_item.dart';
import 'package:rokctapp/presentation/pages/restaurant/manager/restaurant_page.dart';

import 'package:rokctapp/presentation/pages/main/manager/foods/create/create_product_modal.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/addons/create/create_addon_modal.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart' as help;
import 'package:rokctapp/presentation/pages/main/manager/foods/extras/create/create_extras_group_modal.dart';
import 'package:rokctapp/application/main/manager/orders/new/new_orders_provider.dart';
import 'package:rokctapp/application/main/manager/foods/tabs/food_tabs_provider.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';

@RoutePage()
class ManagerMainPage extends StatefulWidget {
  const ManagerMainPage({super.key});

  @override
  State<ManagerMainPage> createState() => _ManagerMainPageState();
}

class _ManagerMainPageState extends State<ManagerMainPage> {
  List<IndexedStackChild> list = [
    IndexedStackChild(child: const ManagerBillingPage(), preload: true),
    IndexedStackChild(child: const OrdersHomePage(), preload: true),
    IndexedStackChild(child: const FoodsPage(), preload: false),
    IndexedStackChild(child: const RestaurantPage(), preload: false),
  ];

  Timer? timer;
  int time = 0;
  final player = AudioPlayer();

  Future playMusic() async {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await player.play(AssetSource("audio/notification.wav"));
    });
  }

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
      badge: false,
    );
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      await Firebase.initializeApp();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (AppConstants.playMusicOnOrderStatusChange) {
        player.play(AssetSource("audio/notification.wav"));
      }
      if (mounted) {
        help.AppHelpers.showCheckTopSnackBar(
          context,
          type: SnackBarType.success,
          text:
              "${help.AppHelpers.getTranslation(TrKeys.id)} #${message.notification?.title} ${message.notification?.body}",
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDisable(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Consumer(
            builder: (context, ref, child) {
              if (AppConstants.keepPlayingOnNewOrder) {
                ref.listen(newOrdersProvider, (previous, next) async {
                  if (next.orders.isEmpty) {
                    await player.stop();
                    timer?.cancel();
                  }

                  if (time != 0 && next.orders.isNotEmpty) {
                    await playMusic();
                  }
                  time++;
                });
              }
              return ProsteIndexedStack(
                index: ref.watch(mainProvider).selectedIndex,
                children: list,
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(mainProvider);
              final event = ref.read(mainProvider.notifier);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlurWrap(
                    radius: BorderRadius.circular(100.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: AppStyle.bottomNavigationBarColor.withOpacity(
                          0.6,
                        ),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      height: 60.r,
                      child: Padding(
                        padding: REdgeInsets.only(
                          right: 10,
                          left: !state.isScrolling ? 10 : 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BottomNavigatorItem(
                              isScrolling: state.isScrolling,
                              selectItem: () => event.selectIndex(0),
                              currentIndex: state.selectedIndex,
                              index: 0,
                              selectIcon: FlutterRemix.scan_2_fill,
                              unSelectIcon: FlutterRemix.scan_2_line,
                              label: help.AppHelpers.getTranslation(TrKeys.pos),
                            ),
                            BottomNavigatorItem(
                              isScrolling: state.isScrolling,
                              selectItem: () => event.selectIndex(1),
                              currentIndex: state.selectedIndex,
                              index: 1,
                              selectIcon: FlutterRemix.file_list_2_fill,
                              unSelectIcon: FlutterRemix.file_list_2_line,
                              label: help.AppHelpers.getTranslation(
                                TrKeys.orders,
                              ),
                            ),
                            BottomNavigatorItem(
                              isScrolling: state.isScrolling,
                              selectItem: () => event.selectIndex(2),
                              index: 2,
                              currentIndex: state.selectedIndex,
                              selectIcon: FlutterRemix.restaurant_fill,
                              unSelectIcon: FlutterRemix.restaurant_line,
                              label: help.AppHelpers.getTranslation(
                                TrKeys.products,
                              ),
                            ),
                            _profileItem(() {
                              event.selectIndex(3);
                              ref
                                  .read(mainProvider.notifier)
                                  .changeScrolling(false);
                            }, state.selectedIndex),
                          ],
                        ),
                      ),
                    ),
                  ),
                  state.selectedIndex != 2
                      ? ButtonsBouncingEffect(
                          child: Hero(
                            tag: AppConstants.heroTagAddOrderButton,
                            child: Consumer(
                              builder: (context, ref, child) {
                                final foodTabState = ref.watch(
                                  foodTabsProvider,
                                );
                                return GestureDetector(
                                  onTap: () {
                                    state.selectedIndex == 0
                                        ? context.pushRoute(
                                            const ManagerCreateOrderRoute(),
                                          )
                                        : (foodTabState.selectedIndex == 0
                                              ? help.AppHelpers.showCustomModalBottomSheet(
                                                  paddingTop:
                                                      MediaQuery.paddingOf(
                                                        context,
                                                      ).top +
                                                      64.h,
                                                  context: context,
                                                  modal:
                                                      const CreateProductModal(),
                                                  isDarkMode: false,
                                                )
                                              : (foodTabState.selectedIndex == 1
                                                    ? help.AppHelpers.showCustomModalBottomSheet(
                                                        paddingTop:
                                                            MediaQuery.paddingOf(
                                                              context,
                                                            ).top +
                                                            64.h,
                                                        context: context,
                                                        modal:
                                                            const CreateAddonModal(),
                                                        isDarkMode: false,
                                                      )
                                                    : help.AppHelpers.showCustomModalBottomSheet(
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
                                    margin: EdgeInsetsDirectional.only(
                                      start: 8.r,
                                    ),
                                    width: 56.r,
                                    height: 56.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppStyle.primary,
                                    ),
                                    child: Icon(
                                      FlutterRemix.add_line,
                                      size: 26.r,
                                      color: AppStyle.buttonFontColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  GestureDetector _profileItem(Function() onTap, int index) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        margin: EdgeInsets.only(left: 12.r),
        decoration: BoxDecoration(
          border: Border.all(
            color: index == 3 ? AppStyle.primary : AppStyle.transparent,
            width: 2.w,
          ),
          shape: BoxShape.circle,
        ),
        child: CommonImage(
          url: LocalStorage.getShop()?.logoImg,
          width: 40,
          height: 40,
          radius: 20,
        ),
      ),
    );
  }
}
