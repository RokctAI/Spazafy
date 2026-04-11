import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/orders_list/orders_list_notifier.dart';
import 'package:rokctapp/application/orders_list/orders_list_state.dart';

final ordersListProvider =
    StateNotifierProvider<OrdersListNotifier, OrdersListState>(
      (ref) => OrdersListNotifier(ordersRepository),
    );
