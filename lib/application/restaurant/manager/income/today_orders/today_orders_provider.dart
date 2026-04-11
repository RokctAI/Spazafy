import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/restaurant/manager/income/today_orders/today_orders_state.dart';
import 'package:rokctapp/application/restaurant/manager/income/today_orders/today_orders_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final todayOrdersProvider =
    StateNotifierProvider<TodayOrdersNotifier, TodayOrdersState>(
      (ref) => TodayOrdersNotifier(managerOrdersRepository),
    );
