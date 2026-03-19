import 'package:rokctapp/application/order/driver/delivered_order/delivered_order_notifier.dart';
import 'package:rokctapp/application/order/driver/delivered_order/delivered_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveredOrderProvider =
    StateNotifierProvider<DeliveredOrderNotifier, DeliveredOrderState>(
      (ref) => DeliveredOrderNotifier(),
    );
