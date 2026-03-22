import 'package:rokctapp/dummy_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'splash_state.dart';


class SplashNotifier extends StateNotifier<SplashState> {
  final SettingsRepositoryFacade _settingsRepository;
  final UserRepositoryFacade _userRepository;

  SplashNotifier(this._settingsRepository, this._userRepository)
      : super(const SplashState());

  Future<void> fetchDriverDetails({required BuildContext context}) async {
    final response = await driverUserRepository.getDriverDetails();
    response.when(
      success: (data) {
        LocalStorage.setDeliveryInfo(data);
        LocalStorage.setOnline(data.data?.online ?? false);
      },
      failure: (failure, status) {
        debugPrint('==> error with fetching driver details $failure');
      },
    );
  }

  Future<void> fetchCurrencies() async {
    final response = await settingsRepository.getCurrencies();
    response.when(
      success: (data) {
        // ... handled in repository/storage usually, or here if needed
      },
      failure: (failure, status) {
        debugPrint('==> error with fetching currencies $failure');
      },
    );
  }

  Future<void> getToken(
    BuildContext context, {
    VoidCallback? goMain,
    VoidCallback? goLogin,
    VoidCallback? goNoInternet,
  }) async {
    // This will automatically show dialog if no connection
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
      final profileResponse = await _userRepository.getProfileDetails();
      profileResponse.when(
        success: (data) {
          LocalStorage.setUser(data.data);
          if (data.data?.wallet != null) {
            LocalStorage.setWallet(data.data?.wallet);
          }
          if (data.data?.role == "deliveryman") {
            fetchDriverDetails(context: context);
          } else if (data.data?.role == "seller") {
            // Manager specific splash logic if needed
          }
          goMain?.call();
        },
        failure: (failure, status) {
          if (status == 401) {
            LocalStorage.logout();
            goLogin?.call();
          } else {
            // On other errors, try to proceed offline if we have a user
            if (LocalStorage.getUser() != null) {
              goMain?.call();
            } else {
              goLogin?.call();
            }
          }
        },
      );
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
  }

  Future<void> getTranslations(BuildContext context) async {
    // This will automatically show dialog if no connection
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
    // No else block needed
  }
}
