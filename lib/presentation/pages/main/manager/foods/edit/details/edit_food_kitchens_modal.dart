import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/foods/manager/edit/details/kitchen/edit_food_kitchens_provider.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_wrap.dart';
import 'package:rokctapp/presentation/components/list_items/manager/food_kitchen_item.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';

class EditFoodKitchensModal extends ConsumerStatefulWidget {
  const EditFoodKitchensModal({super.key});

  @override
  ConsumerState<EditFoodKitchensModal> createState() =>
      _EditFoodKitchensModalState();
}

class _EditFoodKitchensModalState extends ConsumerState<EditFoodKitchensModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(editFoodKitchensProvider.notifier).fetchKitchens(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModalDrag(),
            TitleAndIcon(
              title: help.AppHelpers.getTranslation(TrKeys.kitchens),
              titleSize: 16,
            ),
            24.verticalSpace,
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(editFoodKitchensProvider);
                final event = ref.read(editFoodKitchensProvider.notifier);
                return state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3.r,
                          color: AppStyle.primary,
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.kitchens.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => FoodKitchenItem(
                            kitchen: state.kitchens[index],
                            onTap: () => event.setActiveIndex(index),
                            isSelected: state.activeIndex == index,
                          ),
                        ),
                      );
              },
            ),
            24.verticalSpace,
            CustomButton(
              title: help.AppHelpers.getTranslation(TrKeys.close),
              onPressed: context.maybePop,
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
