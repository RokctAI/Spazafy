import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order_time/time_notifier.dart';
import 'package:rokctapp/application/order_time/time_state.dart';

final timeProvider = StateNotifierProvider<TimeNotifier, TimeState>(
  (ref) => TimeNotifier(),
);
