import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/home/home_provider.dart';
import 'package:rokctapp/infrastructure/models/data/address_old_data.dart';
import 'package:rokctapp/infrastructure/models/data/location.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/buttons/custom_button.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/presentation/theme/theme.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.agreeLocation),
          style: AppStyle.interSemi(size: 16.sp),
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: AppHelpers.getTranslation(TrKeys.cancel),
                borderColor: AppStyle.black,
                background: AppStyle.transparent,
                onPressed: () {
                  Navigator.pop(context);
                  context.pushRoute(ViewMapRoute(isPop: true));
                },
              ),
            ),
            24.horizontalSpace,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return CustomButton(
                    title: AppHelpers.getTranslation(TrKeys.yes),
                    onPressed: () {
                      Navigator.pop(context);
                      LocalStorage.setAddressSelected(
                        AddressData(
                          title: AppHelpers.getAppAddressName(),
                          location: LocationModel(
                            longitude:
                                (AppHelpers.getInitialLongitude() ??
                                AppConstants.demoLongitude),
                            latitude:
                                (AppHelpers.getInitialLatitude() ??
                                AppConstants.demoLatitude),
                          ),
                        ),
                      );
                      ref.read(homeProvider.notifier).setAddress();
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
