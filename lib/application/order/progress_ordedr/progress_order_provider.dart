import 'package:venderfoodyman/application/order/progress_ordedr/progress_order_notifier.dart';
import 'package:venderfoodyman/application/order/progress_ordedr/progress_order_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressOrderProvider =
    StateNotifierProvider<ProgressOrderNotifier, ProgressOrderState>(
      (ref) => ProgressOrderNotifier(),
    );
