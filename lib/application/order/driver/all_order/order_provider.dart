import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/order/driver/all_order/order_notifier.dart';
import 'package:rokctapp/application/order/driver/all_order/order_state.dart';

final orderRepository = driverOrderRepository;
final parcelRepository = driverParcelRepository;

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(orderRepository),
);
