import 'package:rokctapp/infrastructure/models/data/product_data.dart'
    hide Extras;

import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/modal_wrap.dart';

import 'package:rokctapp/infrastructure/models/data/extras.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/application/main/manager/foods/extras/details/delete_item/delete_extras_item_provider.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/extras_group_details_provider.dart';

class DeleteExtrasItemModal extends StatelessWidget {
  final Extras extras;

  const DeleteExtrasItemModal({super.key, required this.extras});

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModalDrag(),
            40.verticalSpace,
            Text(
              '${help.AppHelpers.getTranslation(TrKeys.areYouSureToDelete)} ${extras.value}?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18,
                color: AppStyle.blackColor,
                fontWeight: FontWeight.w500,
                letterSpacing: -14 * 0.02,
              ),
            ),
            36.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: help.AppHelpers.getTranslation(TrKeys.cancel),
                    onPressed: context.maybePop,
                    background: AppStyle.transparent,
                    borderColor: AppStyle.blackColor,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      return CustomButton(
                        title: help.AppHelpers.getTranslation(TrKeys.yes),
                        isLoading: ref
                            .watch(deleteExtrasItemProvider)
                            .isLoading,
                        onPressed: () => ref
                            .read(deleteExtrasItemProvider.notifier)
                            .deleteExtrasItem(
                              context,
                              extrasId: extras.id,
                              success: () {
                                ref
                                    .read(extrasGroupDetailsProvider.notifier)
                                    .fetchGroupExtras(
                                      groupId: extras.extraGroupId,
                                    );
                                context.router.maybePop();
                              },
                            ),
                        background: AppStyle.red,
                        borderColor: AppStyle.red,
                        textColor: AppStyle.white,
                      );
                    },
                  ),
                ),
              ],
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
