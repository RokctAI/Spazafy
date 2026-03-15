import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/tr_keys.dart';
import 'package:venderfoodyman/presentation/theme/customer/app_style.dart';

class ProcessingView extends StatelessWidget {
  const ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppStyle.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200.h,
                  child: Lottie.asset('assets/lottie/processing.json'),
                ),
                16.verticalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.yourRequest),
                  style: AppStyle.interSemi(size: 18, color: AppStyle.black),
                  textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                Text(
                  'We are reviewing your application. You will be notified once approved.',
                  style: AppStyle.interRegular(
                    size: 14,
                    color: AppStyle.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          36.verticalSpace,
        ],
      ),
    );
  }
}
