import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';


class ForgotTextButton extends ConsumerWidget {
  final String title;
  final Function() onPressed;
  final double? fontSize;
  final Color? fontColor;
  final double? letterSpacing;

  const ForgotTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.fontSize,
    this.fontColor = AppStyle.black,
    this.letterSpacing = -14 * 0.02,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: ButtonStyle(
        // ignore: deprecated_member_use
        overlayColor: MaterialStateColor.resolveWith(
          (states) => AppStyle.bgGrey,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: AppStyle.interNormal(
          textDecoration: TextDecoration.underline,
          size: 12,
          color: AppStyle.black,
        ),
      ),
    );
  }
}
