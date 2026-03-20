import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';

final userRepository = driverUserRepository;
import 'package:rokctapp/application/profile/driver/notifier/profile_edit_notifier.dart';
import 'package:rokctapp/application/profile/driver/state/profile_edit_state.dart';

final profileEditProvider =
    StateNotifierProvider<ProfileEditNotifier, ProfileEditState>(
      (ref) => ProfileEditNotifier(userRepository),
    );
