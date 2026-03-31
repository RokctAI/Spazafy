import 'package:rokctapp/infrastructure/services/utils/navigation_extension.dart';
import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:rokctapp/infrastructure/models/data/manager/group.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:rokctapp/infrastructure/services/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/components/components_manager.dart';
import 'package:rokctapp/application/providers_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';

class CreateExtrasGroupModal extends StatefulWidget {
  const CreateExtrasGroupModal({super.key});

  @override
  State<CreateExtrasGroupModal> createState() => _CreateExtrasGroupModalState();
}

class _CreateExtrasGroupModalState extends State<CreateExtrasGroupModal> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(createExtrasGroupProvider);
            final event = ref.read(createExtrasGroupProvider.notifier);
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ModalDrag(),
                  TitleAndIcon(
                    title: help.AppHelpers.getTranslation(
                      TrKeys.addNewExtrasGroup,
                    ),
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
                        event.createExtrasGroup(
                          context,
                          success: () {
                            ref.read(extrasProvider.notifier).fetchGroups();
                            context.popRoute();
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
