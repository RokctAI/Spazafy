import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/sync_provider.dart';
import 'package:rokctapp/application/auth/login/login_notifier.dart';
import 'package:rokctapp/application/auth/login/login_state.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    authRepository,
    settingsRepository,
    userRepository,
    ref.watch(backgroundSyncServiceProvider),
    ref.watch(appDatabaseProvider),
  ),
);
