import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/profile/driver/notifier/profile_image_notifier.dart';
import 'package:rokctapp/application/profile/driver/state/profile_image_state.dart';

final userRepository = driverUserRepository;
final settingsRepository = driverSettingsRepository;

final profileImageProvider =
    StateNotifierProvider<ProfileImageNotifier, ProfileImageState>(
      (ref) => ProfileImageNotifier(userRepository, settingsRepository),
    );
