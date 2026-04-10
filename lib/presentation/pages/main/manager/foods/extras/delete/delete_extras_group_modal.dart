import 'package:rokctapp/infrastructure/models/data/product_data.dart';


import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_wrap.dart';


import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';


class DeleteExtrasGroupModal extends StatelessWidget {
  final Group group;

  const DeleteExtrasGroupModal({super.key, required this.group});

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
              '${help.AppHelpers.getTranslation(TrKeys.areYouSureToDelete)} "${group.translation?.title}"?',
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
                            .watch(deleteExtrasGroupProvider)
                            .isLoading,
                        onPressed: () => ref
                            .read(deleteExtrasGroupProvider.notifier)
                            .deleteExtrasGroup(
                              context,
                              groupId: group.id,
                              success: () {
                                ref.read(extrasProvider.notifier).fetchGroups();
                                context.router.popUntilRoot();
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
