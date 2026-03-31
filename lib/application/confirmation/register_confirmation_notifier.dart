import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/domain/interface/auth.dart';
import 'package:rokctapp/domain/interface/user.dart';
import 'register_confirmation_state.dart';
// ignore_for_file: use_build_context_synchronously

class RegisterConfirmationNotifier
    extends StateNotifier<RegisterConfirmationState> {
  final AuthRepositoryFacade _authRepository;
  final UserRepositoryFacade _userRepositoryFacade;

  RegisterConfirmationNotifier(this._authRepository, this._userRepositoryFacade)
    : super(const RegisterConfirmationState());

  Timer? _timer;
  int _initialTime = 30;

  void setCode(String? code) {
    state = state.copyWith(
      confirmCode: code?.trim() ?? '',
      isCodeError: false,
      isConfirm: code.toString().length == 6,
    );
  }

  Future<void> confirmCodeWithFirebase({
    required BuildContext context,
    required String verificationId,
    VoidCallback? onSuccess,
  }) async {
    state = state.copyWith(isLoading: true, isSuccess: false);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.verificationCode.isNotEmpty
            ? state.verificationCode
            : verificationId,
        smsCode: state.confirmCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      onSuccess?.call();
      state = state.copyWith(
        isLoading: false,
        isSuccess: onSuccess == null ? true : false,
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBar(context, 
        context,
        AppHelpers.getTranslation((e as FirebaseAuthException).message ?? ""),
      );
      state = state.copyWith(
        isLoading: false,
        isCodeError: true,
        isSuccess: false,
      );
    }
  }

  Future<void> confirmCode(BuildContext context) async {
    state = state.copyWith(isLoading: true, isSuccess: false);
    final response = await _authRepository.verifyEmail(
      verifyCode: state.confirmCode.trim(),
    );
    response.when(
      success: (data) async {
        state = state.copyWith(isLoading: false, isSuccess: true);
        _timer?.cancel();
      },
      failure: (failure, status) {
        state = state.copyWith(
          isLoading: false,
          isCodeError: true,
          isSuccess: false,
        );
        AppHelpers.showCheckTopSnackBar(context, failure);
        debugPrint('==> confirm code failure: $failure');
      },
    );
  }

  Future<void> confirmCodeResetPassword(
    BuildContext context,
    String email,
  ) async {
    state = state.copyWith(isLoading: true, isResetPasswordSuccess: false);
    final response = await _authRepository.forgotPasswordConfirm(
      verifyCode: state.confirmCode.trim(),
      email: email,
    );
    response.when(
      success: (data) async {
        await LocalStorage.setToken(data.token);
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        _userRepositoryFacade.updateFirebaseToken(fcmToken);
        state = state.copyWith(isLoading: false, isResetPasswordSuccess: true);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false, isCodeError: true);
        AppHelpers.showCheckTopSnackBar(context, 
          context,
          AppHelpers.getTranslation(status.toString()),
        );
        debugPrint('==> confirm reset code failure: $failure');
      },
    );
  }

  Future<void> confirmCodeResetPasswordWithPhone(
    BuildContext context,
    String phone,
    String verificationId,
  ) async {
    state = state.copyWith(isLoading: true, isResetPasswordSuccess: false);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.verificationCode.isNotEmpty
            ? state.verificationCode
            : verificationId,
        smsCode: state.confirmCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final response = await _authRepository.forgotPasswordConfirmWithPhone(
        phone: phone,
      );
      response.when(
        success: (data) async {
          await LocalStorage.setToken(data.token);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          _userRepositoryFacade.updateFirebaseToken(fcmToken);
          state = state.copyWith(
            isLoading: false,
            isResetPasswordSuccess: true,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, isCodeError: true);
          AppHelpers.showCheckTopSnackBar(context, 
            context,
            AppHelpers.getTranslation(status.toString()),
          );
          debugPrint('==> confirm reset code failure: $failure');
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBar(context, 
        context,
        AppHelpers.getTranslation((e as FirebaseAuthException).message ?? ""),
      );
      state = state.copyWith(isLoading: false, isCodeError: true);
    }
  }

  Future<void> resendConfirmation(
    BuildContext context,
    String email, {
    bool isResetPassword = false,
  }) async {
    state = state.copyWith(isResending: true);
    late ApiResult response;
    if (isResetPassword) {
      response = await _authRepository.forgotPassword(email: email.trim());
    } else {
      response = await _authRepository.sigUp(email: email.trim());
    }

    response.when(
      success: (data) async {
        state = state.copyWith(isResending: false);
      },
      failure: (failure, status) {
        state = state.copyWith(isResending: false);
        AppHelpers.showCheckTopSnackBar(context, 
          context,
          AppHelpers.getTranslation(status.toString()),
        );
        debugPrint('==> send otp failure: $failure');
      },
    );
  }

  Future<void> sendCodeToNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    state = state.copyWith(isResending: true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        AppHelpers.showCheckTopSnackBar(context, 
          context,
          AppHelpers.getTranslation(AppHelpers.getTranslation(e.message ?? "")),
        );
        state = state.copyWith(isResending: false);
      },
      codeSent: (String verificationId, int? resendToken) {
        state = state.copyWith(
          isResending: false,
          verificationCode: verificationId,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  void startTimer() {
    _timer?.cancel();
    _initialTime = 30;
    state = state.copyWith(confirmCode: '', isCodeError: false);
    if (_timer != null) {
      _initialTime = 30;
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_initialTime < 1) {
        _timer?.cancel();
        state = state.copyWith(isTimeExpired: true);
      } else {
        _initialTime--;
        state = state.copyWith(
          isTimeExpired: false,
          timerText: formatHHMMSS(_initialTime),
        );
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
}
