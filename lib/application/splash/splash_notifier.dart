import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/settings.dart';
import 'package:rokctapp/domain/interface/user.dart';
import 'package:rokctapp/domain/interface/driver/interfaces.dart'
    as driver;
import 'package:rokctapp/domain/interface/manager/interfaces.dart'
    as manager;
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

import 'splash_state.dart';

class SplashNotifier extends StateNotifier<SplashState> {
  final SettingsFacade _settingsRepository;
  final UserFacade _userRepository;

  SplashNotifier(this._settingsRepository, this._userRepository)
    : super(const SplashState());

  Future<void> initApp(
    BuildContext context, {
    VoidCallback? goMain,
    VoidCallback? goLogin,
    VoidCallback? goBecome,
    VoidCallback? goNoInternet,
  }) async {
    final connect = await AppConnectivity.connectivityWithDialog(context);
    if (!connect) {
      goNoInternet?.call();
      return;
    }

    // Parallel fetch core settings & translations
    await Future.wait([
      _fetchGlobalSettings(),
      _fetchTranslations(),
      _fetchCurrencies(),
    ]);

    final token = LocalStorage.getToken();
    if (token.isEmpty) {
      // Guest mode or login
      goLogin?.call();
      return;
    }

    // Authenticated flow: Fetch profile and handle roles
    final profileResponse = await _userRepository.getProfileDetails();
    profileResponse.when(
      success: (data) async {
        final user = data.data;
        LocalStorage.setUser(user);
        if (user?.wallet != null) {
          LocalStorage.setWallet(user?.wallet);
        }

        // Role-based routing
        if (user?.role == 'deliveryman') {
          // Basic user data is enough for now,
          // specific driver data can be fetched in driver-specific screens
          // if not already in the profile response.
          goMain?.call();
        } else if (user?.role == 'seller') {
          goMain?.call();
        } else if (user?.role == 'user') {
          goMain?.call();
        } else {
          goBecome?.call();
        }
      },
      failure: (failure, status) {
        if (status == 401) {
          LocalStorage.logout();
          goLogin?.call();
        } else {
          debugPrint('==> error fetching profile details $failure');
          goMain?.call(); // Fallback
        }
      },
    );
  }

  Future<void> _fetchGlobalSettings() async {
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

  Future<void> _fetchTranslations() async {
    final response = await _settingsRepository.getMobileTranslations();
    response.when(
      success: (data) {
        LocalStorage.setTranslations(data.data);
      },
      failure: (failure, status) {
        debugPrint('==> error with fetching translations $failure');
      },
    );
  }

  Future<void> _fetchCurrencies() async {
    final response = await _settingsRepository.getCurrencies();
    response.when(
      success: (data) {
        int defaultCurrencyIndex = 0;
        final List<CurrencyData> currencies = data.data ?? [];
        for (int i = 0; i < currencies.length; i++) {
          if (currencies[i].isDefault ?? false) {
            defaultCurrencyIndex = i;
            break;
          }
        }
        if (currencies.isNotEmpty) {
          LocalStorage.setSelectedCurrency(currencies[defaultCurrencyIndex]);
        }
      },
      failure: (failure, status) {
        debugPrint('==> error with fetching currencies $failure');
      },
    );
  }
}
