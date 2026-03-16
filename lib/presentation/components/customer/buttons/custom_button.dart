import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:venderfoodyman/presentation/theme/customer/theme.dart';
import 'animation_button_effect.dart';

class CustomButton extends StatelessWidget {
  final Icon? icon;
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final double weight;
  final double radius;

  CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.background = AppStyle.primary,
    this.textColor = AppStyle.black,
    this.weight = double.infinity,
    this.radius = 8,
    this.icon,
    this.borderColor = AppStyle.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = background ?? AppStyle.primary;
    final bColor = borderColor ?? AppStyle.transparent;
    final tColor = textColor ?? AppStyle.black;
    return AnimationButtonEffect(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: bColor == AppStyle.transparent
                ? bgColor
                : bColor,
            width: 2.r,
          ),
          elevation: 0,
          shadowColor: AppStyle.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.r),
          ),
          minimumSize: Size(weight, 50.h),
          backgroundColor: bgColor,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(
                  color: tColor,
                  strokeWidth: 2.r,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon == null
                      ? const SizedBox()
                      : Row(children: [icon!, 10.horizontalSpace]),
                  Text(
                    title,
                    style: AppStyle.interNormal(
                      size: 15,
                      color: tColor,
                      letterSpacing: -14 * 0.01,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
