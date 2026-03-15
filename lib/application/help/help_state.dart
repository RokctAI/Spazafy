import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/help_data.dart';

part 'help_state.freezed.dart';

@freezed
class HelpState with _$HelpState {
  const factory HelpState({
    @Default(false) bool isLoading,
    @Default(null) HelpModel? data,
  }) = _HelpState;

  const HelpState._();
}
