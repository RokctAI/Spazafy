import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/order/order_notifier.dart';
import 'package:rokctapp/application/order/order_state.dart';

final orderProvider =
    StateNotifierProvider.autoDispose<OrderNotifier, OrderState>(
      (ref) => OrderNotifier(
        ordersRepository,
        shopsRepository,
        paymentsRepository,
        cartRepository,
        drawRepository,
      ),
    );
