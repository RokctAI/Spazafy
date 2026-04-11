import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/profile/manager/profile_notifier.dart';
import 'package:rokctapp/application/profile/manager/profile_state.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    managerSettingsRepository,
    managerUsersRepository,
    managerShopsRepository,
  ),
);
