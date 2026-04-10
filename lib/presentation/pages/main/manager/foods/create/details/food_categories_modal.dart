
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add_category_modal.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_wrap.dart';
import 'package:rokctapp/presentation/components/list_items/manager/food_category_item.dart';



import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';

class FoodCategoriesModal extends ConsumerStatefulWidget {
  final bool isSubCategory;
  final String? type;

  const FoodCategoriesModal({super.key, this.isSubCategory = false, this.type});

  @override
  ConsumerState<FoodCategoriesModal> createState() =>
      _FoodCategoriesModalState();
}

class _FoodCategoriesModalState extends ConsumerState<FoodCategoriesModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isSubCategory) {
        ref.read(allCategoriesProvider.notifier).updateCategoriesSub(context);
      } else {
        ref
            .read(allCategoriesProvider.notifier)
            .updateCategories(context, type: widget.type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Column(
        children: [
          const ModalDrag(),
          if (!widget.isSubCategory)
            GestureDetector(
              onTap: () => help.AppHelpers.showCustomModalBottomSheet(
                context: context,
                paddingTop: 100,
                modal: const AddCategoryModal(),
                isDarkMode: false,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FlutterRemix.play_list_add_line,
                    color: AppStyle.blue,
                    size: 18.r,
                  ),
                  10.horizontalSpace,
                  Text(
                    help.AppHelpers.getTranslation(TrKeys.addNewCategory),
                    style: AppStyle.interSemi(
                      size: 14,
                      color: AppStyle.blue,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          16.verticalSpace,
          Divider(color: AppStyle.toggleColor, height: 1.r, thickness: 1.r),
          24.verticalSpace,
          Expanded(
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    TitleAndIcon(
                      title: help.AppHelpers.getTranslation(TrKeys.categories),
                      titleSize: 16,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(allCategoriesProvider);
                        final isCombo = widget.type == 'combo';
                        final currentCategories = widget.isSubCategory
                            ? state.categoriesSub
                            : (isCombo
                                  ? state.comboCategories
                                  : state.categories);
                        final currentActiveIndex = widget.isSubCategory
                            ? state.activeSubIndex
                            : (isCombo
                                  ? state.activeComboIndex
                                  : state.activeIndex);

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: currentCategories.length,
                          itemBuilder: (context, index) {
                            return FoodCategoryItem(
                              category: currentCategories[index],
                              onTap: () {
                                if (widget.isSubCategory) {
                                  ref
                                      .read(allCategoriesProvider.notifier)
                                      .setActiveIndexSub(index);
                                } else {
                                  ref
                                      .read(allCategoriesProvider.notifier)
                                      .setActiveIndex(index, isCombo: isCombo);
                                }
                                Navigator.pop(context);
                              },
                              isSelected: currentActiveIndex == index,
                              onDelete:
                                  currentCategories[index].shopId ==
                                      LocalStorage.getShop()?.id
                                  ? () {
                                      ref
                                          .read(allCategoriesProvider.notifier)
                                          .deleteCategories(
                                            currentCategories[index],
                                          );
                                    }
                                  : null,
                            );
                          },
                        );
                      },
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
