import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rokctapp/presentation/theme/app_style.dart';
import 'buttons/buttons_bouncing_effect.dart';

class AppBarBottomSheet extends StatelessWidget {
  final String title;

  const AppBarBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonsBouncingEffect(
          child: GestureDetector(
            onTap: context.router.maybePop,
            child: Icon(
              Icons.arrow_back,
              color: AppStyle.blackColor,
              size: 24.r,
            ),
          ),
        ),
        Text(
          title,
          style: AppStyle.interSemi(
            size: 20,
            color: AppStyle.blackColor,
            letterSpacing: -0.01,
          ),
        ),
        Container(width: 24.w, height: 24.h, margin: const EdgeInsets.all(8)),
      ],
    );
  }
}
