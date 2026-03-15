import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'canceled_order_state.dart';

class CanceledOrderNotifier extends StateNotifier<CanceledOrderState> {
  CanceledOrderNotifier() : super(const CanceledOrderState());

  int canceledOrder = 0;

  Future<void> fetchCanceledOrdersPage(
    BuildContext context,
    RefreshController controller, {
    bool isRefresh = false,
  }) async {
    final connected = await AppConnectivity.connectivity();

    if (connected) {
      if (isRefresh) {
        canceledOrder = 1;
        state = state.copyWith(isLoading: true);
      }
      final response = await orderRepository.getHistoryOrders(
        isRefresh ? 1 : ++canceledOrder,
        status: ["canceled"],
      );
      response.when(
        success: (data) {
          if (isRefresh) {
            state = state.copyWith(canceledOrders: data, isLoading: false);
            controller.refreshCompleted();
          } else {
            if (data.isNotEmpty) {
              List<OrderDetailData> list = List.from(state.canceledOrders);
              list.addAll(data);
              state = state.copyWith(canceledOrders: list, isLoading: false);
              controller.loadComplete();
            } else {
              canceledOrder--;
              state = state.copyWith(isLoading: false);
              controller.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            canceledOrder--;
            state = state.copyWith(isLoading: false);
            controller.loadFailed();
          } else {
            state = state.copyWith(isLoading: false);
            controller.refreshFailed();
          }
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(failure),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
      state = state.copyWith(isLoading: false);
    }
  }
}




