import 'package:rokctapp/application/order/driver/progress_ordedr/progress_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/data/driver/order_detail.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/app_helpers.dart';

final orderRepository = driverOrderRepository;

class ProgressOrderNotifier extends StateNotifier<ProgressOrderState> {
  ProgressOrderNotifier() : super(const ProgressOrderState());

  int progressOrder = 0;

  Future<void> fetchProgressOrdersPage(
    BuildContext context,
    RefreshController controller, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      progressOrder = 1;
      state = state.copyWith(isLoading: true);
    }
    final response = await orderRepository.getProgressOrders(
      isRefresh ? 1 : ++progressOrder,
    );
    response.when(
      success: (data) {
        if (isRefresh) {
          state = state.copyWith(
            progressOrders: data.data ?? [],
            isLoading: false,
          );
          controller.refreshCompleted();
        } else {
          if (data.data?.isNotEmpty ?? false) {
            List<OrderDetailData> list = List.from(state.progressOrders);
            list.addAll(data.data ?? []);
            state = state.copyWith(progressOrders: list, isLoading: false);
            controller.loadComplete();
          } else {
            progressOrder--;
            controller.loadNoData();
            state = state.copyWith(isLoading: false);
          }
        }
      },
      failure: (failure, status) {
        if (!isRefresh) {
          progressOrder--;
          controller.loadFailed();
          state = state.copyWith(isLoading: false);
        } else {
          controller.refreshFailed();
          state = state.copyWith(isLoading: false);
        }
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(failure),
        );
      },
    );
  }
}
