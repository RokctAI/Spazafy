import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/helper/driver/modal_drag.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/profile/profile_provider.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_wrap.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';

class LogoutModal extends StatelessWidget {
  final bool isDeleteAccount;

  const LogoutModal({super.key, this.isDeleteAccount = false});

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModalDrag(),
            12.verticalSpace,
            Text(
              help.AppHelpers.getTranslation(
                isDeleteAccount
                    ? TrKeys.areYouSure
                    : TrKeys.doYouReallyWantToLogout,
              ),
              style: AppStyle.interSemi(size: 16),
              textAlign: TextAlign.center,
            ),
            40.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    borderColor: AppStyle.black,
                    background: AppStyle.transparent,
                    textColor: AppStyle.black,
                    title: help.AppHelpers.getTranslation(TrKeys.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      if (isDeleteAccount) {
                        return CustomButton(
                          background: AppStyle.red,
                          textColor: AppStyle.white,
                          title: help.AppHelpers.getTranslation(
                            TrKeys.deleteAccount,
                          ),
                          onPressed: () {
                            ref
                                .read(profileProvider.notifier)
                                .deleteAccount(context);
                          },
                        );
                      } else {
                        return CustomButton(
                          title: help.AppHelpers.getTranslation(TrKeys.logout),
                          onPressed: () {
                            LocalStorage.logout();
                            context.router.popUntilRoot();
                            context.replaceRouteNamed('/manager/auth');
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            32.verticalSpace,
          ],
        ),
      ),
    );
  }
}
