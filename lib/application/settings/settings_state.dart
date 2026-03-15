import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venderfoodyman/infrastructure/models/data/notification_list_data.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool isLoading,
    @Default(null) List<NotificationData>? notifications,
  }) = _SettingsState;

  const SettingsState._();
}
