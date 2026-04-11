import 'package:rokctapp/presentation/theme/app_style.dart';
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/shop_order/shop_order_provider.dart';
import 'package:rokctapp/infrastructure/models/data/cart_data.dart';
import 'package:rokctapp/infrastructure/models/data/shop_data.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:flutter/services.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/buttons/custom_button.dart';
import 'package:rokctapp/presentation/components/title/title_icon.dart';

import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/application/shop/shop_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/check_status_dialog.dart';
import 'widgets/group_item.dart';

class GroupOrderScreen extends ConsumerStatefulWidget {
  final ShopData shop;
  final String? cartId;

  const GroupOrderScreen({super.key, required this.shop, this.cartId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupOrderPageState();
}

class _GroupOrderPageState extends ConsumerState<GroupOrderScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(shopOrderProvider.notifier)
          .getCart(
            context,
            () {},
            isShowLoading: false,
            userUuid: ref.watch(shopProvider).userUuid,
            cartId: widget.cartId,
            shopId: (widget.shop.id ?? "").toString(),
          );
      ref
          .read(shopOrderProvider.notifier)
          .generateShareLink(
            widget.shop.translation?.title ?? "",
            widget.shop.logoImg ?? "",
            widget.shop.type,
          );
    });

    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      ref
          .read(shopOrderProvider.notifier)
          .getCart(
            context,
            () {},
            isShowLoading: false,
            cartId: widget.cartId,
            shopId: (widget.shop.id ?? "").toString(),
            userUuid: ref.watch(shopProvider).userUuid,
          );
    });
  }

  @override
  void deactivate() {
    timer?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(shopOrderProvider);
    final event = ref.read(shopOrderProvider.notifier);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppStyle.bgGrey.withOpacity(0.96),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.verticalSpace,
                Center(
                  child: Container(
                    height: 4.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: AppStyle.dragElement,
                      borderRadius: BorderRadius.all(Radius.circular(40.r)),
                    ),
                  ),
                ),
                14.verticalSpace,
                TitleAndIcon(
                  title: AppHelpers.getTranslation(TrKeys.startGroupOrder),
                  paddingHorizontalSize: 0,
                ),
                10.verticalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.youFullyManaga),
                  style: AppStyle.interRegular(
                    size: 14,
                    color: AppStyle.textGrey,
                  ),
                ),
                30.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 220.w,
                      height: 46.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppStyle.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppStyle.black.withOpacity(0.04),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(
                              0,
                              2,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        state.shareLink,
                        style: AppStyle.interRegular(
                          size: 14,
                          color: AppStyle.textGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        AppHelpers.showCheckTopSnackBarDone(
                          context,
                          AppHelpers.getTranslation(TrKeys.coped),
                        );
                        await Clipboard.setData(
                          ClipboardData(text: state.shareLink),
                        );
                      },
                      child: Container(
                        width: 46.w,
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: AppStyle.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppStyle.black.withOpacity(0.04),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(
                                0,
                                2,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Icon(FlutterRemix.file_copy_fill),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share(
                          state.shareLink,
                          subject: AppHelpers.getTranslation(
                            TrKeys.groupOrderProgress,
                          ),
                        );
                      },
                      child: Container(
                        width: 46.w,
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: AppStyle.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppStyle.black.withOpacity(0.04),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(
                                0,
                                2,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Icon(FlutterRemix.share_fill),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    20.verticalSpace,
                    TitleAndIcon(
                      title: AppHelpers.getTranslation(TrKeys.groupMember),
                      paddingHorizontalSize: 0,
                      titleSize: 14,
                    ),
                    8.verticalSpace,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts?.length ?? 0,
                      itemBuilder: (context, index) {
                        List<CartDetail?>? list =
                            state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts?[index].cartDetails;
                        num total = 0;
                        list?.forEach((element) {
                          total += element?.price ?? 0;
                          element?.addons?.forEach((e) {
                            total += e.price ?? 0;
                          });
                        });
                        return GroupItem(
                          name: state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts?[index].name ?? "",
                          price: total,
                          isChoosing:
                              state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts?[index].status ?? false,
                          onDelete: () {
                            ref
                                .read(shopOrderProvider.notifier)
                                .deleteUser(context, index);
                          },
                          isDeleteButton:
                              LocalStorage.getUser()?.id == state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId
                              ? index != 0
                              : false,
                        );
                      },
                    ),
                  ],
                ),
                24.verticalSpace,
                LocalStorage.getUser()?.id == state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: CustomButton(
                          title:
                              (state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts
                                      ?.where(
                                        (element) =>
                                            element.userId ==
                                            state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId,
                                      )
                                      .isNotEmpty ??
                                  false)
                              ? (state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts
                                            ?.where(
                                              (element) =>
                                                  element.userId ==
                                                  state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId,
                                            )
                                            .single
                                            .status ??
                                        true)
                                    ? AppHelpers.getTranslation(TrKeys.done)
                                    : AppHelpers.getTranslation(TrKeys.order)
                              : AppHelpers.getTranslation(TrKeys.order),
                          onPressed: () {
                            if ((state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts
                                        ?.where(
                                          (element) =>
                                              element.userId ==
                                              state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId,
                                        )
                                        .isNotEmpty ??
                                    false) &&
                                (state.carts[widget.cartId ?? widget.shop.id.toString()]?.userCarts
                                        ?.where(
                                          (element) =>
                                              element.userId ==
                                              state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId,
                                        )
                                        .single
                                        .status ??
                                    true)) {
                              event.changeStatus(
                                context,
                                (state.carts[widget.cartId ?? widget.shop.id.toString()])!.userCarts
                                    ?.where(
                                      (element) =>
                                          element.userId == state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId,
                                    )
                                    .single
                                    .uuid,
                                widget.shop.id.toString()
                              );
                              setState(() {});
                              return;
                            }
                            bool check = false;
                            bool checkProduct = false;
                            for (UserCart cart in (state.carts[widget.cartId ?? widget.shop.id.toString()])!.userCarts!) {
                              if (cart.status ?? true) {
                                check = true;
                                break;
                              }
                              if (cart.cartDetails?.isNotEmpty ?? false) {
                                checkProduct = true;
                                break;
                              }
                            }
                            if (check) {
                              AppHelpers.showAlertDialog(
                                context: context,
                                child: CheckStatusDialog(
                                  cancel: () {
                                    Navigator.pop(context);
                                  },
                                  onTap: () {
                                    for (UserCart cart
                                        in (state.carts[widget.cartId ?? widget.shop.id.toString()])!.userCarts!) {
                                      if (cart.cartDetails?.isNotEmpty ??
                                          false) {
                                        checkProduct = true;
                                        break;
                                      }
                                    }
                                    if (!checkProduct) {
                                      Navigator.pop(context);
                                      AppHelpers.showCheckTopSnackBarInfo(
                                        context,
                                        AppHelpers.getTranslation(
                                          TrKeys.needSelectProduct,
                                        ),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                      context.router.pushNamed('/orderScreen');
                                    }
                                  },
                                ),
                              );
                            } else if (!checkProduct) {
                              AppHelpers.showCheckTopSnackBarInfo(
                                context,
                                AppHelpers.getTranslation(
                                  TrKeys.needSelectProduct,
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              context.router.pushNamed('/orderScreen');
                            }
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom + 16.h,
                  ),
                  child: CustomButton(
                    title: AppHelpers.getTranslation(
                      LocalStorage.getUser()?.id == state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId
                          ? TrKeys.cancel
                          : TrKeys.leaveGroup,
                    ),
                    borderColor: AppStyle.black,
                    background: AppStyle.transparent,
                    onPressed: () {
                      if (LocalStorage.getUser()?.id == state.carts[widget.cartId ?? widget.shop.id.toString()]?.ownerId) {
                        event.deleteCart(context, widget.shop.id.toString());
                      } else {
                        event.deleteUser(
                          context,
                          0,
                          widget.shop.id.toString(),
                          userId: ref.watch(shopProvider).userUuid,
                        );
                        ref.read(shopProvider.notifier).leaveGroup();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
