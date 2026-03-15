import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'settings_notifier.dart';
import 'settings_state.dart';

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
      (ref) => SettingsNotifier(settingsRepository),
    );
