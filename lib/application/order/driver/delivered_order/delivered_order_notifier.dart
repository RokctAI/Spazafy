import 'package:rokctapp/application/order/driver/delivered_order/delivered_order_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/data/driver/order_detail.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/app_helpers.dart';

final orderRepository = driverOrderRepository;

class DeliveredOrderNotifier extends StateNotifier<DeliveredOrderState> {
  DeliveredOrderNotifier() : super(const DeliveredOrderState());

  int deliveredOrder = 0;

  Future<void> fetchDeliveredOrdersPage(
    BuildContext context,
    RefreshController controller, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      deliveredOrder = 1;
      state = state.copyWith(isLoading: true);
    }
    final response = await orderRepository.getHistoryOrders(
      isRefresh ? 1 : ++deliveredOrder,
      status: ["delivered"],
    );
    response.when(
      success: (data) {
        if (isRefresh) {
          state = state.copyWith(deliveredOrders: data, isLoading: false);
          controller.refreshCompleted();
        } else {
          if (data.isNotEmpty) {
            List<OrderDetailData> list = List.from(state.deliveredOrders);
            list.addAll(data);
            state = state.copyWith(deliveredOrders: list, isLoading: false);
            controller.loadComplete();
          } else {
            deliveredOrder--;
            controller.loadNoData();
          }
        }
      },
      failure: (failure, status) {
        if (!isRefresh) {
          deliveredOrder--;
          controller.loadFailed();
          state = state.copyWith(isLoading: false);
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
  }
}
