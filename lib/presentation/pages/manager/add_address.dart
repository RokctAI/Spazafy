import 'package:rokctapp/app_constants.dart';

import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          help.AppHelpers.getTranslation(TrKeys.agreeLocation),
          style: AppStyle.interSemi(size: 16),
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: help.AppHelpers.getTranslation(TrKeys.cancel),
                borderColor: AppStyle.black,
                background: AppStyle.transparent,
                onPressed: () {
                  Navigator.pop(context);
                  context.router.push(ViewMapRoute(onChanged: () {}));
                },
              ),
            ),
            24.horizontalSpace,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return CustomButton(
                    title: help.AppHelpers.getTranslation(TrKeys.yes),
                    onPressed: () {
                      Navigator.pop(context);
                      LocalStorage.setAddressSelected(
                        AddressData(
                          location: LocationData(
                            latitude:
                                (help.AppHelpers.getInitialLatitude() ??
                                AppConstants.demoLatitude),
                            longitude:
                                (help.AppHelpers.getInitialLongitude() ??
                                AppConstants.demoLongitude),
                          ),
                          title: help.AppHelpers.getAppAddressName(),
                        ),
                      );
                      //ref.read(homeProvider.notifier).setAddress();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
