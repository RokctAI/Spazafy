import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/currencies.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'currency_state.dart';

class CurrencyNotifier extends StateNotifier<CurrencyState> {
  final CurrenciesRepositoryFacade _currenciesRepository;

  CurrencyNotifier(this._currenciesRepository) : super(const CurrencyState());

  Future<void> fetchCurrency(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    final response = await _currenciesRepository.getCurrencies();
    response.when(
      success: (data) async {
        CurrencyData currencyData =
            LocalStorage.getSelectedCurrency() ?? CurrencyData();

        for (int i = 0; i < data.data!.length; i++) {
          if (data.data![i].id == currencyData.id) {
            state = state.copyWith(index: i);
            LocalStorage.setSelectedCurrency(data.data![i]);
            break;
          } else {
            LocalStorage.setSelectedCurrency(data.data![0]);
          }
        }

        state = state.copyWith(isLoading: false, list: data.data ?? []);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  void change(int index) {
    LocalStorage.setSelectedCurrency(state.list[index]);
    state = state.copyWith(index: index);
  }
}
