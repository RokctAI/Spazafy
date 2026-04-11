import 'package:rokctapp/infrastructure/models/data/stock.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/buttons/manager/buttons_bouncing_effect.dart';
import 'package:rokctapp/presentation/components/text_fields/manager/underlined_text_field.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class EditableFoodStockItem extends StatelessWidget {
  final Stock stock;
  final Function(String) onPriceChange;
  final Function(String) onQuantityChange;
  final Function(String) onSkuChange;
  final Function() onDeleteStock;
  final bool isDeletable;
  final Function(BuildContext) onAddonTap;

  const EditableFoodStockItem({
    super.key,
    required this.stock,
    required this.onPriceChange,
    required this.onQuantityChange,
    required this.onDeleteStock,
    required this.isDeletable,
    required this.onAddonTap,
    required this.onSkuChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: REdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: UnderlinedTextField(
                  label: '${AppHelpers.getTranslation(TrKeys.price)}*',
                  inputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  initialText: stock.price == null
                      ? ''
                      : stock.price.toString(),
                  onChanged: onPriceChange,
                  validator: AppValidators.emptyCheck,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: UnderlinedTextField(
                  label: '${AppHelpers.getTranslation(TrKeys.quantity)}*',
                  inputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  initialText: stock.quantity == null
                      ? ''
                      : stock.quantity.toString(),
                  onChanged: onQuantityChange,
                  validator: AppValidators.emptyCheck,
                ),
              ),
              if (isDeletable)
                ButtonsBouncingEffect(
                  child: GestureDetector(
                    onTap: onDeleteStock,
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      margin: REdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: AppStyle.bgGrey,
                      ),
                      alignment: Alignment.center,
                      child: Icon(FlutterRemix.delete_bin_line, size: 18.r),
                    ),
                  ),
                ),
            ],
          ),
          4.verticalSpace,
          UnderlinedTextField(
            label: AppHelpers.getTranslation(TrKeys.sku),
            textInputAction: TextInputAction.next,
            initialText: stock.sku == null ? '' : stock.sku.toString(),
            onChanged: onSkuChange,
          ),
          if (stock.extras != null && (stock.extras?.isNotEmpty ?? false))
            ListView.builder(
              shrinkWrap: true,
              itemCount: stock.extras?.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final extras = stock.extras?[index];
                return Padding(
                  padding: REdgeInsets.only(top: 16),
                  child: UnderlinedTextField(
                    label: '${extras?.group?.translation?.title}',
                    initialText: extras?.value,
                    readOnly: true,
                    validator: AppValidators.emptyCheck,
                  ),
                );
              },
            ),
          UnderlinedTextField(
            label: '',
            initialText: AppHelpers.getTranslation(TrKeys.addons),
            readOnly: true,
            descriptionText: AppHelpers.selectedAddonsTitles(stock),
            onTap: () => onAddonTap(context),
            validator: AppValidators.emptyCheck,
          ),
        ],
      ),
    );
  }
}

