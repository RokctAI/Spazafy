import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/infrastructure/models/data/order_detail.dart';
import 'package:rokctapp/application/home/driver/home_provider.dart';


import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/exports/components_driver.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/pages/home/driver/widgets/approve_dialog.dart';
import 'package:rokctapp/presentation/pages/home/driver/widgets/foods_page.dart';
import 'package:rokctapp/presentation/pages/home/driver/widgets/rate_customer.dart';

class DeliverBottomSheetScreen extends StatefulWidget {
  final OrderDetailData order;

  const DeliverBottomSheetScreen({super.key, required this.order});

  @override
  State<DeliverBottomSheetScreen> createState() =>
      _DeliverBottomSheetScreenState();
}

class _DeliverBottomSheetScreenState extends State<DeliverBottomSheetScreen> {
  TextEditingController noteCon = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    noteCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer(
        builder: (context, ref, child) {
          return SizedBox(
            height: ref.watch(homeProvider).isGoUser
                ? MediaQuery.sizeOf(context).height * 1.8 / 3
                : MediaQuery.sizeOf(context).height * 2 / 3,
            width: double.infinity,
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              maxChildSize: 1,
              minChildSize: 0.16,
              snap: true,
              builder: (context, scrollController) => Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: AppStyle.bgGrey,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    topLeft: Radius.circular(12.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyle.black.withValues(alpha: 0.25),
                      blurRadius: 40,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: 8.h,
                    bottom: MediaQuery.paddingOf(context).bottom + 16.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                  children: [
                    Container(
                      height: 4.h,
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            (MediaQuery.sizeOf(context).width - 100.w) / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppStyle.dragElement,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                    ),
                    24.verticalSpace,
                    OrderItem(
                      order: widget.order,
                      isDeliveryShop: ref.watch(homeProvider).isGoRestaurant,
                      isDeliveryClient: ref.watch(homeProvider).isGoUser,
                    ),
                    24.verticalSpace,
                    ref.watch(homeProvider).isGoRestaurant
                        ? Column(
                            children: [
                              CustomButton(
                                title: help.AppHelpers.getTranslation(
                                  TrKeys.orderInformation,
                                ),
                                onPressed: () {
                                  help.AppHelpers.showCustomModalBottomSheet(
                                    context: context,
                                    modal: FoodsPage(order: widget.order),
                                    isDarkMode: false,
                                  );
                                },
                                background: AppStyle.transparent,
                                borderColor: AppStyle.black,
                              ),
                              10.verticalSpace,
                            ],
                          )
                        : const SizedBox.shrink(),
                    CustomButton(
                      title: help.AppHelpers.getTranslation(
                        ref.watch(homeProvider).isGoRestaurant
                            ? TrKeys.completeCheckout
                            : TrKeys.iDeliveredTheOrder,
                      ),
                      onPressed: () {
                        if (ref.watch(homeProvider).isGoRestaurant) {
                          help.AppHelpers.showAlertDialog(
                            context: context,
                            child: ApproveOrderDialog(order: widget.order),
                          );
                        } else {
                          help.AppHelpers.openDialogImagePicker(
                            context: context,
                            onSuccess: (path) async {
                              if (context.mounted) {
                                if (path.isNotEmpty) {
                                  ref
                                      .read(homeProvider.notifier)
                                      .uploadImage(
                                        context: context,
                                        orderId: widget.order.id,
                                        path: path,
                                      );
                                }
                                ref
                                    .read(homeProvider.notifier)
                                    .deliveredFinish(
                                      context: context,
                                      orderId: widget.order.id,
                                    );
                                Navigator.pop(context);
                                help.AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: RateCustomer(order: widget.order),
                                  isDarkMode: false,
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      title: help.AppHelpers.getTranslation(TrKeys.cancel),
                      textColor: Colors.white,
                      background: AppStyle.red,
                      onPressed: () {
                        help.AppHelpers.showAlertDialog(
                          context: context,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppStyle.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 30.h,
                                  horizontal: 24.w,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: help.AppHelpers.getTranslation(
                                          TrKeys.areYouSure,
                                        ),
                                        style: AppStyle.interNormal(
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                                    Form(
                                      key: formKey,
                                      child: UnderlinedBorderTextField(
                                        textController: noteCon,
                                        label: 'Note',
                                        validator: (p0) {
                                          if (p0?.isEmpty ?? true) {
                                            return help
                                                .AppHelpers.getTranslation(
                                              TrKeys.cannotBeEmpty,
                                            );
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    32.verticalSpace,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            title:
                                                help.AppHelpers.getTranslation(
                                                  TrKeys.cancel,
                                                ),
                                            background: AppStyle.red,
                                            textColor: AppStyle.white,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        Expanded(
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              return CustomButton(
                                                title:
                                                    help.AppHelpers.getTranslation(
                                                      TrKeys.confirmation,
                                                    ),
                                                background: AppStyle.black,
                                                textColor: AppStyle.white,
                                                borderColor: Colors.transparent,
                                                onPressed: () {
                                                  if ((formKey.currentState
                                                              ?.validate() ??
                                                          false) &&
                                                      widget.order.id != null) {
                                                    ref
                                                        .read(
                                                          homeProvider.notifier,
                                                        )
                                                        .cancelOrder(
                                                          context: context,
                                                          orderId:
                                                              widget.order.id ??
                                                              0,
                                                          note: noteCon.text,
                                                        );
                                                    Navigator.pop(context);
                                                  }

                                                  /// TODO CANCEL ORDER AND SEND NOTE
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
