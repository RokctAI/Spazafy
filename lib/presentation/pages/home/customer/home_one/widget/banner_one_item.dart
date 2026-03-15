import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venderfoodyman/infrastructure/models/customer/response/banners_paginate_response.dart';
import 'package:venderfoodyman/infrastructure/services/customer/app_helpers.dart';
import 'package:venderfoodyman/presentation/components/customer/custom_network_image.dart';
import 'package:venderfoodyman/presentation/pages/customer/home/widgets/banner_screen.dart';

import 'package:venderfoodyman/presentation/theme/customer/app_style.dart';

class BannerOneItem extends StatelessWidget {
  final BannerData banner;

  const BannerOneItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: BannerScreen(
            bannerId: banner.id ?? 0,
            image: banner.img ?? "",
            desc: banner.translation?.description ?? "",
            list: banner.shops ?? [],
          ),
          isDarkMode: false,
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 6.r),
        width: MediaQuery.sizeOf(context).width - 46,
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: CustomNetworkImage(
          bgColor: AppStyle.white,
          url: banner.img ?? "",
          height: double.infinity,
          width: double.infinity,
          radius: 20.r,
        ),
      ),
    );
  }
}




