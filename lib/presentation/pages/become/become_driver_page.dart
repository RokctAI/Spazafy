import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_route/annotations.dart';

import 'package:rokctapp/application/profile/profile_provider.dart';
import 'package:rokctapp/application/profile/profile_edit_notifier.dart';
import 'package:rokctapp/application/profile/profile_image_notifier.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/presentation/components/buttons/custom_button.dart';
import 'package:rokctapp/presentation/components/loading.dart';
import 'package:rokctapp/presentation/components/app_bars/common_app_bar.dart';
import 'package:rokctapp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:rokctapp/presentation/components/helper/keyboard_disable.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';

@RoutePage()
class BecomeDriverPage extends ConsumerStatefulWidget {
  const BecomeDriverPage({super.key});

  @override
  ConsumerState<BecomeDriverPage> createState() => _BecomeDriverPageState();
}

class _BecomeDriverPageState extends ConsumerState<BecomeDriverPage> {
  late TextEditingController brand;
  late TextEditingController model;
  late TextEditingController number;
  late TextEditingController color;

  late TextEditingController height;
  late TextEditingController weight;
  late TextEditingController length;
  late TextEditingController width;
  String? dropdownValue;
  String? imagePath;

  final List<String> items = [
    TrKeys.benzine,
    TrKeys.diesel,
    TrKeys.gas,
    TrKeys.motorbike,
    TrKeys.bike,
    TrKeys.foot,
  ];

  @override
  void initState() {
    brand = TextEditingController();
    model = TextEditingController();
    number = TextEditingController();
    color = TextEditingController();
    height = TextEditingController();
    weight = TextEditingController();
    length = TextEditingController();
    width = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchRequestResponse(context: context);
    });
    super.initState();
  }

  @override
  void dispose() {
    brand.dispose();
    model.dispose();
    number.dispose();
    color.dispose();
    height.dispose();
    weight.dispose();
    length.dispose();
    width.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final stateImage = ref.watch(profileImageProvider);
    final event = ref.read(profileEditProvider.notifier);
    final eventImage = ref.read(profileImageProvider.notifier);

    return KeyboardDisable(
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                AppHelpers.getTranslation(TrKeys.becomeDriver),
                style: AppStyle.interSemi(size: 18, color: AppStyle.black),
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Loading()
                  : _buildContent(state, stateImage, event, eventImage),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(state, stateImage, event, eventImage) {
    // If already a driver
    if (state.userData?.role == 'deliveryman') {
      return Center(
        child: Text(
          AppHelpers.getTranslation(TrKeys.alreadyADriver),
          style: AppStyle.interSemi(size: 16),
        ),
      );
    }

    // If request is pending
    if (state.requestData?.status == 'pending') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/processing.json'),
          24.verticalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.yourRequest),
            style: AppStyle.interNormal(size: 18, color: AppStyle.black),
          ),
          const Spacer(),
          Padding(
            padding: REdgeInsets.all(24),
            child: CustomButton(
              title: AppHelpers.getTranslation(TrKeys.logout),
              onPressed: () => AppHelpers.showCustomModalBottomSheet(
                context: context,
                modal:
                    const AuthRoute(), // Assuming AuthRoute is the login flow
                isDarkMode: LocalStorage.getAppThemeMode(),
              ),
            ),
          ),
        ],
      );
    }

    // Show form
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          if (state.requestData?.status == "canceled")
            Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Text(
                state.requestData?.statusNote ?? '',
                style: AppStyle.interNormal(size: 16, color: AppStyle.black),
                textAlign: TextAlign.center,
              ),
            ),
          24.verticalSpace,
          DropdownButtonFormField<String>(
            value: dropdownValue,
            items: items.map((String key) {
              return DropdownMenuItem(
                value: key,
                child: Text(AppHelpers.getTranslation(key)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: AppHelpers.getTranslation(
                TrKeys.typeTechnique,
              ).toUpperCase(),
              labelStyle: AppStyle.interNormal(
                size: 14.sp,
                color: AppStyle.black,
              ),
              contentPadding: REdgeInsets.symmetric(horizontal: 0, vertical: 8),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppStyle.differBorderColor),
              ),
              focusedBorder: const UnderlineInputBorder(),
            ),
          ),
          24.verticalSpace,
          OutlinedBorderTextField(
            label: AppHelpers.getTranslation(TrKeys.carBrand),
            textController: brand,
          ),
          24.verticalSpace,
          OutlinedBorderTextField(
            label: AppHelpers.getTranslation(TrKeys.carModels),
            textController: model,
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.stateNumber),
                  textController: number,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                flex: 1,
                child: OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.color),
                  textController: color,
                ),
              ),
            ],
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.height),
                  textController: height,
                  inputType: TextInputType.number,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                flex: 1,
                child: OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.weight),
                  textController: weight,
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.length),
                  textController: length,
                  inputType: TextInputType.number,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                flex: 1,
                child: OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.width),
                  textController: width,
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          24.verticalSpace,
          InkWell(
            onTap: () async {
              final XFile? pickedFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile != null) {
                setState(() => imagePath = pickedFile.path);
                eventImage.editCarImage(
                  context: context,
                  path: pickedFile.path,
                );
              }
            },
            child: Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppStyle.hintColor),
                color: AppStyle.white,
              ),
              child: stateImage.carImageUrl == null
                  ? (imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FlutterRemix.upload_cloud_2_line,
                                size: 36.sp,
                                color: AppStyle.primary,
                              ),
                              16.verticalSpace,
                              Text(
                                AppHelpers.getTranslation(TrKeys.carPicture),
                                style: AppStyle.interSemi(size: 14.sp),
                              ),
                              Text(
                                AppHelpers.getTranslation(
                                  TrKeys.recommendedSize,
                                ),
                                style: AppStyle.interRegular(size: 14.sp),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ))
                  : CommonImage(
                      imageUrl: stateImage.carImageUrl,
                      height: 160,
                      radius: 20,
                    ),
            ),
          ),
          32.verticalSpace,
          CustomButton(
            title: AppHelpers.getTranslation(TrKeys.save),
            isLoading: state.isSaveLoading,
            onPressed: () {
              if (_validate()) {
                event.createCarInfo(
                  context: context,
                  type: dropdownValue!,
                  brand: brand.text,
                  model: model.text,
                  number: number.text,
                  color: color.text,
                  imageUrl: stateImage.carImageUrl,
                  height: height.text,
                  weight: weight.text,
                  length: length.text,
                  width: width.text,
                  updated: () {
                    ref
                        .read(profileProvider.notifier)
                        .fetchRequestResponse(context: context);
                  },
                );
              }
            },
          ),
          32.verticalSpace,
        ],
      ),
    );
  }

  bool _validate() {
    return dropdownValue != null &&
        brand.text.isNotEmpty &&
        model.text.isNotEmpty &&
        number.text.isNotEmpty &&
        color.text.isNotEmpty &&
        height.text.isNotEmpty &&
        weight.text.isNotEmpty &&
        width.text.isNotEmpty &&
        length.text.isNotEmpty;
  }
}
