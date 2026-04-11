import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/setting/setting_notifier.dart';
import 'package:rokctapp/application/setting/setting_state.dart';

final settingProvider = StateNotifierProvider<SettingNotifier, SettingState>(
  (ref) => SettingNotifier(settingsRepository, userRepository),
);
