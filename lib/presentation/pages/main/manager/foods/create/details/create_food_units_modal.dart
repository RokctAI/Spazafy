import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/modal_wrap.dart';
import 'package:rokctapp/presentation/components/list_items/food_unit_item.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class CreateFoodUnitsModal extends ConsumerStatefulWidget {
  const CreateFoodUnitsModal({super.key});

  @override
  ConsumerState<CreateFoodUnitsModal> createState() =>
      _CreateFoodUnitsModalState();
}

class _CreateFoodUnitsModalState extends ConsumerState<CreateFoodUnitsModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(createFoodUnitsProvider.notifier).fetchUnits(context),
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
              title: help.AppHelpers.getTranslation(TrKeys.units),
              titleSize: 16,
            ),
            24.verticalSpace,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(createFoodUnitsProvider);
                  final event = ref.read(createFoodUnitsProvider.notifier);
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: state.units.length,
                    itemBuilder: (context, index) => FoodUnitItem(
                      unit: state.units[index],
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
