import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';

final userRepository = driverUserRepository;
final settingsRepository = driverSettingsRepository;
import 'package:rokctapp/application/profile/driver/notifier/profile_settings_notifier.dart';
import 'package:rokctapp/application/profile/driver/state/profile_settings_state.dart';

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
      (ref) => ProfileSettingsNotifier(userRepository),
    );
