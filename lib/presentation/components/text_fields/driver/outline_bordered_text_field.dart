import 'package:rokctapp/dummy_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';


class OutlinedBorderTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? suffixIcon;
  final bool? obscure;
  final TextEditingController? textController;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validation;
  final TextInputType? inputType;
  final String? initialText;
  final String? descriptionText;
  final bool readOnly;
  final bool isError;
  final bool isSuccess;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;

  const OutlinedBorderTextField({
    super.key,
    required this.label,
    this.suffixIcon,
    this.onTap,
    this.obscure,
    this.validation,
    this.onChanged,
    this.textController,
    this.inputType,
    this.initialText,
    this.descriptionText,
    this.readOnly = false,
    this.isError = false,
    this.isSuccess = false,
    this.textCapitalization,
    this.textInputAction,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label!,
                style: AppStyle.interNormal(size: 9, color: AppStyle.black),
              ),
            ],
          ),
        TextFormField(
          // maxLines: null,
          onTap: onTap,
          autocorrect: true,
          onChanged: onChanged,
          obscureText: !(obscure ?? true),
          obscuringCharacter: '*',
          controller: textController,
          validator: validation,
          style: AppStyle.interNormal(size: 15.sp, color: AppStyle.black),
          cursorWidth: 1,
          cursorColor: AppStyle.black,
          keyboardType: inputType,
          initialValue: initialText,
          readOnly: readOnly,
          textCapitalization:
              textCapitalization ?? TextCapitalization.sentences,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            suffixIconConstraints: BoxConstraints(
              maxHeight: 30.h,
              maxWidth: 30.h,
            ),
            suffixIcon: suffixIcon,
            hintText: hint ?? AppHelpers.getTranslation(TrKeys.typeSomething),
            hintStyle: AppStyle.interNormal(
              size: 13,
              color: AppStyle.black.withValues(alpha: .5),
            ),
            contentPadding: REdgeInsets.symmetric(horizontal: 0, vertical: 8),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            fillColor: AppStyle.pendingDark,
            filled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide.merge(
                BorderSide(color: AppStyle.black.withValues(alpha: .5)),
                BorderSide(color: AppStyle.black.withValues(alpha: .5)),
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.borderColor),
                const BorderSide(color: AppStyle.borderColor),
              ),
            ),
            border: const UnderlineInputBorder(),
            focusedErrorBorder: const UnderlineInputBorder(),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.borderColor),
                const BorderSide(color: AppStyle.borderColor),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(),
          ),
        ),
        if (descriptionText != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              4.verticalSpace,
              Text(
                descriptionText!,
                style: AppStyle.interRegular(
                  letterSpacing: -0.3,
                  size: 12,
                  color: isError
                      ? AppStyle.red
                      : isSuccess
                      ? AppStyle.bgGrey
                      : AppStyle.pendingDark,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
