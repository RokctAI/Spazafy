import 'package:rokctapp/infrastructure/models/response/driver/statistics_response.dart';
import 'package:rokctapp/infrastructure/models/data/driver/user_data.dart';
import 'package:rokctapp/infrastructure/models/data/driver/request_model_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models.dart' hide UserData;
part 'profile_settings_state.freezed.dart';

@freezed
abstract class ProfileSettingsState with _$ProfileSettingsState {
  const factory ProfileSettingsState({
    @Default(false) bool isLoading,
    @Default(false) bool isStatisticLoading,
    UserData? userData,
    RequestModelData? requestData,
    StatisticsResponse? statistics,
  }) = _ProfileSettingsState;

  const ProfileSettingsState._();
}
