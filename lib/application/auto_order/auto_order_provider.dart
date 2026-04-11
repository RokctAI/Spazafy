import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/auto_order/auto_order_state.dart';
import 'package:rokctapp/application/auto_order/auto_order_notifier.dart';

final autoOrderProvider =
    StateNotifierProvider.autoDispose<AutoOrderNotifier, AutoOrderState>(
      (ref) => AutoOrderNotifier(),
    );
