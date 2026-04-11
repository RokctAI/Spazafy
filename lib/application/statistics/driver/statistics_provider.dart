import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/statistics/driver/statistics_state.dart';
import 'package:rokctapp/application/statistics/driver/statistics_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final userRepository = driverUserRepository;

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>(
      (ref) => StatisticsNotifier(userRepository),
    );
