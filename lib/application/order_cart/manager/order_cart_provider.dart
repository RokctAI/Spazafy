import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order_cart/manager/order_cart_state.dart';
import 'package:rokctapp/application/order_cart/manager/order_cart_notifier.dart';

final orderCartProvider =
    StateNotifierProvider<OrderCartNotifier, OrderCartState>(
      (ref) => OrderCartNotifier(),
    );
