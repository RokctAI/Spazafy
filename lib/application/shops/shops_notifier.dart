import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/interface/customer/shops.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'shops_state.dart';

class ShopsNotifier extends StateNotifier<ShopsState> {
  final ShopsFacade _shopsRepository;

  ShopsNotifier(this._shopsRepository) : super(const ShopsState());

  Future<void> fetchShopDetails(BuildContext context, {String? shopId}) async {
    state = state.copyWith(isLoading: true);
    final response = await _shopsRepository.getSingleShop(shopId ?? "");
    response.when(
      success: (data) {
        state = state.copyWith(shopData: data.data, isLoading: false);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  // Manager methods
  void setLogoImage(String? path) {
    state = state.copyWith(logoImageFile: path);
  }

  void setBackgroundImage(String? path) {
    state = state.copyWith(backgroundImageFile: path);
  }

  void setOrderPayment(String? payment) {
    state = state.copyWith(orderPayment: payment);
  }
}
