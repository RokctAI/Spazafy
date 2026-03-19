import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/profile/notifier/profile_image_notifier.dart';
import 'package:rokctapp/application/profile/state/profile_image_state.dart';

final profileImageProvider =
    StateNotifierProvider<ProfileImageNotifier, ProfileImageState>(
      (ref) => ProfileImageNotifier(userRepository, settingsRepository),
    );
