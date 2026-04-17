import 'package:rokctapp/infrastructure/models/data/product_data.dart' hide Group;

import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:rokctapp/infrastructure/services/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/modal_wrap.dart';
import 'package:rokctapp/presentation/components/text_fields/manager/underlined_text_field.dart';

import 'package:rokctapp/infrastructure/models/data/group.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart' as help;
import 'package:rokctapp/application/main/manager/foods/extras/details/new_item/create_new_group_item_provider.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/extras_group_details_provider.dart';

class CreateNewGroupItemModal extends StatefulWidget {
  final Group group;

  const CreateNewGroupItemModal({super.key, required this.group});

  @override
  State<CreateNewGroupItemModal> createState() =>
      _CreateNewGroupItemModalState();
}

class _CreateNewGroupItemModalState extends State<CreateNewGroupItemModal> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(createNewGroupItemProvider);
            final event = ref.read(createNewGroupItemProvider.notifier);
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ModalDrag(),
                  TitleAndIcon(
                    title: help.AppHelpers.getTranslation(TrKeys.addNewExtras),
                  ),
                  24.verticalSpace,
                  UnderlinedTextField(
                    label: help.AppHelpers.getTranslation(TrKeys.title),
                    inputType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onChanged: event.setTitle,
                    validator: AppValidators.isNotEmptyValidator,
                  ),
                  36.verticalSpace,
                  CustomButton(
                    title: help.AppHelpers.getTranslation(TrKeys.save),
                    isLoading: state.isLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        event.createExtrasItem(
                          context,
                          groupId: widget.group.id,
                          success: () {
                            ref
                                .read(extrasGroupDetailsProvider.notifier)
                                .fetchGroupExtras(groupId: widget.group.id);
                            context.router.maybePop();
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
