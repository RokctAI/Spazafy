import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/models/data/driver/user_data.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/domain/interface/driver_user.dart';
import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/infrastructure/models/models.dart' hide UserData;
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/application/profile/driver/state/profile_settings_state.dart';
import 'package:rokctapp/infrastructure/models/response/login_response.dart'
    hide UserData;

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  final UserRepository _userRepository;

  ProfileSettingsNotifier(this._userRepository)
    : super(const ProfileSettingsState());

  Future<void> fetchProfileDetails({
    required BuildContext context,
    VoidCallback? checkYourNetwork,
    Function(String?)? setImage,
    Function(UserData?)? setUserData,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _userRepository.getProfileDetails();
    response.when(
      success: (data) {
        state = state.copyWith(userData: data.data, isLoading: false);
        if (setImage != null) {
          setImage(data.data?.img);
        }
        if (setUserData != null) {
          setUserData(data.data);
        }
        LocalStorage.setUser(data.data);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        debugPrint('==> get profile details failure: $failure');
      },
    );
  }

  Future<void> fetchRequestResponse({required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    final response = await _userRepository.getRequestModel();
    response.when(
      success: (data) {
        state = state.copyWith(
          requestData: (data.data?.isEmpty ?? true) ? null : data.data?.first,
          isLoading: false,
        );
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        debugPrint('==> get request response failure: $failure');
      },
    );
  }

  void clearRequest() {
    state = state.copyWith(requestData: null);
  }

  void setPhone(String? data) {
    state = state.copyWith(userData: UserData(phone: data));
  }

  void setEmail(String? data) {
    state = state.copyWith(userData: UserData(email: data));
  }

  Future<void> fetchProfileStatistics({required BuildContext context}) async {
    state = state.copyWith(isLoading: true);
    final response = await _userRepository.getDriverStatistics();
    response.when(
      success: (data) {
        state = state.copyWith(statistics: data, isLoading: false);
      },
      failure: (failure, status) {
        if (status == 401) {
          LocalStorage.logout();
          context.router.popUntilRoot();
          context.router.replaceNamed('/login');
        } else {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(failure),
          );
        }
      },
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _userRepository.deleteAccount();
      response.when(
        success: (data) async {
          LocalStorage.logout();
          context.router.popUntilRoot();
          context.router.replaceNamed('/login');
        },
        failure: (fail, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, fail);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }
}
