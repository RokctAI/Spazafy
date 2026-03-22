import 'package:rokctapp/dummy_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

class SearchedUserItem extends StatelessWidget {
  final UserData user;

  const SearchedUserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppStyle.white),
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: REdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.firstname ?? AppHelpers.getTranslation(TrKeys.noName)} ${user.lastname ?? ''}',
            style: AppStyle.interNormal(),
          ),
          6.verticalSpace,
          Text('${user.email}', style: AppStyle.interRegular(size: 12)),
        ],
      ),
    );
  }
}
