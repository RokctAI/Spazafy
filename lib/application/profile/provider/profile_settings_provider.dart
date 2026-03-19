import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/profile/notifier/profile_settings_notifier.dart';
import 'package:rokctapp/application/profile/state/profile_settings_state.dart';

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
      (ref) => ProfileSettingsNotifier(userRepository),
    );
