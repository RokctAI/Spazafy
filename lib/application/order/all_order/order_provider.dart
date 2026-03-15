import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'order_notifier.dart';
import 'order_state.dart';

final driverOrderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ordersRepository),
);
