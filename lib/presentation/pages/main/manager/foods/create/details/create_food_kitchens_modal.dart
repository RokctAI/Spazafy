import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/application/foods/manager/create/details/kitchens/create_food_kitchens_provider.dart';

import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_wrap.dart';
import 'package:rokctapp/presentation/components/list_items/manager/food_kitchen_item.dart';

class CreateFoodKitchensModal extends ConsumerStatefulWidget {
  const CreateFoodKitchensModal({super.key});

  @override
  ConsumerState<CreateFoodKitchensModal> createState() =>
      _CreateFoodKitchensModalState();
}

class _CreateFoodKitchensModalState
    extends ConsumerState<CreateFoodKitchensModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>
          ref.read(createFoodKitchensProvider.notifier).fetchKitchens(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const ModalDrag(),
            TitleAndIcon(
              title: help.AppHelpers.getTranslation(TrKeys.kitchens),
              titleSize: 16,
            ),
            24.verticalSpace,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(createFoodKitchensProvider);
                  final event = ref.read(createFoodKitchensProvider.notifier);
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: state.kitchens.length,
                    itemBuilder: (context, index) => FoodKitchenItem(
                      kitchen: state.kitchens[index],
                      onTap: () => event.setActiveIndex(index),
                      isSelected: state.activeIndex == index,
                    ),
                  );
                },
              ),
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
