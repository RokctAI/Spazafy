import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rokctapp/application/profile/profile_notifier.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/theme/theme.dart';

class BackgroundImagePicker extends StatelessWidget {
  final String backgroundImage;
  final ProfileNotifier event;

  const BackgroundImagePicker({
    super.key,
    required this.backgroundImage,
    required this.event,
  });

  Future<void> _pickBackgroundImage() async {
    XFile? file;
    try {
      file = await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (ex) {
      debugPrint('===> trying to select background image $ex');
    }
    if (file != null) {
      event.setBgImage(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            AppHelpers.getTranslation(TrKeys.backgroundImage),
            style: AppStyle.interSemi(size: 14, color: AppStyle.black),
          ),
        ),
        12.verticalSpace,
        Material(
          color: AppStyle.transparent,
          borderRadius: BorderRadius.circular(20.r),
          child: InkWell(
            onTap: _pickBackgroundImage,
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              width: double.infinity,
              height: 150.h,
              decoration: backgroundImage.isNotEmpty
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: FileImage(File(backgroundImage)),
                        fit: BoxFit.cover,
                      ),
                    )
                  : BoxDecoration(
                      color: AppStyle.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppStyle.primary.withOpacity(0.2),
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
              child: backgroundImage.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterRemix.image_add_fill,
                          color: AppStyle.primary,
                          size: 40.r,
                        ),
                        8.verticalSpace,
                        Text(
                          'Upload Background',
                          style: AppStyle.interMedium(
                            size: 14,
                            color: AppStyle.primary,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
