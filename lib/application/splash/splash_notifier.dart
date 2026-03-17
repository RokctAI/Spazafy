import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/settings.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'splash_state.dart';

class SplashNotifier extends StateNotifier<SplashState> {
  final SettingsRepositoryFacade _settingsRepository;

  SplashNotifier(this._settingsRepository) : super(const SplashState());

  Future<void> getToken(
    BuildContext context, {
    VoidCallback? goMain,
    VoidCallback? goLogin,
    VoidCallback? goNoInternet,
  }) async {
    // This will automatically show dialog if no connection
    final connect = await AppConnectivity.connectivity();

    if (connect) {
      if (LocalStorage.getSettingsFetched()) {
        final response = await _settingsRepository.getGlobalSettings();
        response.when(
          success: (data) {
            LocalStorage.setSettingsList(data.data ?? []);
            LocalStorage.setSettingsFetched(true);
          },
          failure: (failure, status) {
            debugPrint('==> error with settings fetched');
          },
        );
      }

      if (LocalStorage.getToken().isEmpty) {
        goLogin?.call();
      } else {
        goMain?.call();
      }

      if (!LocalStorage.getSettingsFetched()) {
        final response = await _settingsRepository.getGlobalSettings();
        response.when(
          success: (data) {
            LocalStorage.setSettingsList(data.data ?? []);
            LocalStorage.setSettingsFetched(true);
          },
          failure: (failure, status) {
            debugPrint('==> error with settings fetched');
          },
        );
      }
    } else {
      // Offline: Allow proceeding to main page as guest if no token
      if (LocalStorage.getToken().isEmpty) {
        LocalStorage.setIsGuest(true);
      }
      goMain?.call();
    }
  }

  Future<void> getTranslations(BuildContext context) async {
    // This will automatically show dialog if no connection
    final connect = await AppConnectivity.connectivityWithDialog(context);

    if (connect) {
      final response = await _settingsRepository.getMobileTranslations();
      response.when(
        success: (data) {
          LocalStorage.setTranslations(data.data);
        },
        failure: (failure, status) {
          debugPrint('==> error with fetching translations $failure');
          // Could show dialog here for API failures even with connection
          // AppHelpers.showNoConnectionDialog(context);
        },
      );
    }
    // No else block needed - dialog is automatically shown by connectivityWithDialog
  }
}
