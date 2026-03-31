import 'package:rokctapp/infrastructure/services/utils/navigation_extension.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/components/components_driver.dart';

class AddComment extends StatelessWidget {
  final ValueChanged<String> onChange;

  const AddComment({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          TitleAndIcon(
            title: help.AppHelpers.getTranslation(TrKeys.addComment),
          ),
          24.verticalSpace,
          UnderlinedBorderTextField(
            label: help.AppHelpers.getTranslation(TrKeys.comment),
            onChanged: onChange,
          ),
          36.verticalSpace,
          CustomButton(
            title: help.AppHelpers.getTranslation(TrKeys.save),
            onPressed: context.router.maybePop,
          ),
          36.verticalSpace,
        ],
      ),
    );
  }
}
