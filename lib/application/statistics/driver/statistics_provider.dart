import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'statistics_state.dart';
import 'statistics_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final userRepository = driverUserRepository;

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>(
      (ref) => StatisticsNotifier(userRepository),
    );
