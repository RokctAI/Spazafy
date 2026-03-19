import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/profile/notifier/profile_edit_notifier.dart';
import 'package:rokctapp/application/profile/state/profile_edit_state.dart';

final profileEditProvider =
    StateNotifierProvider<ProfileEditNotifier, ProfileEditState>(
      (ref) => ProfileEditNotifier(userRepository),
    );
