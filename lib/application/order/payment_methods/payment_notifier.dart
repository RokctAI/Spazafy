import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/domain/interface/payments.dart';
import 'payment_state.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentsFacade _paymentsRepository;

  PaymentNotifier(this._paymentsRepository) : super(const PaymentState());

  void change(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> fetchPayments(
    BuildContext context, {
    bool withOutCash = false,
    bool shopEnableCod = true,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isPaymentsLoading: true);
      final response = await _paymentsRepository.getPayments();
      response.when(
        success: (data) {
          List payments = [];
          if (withOutCash || !shopEnableCod) {
            payments =
                data?.data?.reversed.where((e) => e.tag != "cash").toList() ??
                    [];
          } else {
            payments = data?.data?.reversed.toList() ?? [];
          }
          state = state.copyWith(payments: payments, isPaymentsLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isPaymentsLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
