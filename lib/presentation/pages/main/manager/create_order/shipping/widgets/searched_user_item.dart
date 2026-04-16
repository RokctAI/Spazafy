import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:rokctapp/infrastructure/models/data/driver/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/infrastructure/models/response/login_response.dart';

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
            '${user.firstname ?? help.AppHelpers.getTranslation(TrKeys.noName)} ${user.lastname ?? ''}',
            style: AppStyle.interNormal(),
          ),
          6.verticalSpace,
          Text('${user.email}', style: AppStyle.interRegular(size: 12)),
        ],
      ),
    );
  }
}
