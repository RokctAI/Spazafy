import 'package:rokctapp/infrastructure/services/constants/enums.dart'
    hide SnackBarType, OrderStatus, ExtrasType;
import 'package:rokctapp/infrastructure/models/data/manager/product_data.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/edit/stocks/edit_food_addons_modal.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/edit/stocks/edit_group_extras_modal.dart';
import 'package:rokctapp/presentation/components/buttons/manager/custom_button.dart';
import 'package:rokctapp/presentation/components/helper/keyboard_disable.dart';
import 'package:rokctapp/presentation/components/list_items/editable_food_stock_item.dart';
import 'package:rokctapp/presentation/components/extras/manager/extras_item.dart';

import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class EditFoodStocksBody extends ConsumerStatefulWidget {
  final ProductData product;

  const EditFoodStocksBody({super.key, required this.product});

  @override
  ConsumerState<EditFoodStocksBody> createState() => _EditFoodStocksBodyState();
}

class _EditFoodStocksBodyState extends ConsumerState<EditFoodStocksBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(editFoodStocksProvider.notifier)
          .setInitialStocks(widget.product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDisable(
      child: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(editFoodStocksProvider);
          final event = ref.read(editFoodStocksProvider.notifier);
          final foodsEvent = ref.read(foodsProvider.notifier);
          final categoriesState = ref.watch(allCategoriesProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              SizedBox(
                height: 60.r,
                child: ListView.builder(
                  itemCount: state.groups.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: REdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => ExtrasItem(
                    extras: state.groups[index],
                    onTap: () {
                      event.toggleCheckedGroup(index);
                      AppHelpers.showCustomModalBottomSheet(
                        paddingTop: MediaQuery.paddingOf(context).top + 150,
                        context: context,
                        radius: 12,
                        modal: EditGroupExtrasModal(groupIndex: index),
                        isDarkMode: false,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView.builder(
                    itemCount: state.stocks.length,
                    shrinkWrap: true,
                    padding: REdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return EditableFoodStockItem(
                        key: UniqueKey(),
                        isDeletable: index != 0,
                        stock: state.stocks[index],
                        onDeleteStock: () => event.deleteStock(index),
                        onPriceChange: (value) =>
                            event.setPrice(value: value, index: index),
                        onQuantityChange: (value) =>
                            event.setQuantity(value: value, index: index),
                        onAddonTap: (context) =>
                            AppHelpers.showCustomModalBottomSheet(
                              paddingTop:
                                  MediaQuery.paddingOf(context).top + 150,
                              context: context,
                              radius: 12,
                              modal: EditFoodAddonsModal(
                                stock: state.stocks[index],
                                onSave: (addons) =>
                                    event.setStockAddons(addons, index),
                              ),
                              isDarkMode: true,
                            ),
                        onSkuChange: (value) =>
                            event.setSku(value: value, index: index),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  title: AppHelpers.getTranslation(TrKeys.save),
                  isLoading: state.isSaving,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      event.updateStocks(
                        context,
                        uuid: widget.product.uuid,
                        updated: () {
                          foodsEvent.fetchProducts(
                            isRefresh: true,
                            categoryId: categoriesState.activeIndex == 1
                                ? null
                                : categoriesState
                                      .categories[categoriesState.activeIndex -
                                          2]
                                      .id,
                          );
                          AppHelpers.showCheckTopSnackBar(
                            context,
                            type: SnackBarType.success,
                            text: AppHelpers.getTranslation(
                              TrKeys.successfullyUpdated,
                            ),
                          );
                          context.router.maybePop();
                        },
                        failed: () => AppHelpers.showCheckTopSnackBar(
                          context,
                          type: SnackBarType.error,
                          text: AppHelpers.getTranslation(TrKeys.updateFailed),
                        ),
                      );
                    }
                  },
                ),
              ),
              20.verticalSpace,
            ],
          );
        },
      ),
    );
  }
}

