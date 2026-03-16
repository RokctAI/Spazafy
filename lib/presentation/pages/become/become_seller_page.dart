import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_route/annotations.dart';

import 'package:rokctapp/application/profile/profile_provider.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/components/buttons/custom_button.dart';
import 'package:rokctapp/presentation/components/loading.dart';
import 'package:rokctapp/presentation/components/app_bars/common_app_bar.dart';
import 'package:rokctapp/presentation/components/helper/keyboard_disable.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';

import 'widgets/address_selector.dart';
import 'widgets/background_image_picker.dart';
import 'widgets/document_upload_section.dart';
import 'widgets/logo_and_name_section.dart';
import 'widgets/processing_view.dart';
import 'widgets/shop_form_fields.dart';

@RoutePage()
class BecomeSellerPage extends ConsumerStatefulWidget {
  const BecomeSellerPage({super.key});

  @override
  ConsumerState<BecomeSellerPage> createState() => _BecomeSellerPageState();
}

class _BecomeSellerPageState extends ConsumerState<BecomeSellerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController shopNameController;
  late TextEditingController descController;
  late TextEditingController phoneController;
  late TextEditingController taxController;
  late TextEditingController deliveryTimeFromController;
  late TextEditingController deliveryTimeToController;
  late TextEditingController startPriceController;
  late TextEditingController pricePerKmController;

  String selectedDeliveryType = 'pickup';
  final List<String> deliveryTypeList = ['pickup', 'delivery', 'both'];

  @override
  void initState() {
    shopNameController = TextEditingController();
    descController = TextEditingController();
    phoneController = TextEditingController();
    taxController = TextEditingController();
    deliveryTimeFromController = TextEditingController();
    deliveryTimeToController = TextEditingController();
    startPriceController = TextEditingController();
    pricePerKmController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    shopNameController.dispose();
    descController.dispose();
    phoneController.dispose();
    taxController.dispose();
    deliveryTimeFromController.dispose();
    deliveryTimeToController.dispose();
    startPriceController.dispose();
    pricePerKmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final event = ref.read(profileProvider.notifier);

    return KeyboardDisable(
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                AppHelpers.getTranslation(TrKeys.becomeSeller),
                style: AppStyle.interSemi(size: 18, color: AppStyle.black),
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Loading()
                  : _buildContent(state, event),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(state, event) {
    // If shop already exists and is approved
    if (state.userData?.shop != null &&
        (state.userData?.shop?.status == 'approved' ||
            state.userData?.shop?.status == 'active')) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.alreadyASeller),
                style: AppStyle.interSemi(size: 18),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              // Option to go to admin if they want to manage shop?
              // For now just show message
            ],
          ),
        ),
      );
    }

    // If shop is pending
    if (state.userData?.shop != null &&
        (state.userData?.shop?.status == 'new' ||
            state.userData?.shop?.status == 'pending')) {
      return const ProcessingView();
    }

    // Show form
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,
            LogoAndNameSection(
              logoImage: state.logoImage,
              shopNameController: shopNameController,
              event: event,
            ),
            24.verticalSpace,
            BackgroundImagePicker(backgroundImage: state.bgImage, event: event),
            24.verticalSpace,
            ShopFormFields(
              descController: descController,
              phoneController: phoneController,
              taxController: taxController,
              deliveryTimeFromController: deliveryTimeFromController,
              deliveryTimeToController: deliveryTimeToController,
              startPriceController: startPriceController,
              pricePerKmController: pricePerKmController,
              selectedDeliveryType: selectedDeliveryType,
              deliveryTypeList: deliveryTypeList,
              onDeliveryTypeChanged: (val) =>
                  setState(() => selectedDeliveryType = val!),
            ),
            24.verticalSpace,
            AddressSelector(
              addressModel: state.addressModel,
              onAddressSelected: (addr) => event.setAddress(addr),
            ),
            24.verticalSpace,
            DocumentUploadSection(filePaths: state.filepath, event: event),
            32.verticalSpace,
            CustomButton(
              title: AppHelpers.getTranslation(TrKeys.save),
              isLoading: state.isSaveLoading,
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    state.addressModel != null) {
                  event.createShop(
                    context: context,
                    tax: taxController.text,
                    deliveryTo: deliveryTimeToController.text,
                    deliveryFrom: deliveryTimeFromController.text,
                    phone: phoneController.text,
                    startPrice: startPriceController.text,
                    name: shopNameController.text,
                    desc: descController.text,
                    perKm: pricePerKmController.text,
                    address: state.addressModel!,
                    deliveryType: selectedDeliveryType,
                    categoryId:
                        '1', // Default or select? Manager used specific logic
                  );
                } else if (state.addressModel == null) {
                  AppHelpers.showCheckTopSnackBar(
                    context,
                    'Please select address',
                  );
                }
              },
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
