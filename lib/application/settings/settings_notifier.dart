import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/interface/settings.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'settings_state.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsFacade _settingsRepository;

  SettingsNotifier(this._settingsRepository) : super(const SettingsState());

  Future<void> fetchNotifications(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      // Assuming getNotifications exists in SettingsFacade as per original customer code
      // final response = await _settingsRepository.getNotifications();
      // ...
    }
  }
}
