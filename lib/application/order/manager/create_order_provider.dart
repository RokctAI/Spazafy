import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/create_order_state.dart';
import 'package:rokctapp/application/order/manager/create_order_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final createOrderProvider =
    StateNotifierProvider<CreateOrderNotifier, CreateOrderState>(
      (ref) => CreateOrderNotifier(managerOrdersRepository),
    );
