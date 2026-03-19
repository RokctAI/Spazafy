import 'package:rokctapp/application/order/canceled_order/canceled_order_notifier.dart';
import 'package:rokctapp/application/order/canceled_order/canceled_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final canceledOrderProvider =
    StateNotifierProvider<CanceledOrderNotifier, CanceledOrderState>(
      (ref) => CanceledOrderNotifier(),
    );
