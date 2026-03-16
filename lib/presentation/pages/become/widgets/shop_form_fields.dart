import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/constants/tr_keys.dart';
import 'package:venderfoodyman/presentation/components/customer/text_fields/outline_bordered_text_field.dart';
import 'package:venderfoodyman/presentation/theme/customer/app_style.dart';

class ShopFormFields extends StatelessWidget {
  final TextEditingController descController;
  final TextEditingController phoneController;
  final TextEditingController taxController;
  final TextEditingController deliveryTimeFromController;
  final TextEditingController deliveryTimeToController;
  final TextEditingController startPriceController;
  final TextEditingController pricePerKmController;
  final String selectedDeliveryType;
  final List deliveryTypeList;
  final Function(String?) onDeliveryTypeChanged;

  const ShopFormFields({
    super.key,
    required this.descController,
    required this.phoneController,
    required this.taxController,
    required this.deliveryTimeFromController,
    required this.deliveryTimeToController,
    required this.startPriceController,
    required this.pricePerKmController,
    required this.selectedDeliveryType,
    required this.deliveryTypeList,
    required this.onDeliveryTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Basic Information'),
        12.verticalSpace,
        OutlinedBorderTextField(
          textController: descController,
          label: AppHelpers.getTranslation(TrKeys.description),
        ),
        24.verticalSpace,
        OutlinedBorderTextField(
          textController: phoneController,
          inputType: TextInputType.phone,
          label: AppHelpers.getTranslation(TrKeys.phoneNumber),
        ),
        24.verticalSpace,
        OutlinedBorderTextField(
          textController: taxController,
          inputType: TextInputType.number,
          label: AppHelpers.getTranslation(TrKeys.tax),
        ),
        24.verticalSpace,
        _buildDeliveryTypeDropdown(),
        24.verticalSpace,
        _buildSectionTitle('Delivery Settings'),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: OutlinedBorderTextField(
                textController: deliveryTimeFromController,
                inputType: TextInputType.number,
                label: AppHelpers.getTranslation(TrKeys.deliveryTimeFrom),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: OutlinedBorderTextField(
                inputType: TextInputType.number,
                textController: deliveryTimeToController,
                label: AppHelpers.getTranslation(TrKeys.deliveryTimeTo),
              ),
            ),
          ],
        ),
        24.verticalSpace,
        _buildSectionTitle('Pricing'),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: OutlinedBorderTextField(
                textController: startPriceController,
                inputType: TextInputType.number,
                label: AppHelpers.getTranslation(TrKeys.startPrice),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: OutlinedBorderTextField(
                inputType: TextInputType.number,
                textController: pricePerKmController,
                label: AppHelpers.getTranslation(TrKeys.pricePerKm),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: AppStyle.interSemi(size: 14, color: AppStyle.black),
      ),
    );
  }

  Widget _buildDeliveryTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedDeliveryType,
      items: deliveryTypeList
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.toString(),
              child: Text(e.toString()),
            ),
          )
          .toList(),
      onChanged: onDeliveryTypeChanged,
      decoration: InputDecoration(
        labelText: AppHelpers.getTranslation(TrKeys.deliveryType),
        labelStyle: AppStyle.interNormal(size: 12, color: AppStyle.black),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppStyle.differBorderColor),
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(),
      ),
    );
  }
}
