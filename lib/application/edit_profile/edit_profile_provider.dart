import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/edit_profile/edit_profile_notifier.dart';
import 'package:rokctapp/application/edit_profile/edit_profile_state.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>(
      (ref) => EditProfileNotifier(userRepository, galleryRepository),
    );
