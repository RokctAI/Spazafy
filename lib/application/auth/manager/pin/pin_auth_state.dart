import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_auth_state.freezed.dart';

@freezed
class PinAuthState with _$PinAuthState {
  const factory PinAuthState({
    @Default(false) bool isLoading,
    @Default('') String pin,
    @Default('') String confirmPin,
    @Default(false) bool isError,
    @Default(false) bool isSuccess,
    @Default(false) bool isPinSet,
    @Default('') String errorMessage,
  }) = _PinAuthState;
}
