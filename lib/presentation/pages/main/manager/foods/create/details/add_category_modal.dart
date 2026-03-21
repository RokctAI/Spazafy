import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart' as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/helper/driver/modal_drag.dart';
import 'package:rokctapp/infrastructure/services/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/components_manager.dart';
import 'package:rokctapp/application/providers_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';
import 'food_categories_modal.dart';

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(addCategoryProvider);
            final event = ref.read(addCategoryProvider.notifier);
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ModalDrag(),
                  TitleAndIcon(
                    title: help.AppHelpers.getTranslation(TrKeys.addNewCategory),
                  ),
                  24.verticalSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      return UnderlinedTextField(
                        textController: ref
                            .watch(allCategoriesProvider)
                            .categorySubController,
                        label:
                            '${help.AppHelpers.getTranslation(TrKeys.subShopCategory)}*',
                        suffixIcon: Icon(
                          FlutterRemix.arrow_down_s_line,
                          color: AppStyle.blackColor,
                          size: 18.r,
                        ),
                        readOnly: true,
                        validator: AppValidators.emptyCheck,
                        onTap: () => help.AppHelpers.showCustomModalBottomSheet(
                          paddingTop: MediaQuery.paddingOf(context).top + 100.h,
                          context: context,
                          modal: const FoodCategoriesModal(isSubCategory: true),
                          isDarkMode: false,
                        ),
                      );
                    },
                  ),
                  24.verticalSpace,
                  UnderlinedTextField(
                    label: help.AppHelpers.getTranslation(TrKeys.categoryName),
                    inputType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onChanged: event.setTitle,
                    validator: AppValidators.emptyCheck,
                  ),
                  24.verticalSpace,
                  UnderlinedTextField(
                    label: help.AppHelpers.getTranslation(TrKeys.input),
                    inputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: event.setInput,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  36.verticalSpace,
                  CustomButton(
                    title: help.AppHelpers.getTranslation(TrKeys.save),
                    isLoading: state.isLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        event.createCategory(
                          context,
                          success: () {
                            ref
                                .read(allCategoriesProvider.notifier)
                                .updateCategories(context);
                            Navigator.pop(context);
                            help.AppHelpers.showAlertDialog(
                              context: context,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    help.AppHelpers.getTranslation(
                                      TrKeys.thanksForCategory,
                                    ),
                                    style: AppStyle.interNormal(),
                                    textAlign: TextAlign.center,
                                  ),
                                  16.verticalSpace,
                                  if (help.AppHelpers.getAppPhone() != null)
                                    CustomButton(
                                      title: help.AppHelpers.getAppPhone() ?? "",
                                      onPressed: () {
                                        final Uri launchUri = Uri(
                                          scheme: 'tel',
                                          path: help.AppHelpers.getAppPhone(),
                                        );
                                        launchUrl(launchUri);
                                      },
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  20.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
