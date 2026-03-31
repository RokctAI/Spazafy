import 'package:rokctapp/infrastructure/models/data/manager/stock.dart';
import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/models/models_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart'
    as mgr
    hide SnackBarType;
import 'create_addon_state.dart';

class CreateAddonNotifier extends StateNotifier<CreateAddonState> {
  final ProductsInterface _productsRepository;
  String _title = '';
  String _description = '';
  String _tax = '';
  String _barcode = '';
  String _price = '';
  String _quantity = '';
  bool _active = true;

  CreateAddonNotifier(this._productsRepository)
    : super(const CreateAddonState());

  void setQuantity(String value) {
    _quantity = value.trim();
  }

  void setPrice(String value) {
    _price = value.trim();
  }

  void updateAddonInfo() {
    _title = '';
    _description = '';
    _tax = '';
    _barcode = '';
    _active = true;
  }

  void setBarcode(String value) {
    _barcode = value.trim();
  }

  Future<void> createAddon(
    BuildContext context, {
    String? unitId,
    VoidCallback? created,
    VoidCallback? failed,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _productsRepository.createProduct(
      title: _title,
      description: _description,
      tax: _tax,
      minQty: '1',
      maxQty: '10000',
      interval: "1",
      active: _active,
      qrcode: _barcode,
      unitId: unitId,
      isAddon: true,
    );
    response.when(
      success: (data) async {
        final stockResponse = await _productsRepository.updateStocks(
          deletedStocks: [],
          stocks: [
            Stock(
              quantity: int.tryParse(_quantity),
              price: num.tryParse(_price),
              sku: _barcode,
            ),
          ],
          uuid: data.data?.uuid,
          isAddon: true,
        );
        stockResponse.when(
          success: (stockData) {
            created?.call();
            state = state.copyWith(isLoading: false);
          },
          failure: (stockFail, status) {
            debugPrint('===> create addon stock fail $stockFail');
            failed?.call();
            state = state.copyWith(isLoading: false);
            mgr.AppHelpers.showCheckTopSnackBar(context, 
              context,
              text: stockFail,
              type: SnackBarType.error,
            );
          },
        );
      },
      failure: (fail, status) {
        debugPrint('===> create addon fail $fail');
        state = state.copyWith(isLoading: false);
        mgr.AppHelpers.showCheckTopSnackBar(context, 
          context,
          text: fail,
          type: SnackBarType.error,
        );
        failed?.call();
      },
    );
  }

  void setActive(bool? value) {
    _active = value ?? false;
  }

  void setTax(String value) {
    _tax = value.trim();
  }

  void setDescription(String value) {
    _description = value.trim();
  }

  void setTitle(String value) {
    _title = value.trim();
  }
}
