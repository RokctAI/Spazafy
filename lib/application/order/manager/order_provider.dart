import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/order_state.dart';
import 'package:rokctapp/application/order/manager/order_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final orderProvider =
    StateNotifierProvider.autoDispose<OrderNotifier, OrderState>(
      (ref) => OrderNotifier(managerOrdersRepository),
    );
