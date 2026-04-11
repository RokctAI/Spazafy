import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order_details/manager/order_details_state.dart';
import 'package:rokctapp/application/order_details/manager/order_details_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final orderDetailsProvider =
    StateNotifierProvider<OrderDetailsNotifier, OrderDetailsState>(
      (ref) => OrderDetailsNotifier(managerOrdersRepository),
    );
