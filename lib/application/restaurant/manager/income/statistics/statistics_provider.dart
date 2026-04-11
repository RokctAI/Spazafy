import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/restaurant/manager/income/statistics/statistics_state.dart';
import 'package:rokctapp/application/restaurant/manager/income/statistics/statistics_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>(
      (ref) => StatisticsNotifier(managerUsersRepository),
    );
