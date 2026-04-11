import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:remixicon/remixicon.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/helper/blur_wrap.dart';

class PopButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PopButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlurWrap(
      radius: BorderRadius.circular(100.r),
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.pop(context),
        child: Container(
          constraints: BoxConstraints(minWidth: 100.w),
          height: 48.r,
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          decoration: BoxDecoration(
            color: AppStyle.bottomNavigationBarColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Remix.arrow_left_wide_fill,
                    size: 20.r,
                    color: AppStyle.white,
                  ),
                  4.horizontalSpace,
                  Column(
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.back),
                        style: TextStyle(
                          color: AppStyle.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      3.verticalSpace,
                      Container(
                        height: 4.h,
                        width: 24.w,
                        decoration: BoxDecoration(
                          color: AppStyle.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100.r),
                            topRight: Radius.circular(100.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
