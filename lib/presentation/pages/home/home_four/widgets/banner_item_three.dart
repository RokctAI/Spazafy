import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/infrastructure/models/response/banners_paginate_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/presentation/components/custom_network_image.dart';
import 'package:rokctapp/presentation/pages/home/home_four/widgets/banner_screen.dart';
import 'package:rokctapp/presentation/theme/theme.dart';

class BannerItemThree extends StatelessWidget {
  final BannerData banner;

  const BannerItemThree({super.key, required this.banner});

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
        margin: EdgeInsets.symmetric(horizontal: 12.r),
        width: MediaQuery.sizeOf(context).width - 46,
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: CustomNetworkImage(
          bgColor: AppStyle.white,
          url: banner.img ?? "",
          width: double.infinity,
          radius: 15.r,
          height: double.infinity,
        ),
      ),
    );
  }
}
