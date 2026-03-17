import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/sync_provider.dart';

import 'register_notifier.dart';
import 'register_state.dart';

final registerProvider =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(
    authRepository,
    userRepository,
    ref.watch(backgroundSyncServiceProvider),
  ),
);
