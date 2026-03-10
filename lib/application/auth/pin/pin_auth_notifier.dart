import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';
import 'pin_auth_state.dart';

class PinAuthNotifier extends StateNotifier<PinAuthState> {
  PinAuthNotifier() : super(const PinAuthState()) {
    checkPinSet();
  }

  void checkPinSet() {
    final savedPin = LocalStorage.getAppPin();
    state = state.copyWith(isPinSet: savedPin.isNotEmpty);
  }

  void updatePin(String pin) {
    state = state.copyWith(pin: pin, isError: false);
  }

  void updateConfirmPin(String confirmPin) {
    state = state.copyWith(confirmPin: confirmPin, isError: false);
  }

  Future<void> setPin() async {
    if (state.pin.length != 4) {
      state = state.copyWith(
        isError: true,
        errorMessage: 'PIN must be 4 digits',
      );
      return;
    }
    if (state.pin != state.confirmPin) {
      state = state.copyWith(isError: true, errorMessage: 'PINs do not match');
      return;
    }

    state = state.copyWith(isLoading: true);
    await LocalStorage.setAppPin(state.pin);
    state = state.copyWith(isLoading: false, isSuccess: true, isPinSet: true);
  }

  bool verifyPin(String enteredPin) {
    final savedPin = LocalStorage.getAppPin();
    if (enteredPin == savedPin) {
      state = state.copyWith(isSuccess: true, isError: false);
      return true;
    } else {
      state = state.copyWith(isError: true, errorMessage: 'Incorrect PIN');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(isError: false, errorMessage: '');
  }

  void resetSuccess() {
    state = state.copyWith(isSuccess: false);
  }
}
