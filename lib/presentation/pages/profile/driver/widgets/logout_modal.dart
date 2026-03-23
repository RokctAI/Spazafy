import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/providers_driver.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

class LogoutModal extends StatelessWidget {
  final bool isDeleteAccount;

  const LogoutModal({super.key, this.isDeleteAccount = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Text(
            help.AppHelpers.getTranslation(
              isDeleteAccount
                  ? TrKeys.areYouSure
                  : TrKeys.doYouReallyWantToLogout,
            ),
            style: AppStyle.interSemi(size: 16.sp),
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  borderColor: AppStyle.black,
                  background: AppStyle.transparent,
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
                              .read(profileSettingsProvider.notifier)
                              .deleteAccount(context);
                        },
                      );
                    } else {
                      return CustomButton(
                        title: help.AppHelpers.getTranslation(TrKeys.logout),
                        onPressed: () {
                          LocalStorage.logout();
                          context.router.popUntilRoot();
                          context.replaceRoute(const LoginRoute());
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
