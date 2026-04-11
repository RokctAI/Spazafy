import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/help/help_notifier.dart';
import 'package:rokctapp/application/help/help_state.dart';

final helpProvider = StateNotifierProvider<HelpNotifier, HelpState>(
  (ref) => HelpNotifier(settingsRepository),
);
