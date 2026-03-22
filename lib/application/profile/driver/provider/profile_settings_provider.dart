import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/profile/driver/notifier/profile_settings_notifier.dart';
import 'package:rokctapp/application/profile/driver/state/profile_settings_state.dart';

final userRepository = driverUserRepository;
final settingsRepository = driverSettingsRepository;

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
      (ref) => ProfileSettingsNotifier(userRepository),
    );
