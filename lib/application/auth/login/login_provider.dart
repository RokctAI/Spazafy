import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/services/utils/sync_provider.dart';
import 'login_notifier.dart';
import 'login_state.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(
        authRepository,
        settingsRepository,
        userRepository,
        ref.watch(backgroundSyncServiceProvider),
        ref.watch(appDatabaseProvider),
      ),
    );
