import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rokctapp/domain/interface/auth.dart';
import 'package:rokctapp/domain/interface/user.dart';
import 'package:rokctapp/infrastructure/models/data/address_old_data.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_validators.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:rokctapp/domain/interface/settings.dart';

import 'package:rokctapp/infrastructure/services/utils/background_sync_service.dart';
import 'package:rokctapp/infrastructure/services/utils/app_database.dart';
import 'dart:convert';

import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepositoryFacade _authRepository;
  final SettingsRepositoryFacade _settingsRepository;
  final UserRepositoryFacade _userRepositoryFacade;
  final BackgroundSyncService _backgroundSyncService;
  final AppDatabase _appDatabase;

  LoginNotifier(
    this._authRepository,
    this._settingsRepository,
    this._userRepositoryFacade,
    this._backgroundSyncService,
    this._appDatabase,
  ) : super(const LoginState());

  void setPassword(String text) {
    state = state.copyWith(
      password: text.trim(),
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setEmail(String text) {
    state = state.copyWith(
      email: text.trim(),
      isLoginError: false,
      isEmailNotValid: false,
      isPasswordNotValid: false,
    );
  }

  void setShowPassword(bool show) {
    state = state.copyWith(showPassword: show);
  }

  void setKeepLogin(bool keep) {
    state = state.copyWith(isKeepLogin: keep);
  }

  Future<void> checkLanguage(BuildContext context) async {
    final lang = LocalStorage.getLanguage();
    if (lang == null) {
      // No language selected yet, check available languages
      final response = await _settingsRepository.getLanguages();
      response.when(
        success: (data) {
          final List<LanguageData> languages = data.data ?? [];
          state = state.copyWith(list: languages);

          // Auto-select if there's only one language
          if (languages.length == 1) {
            // Set as selected language
            LocalStorage.setLanguageData(languages[0]);
            LocalStorage.setLangLtr(languages[0].backward);
            LocalStorage.setLanguageSelected(true);

            // Get translations for this language
            _getTranslations(context, languages[0]);

            // Update state to skip language selection screen
            state = state.copyWith(isSelectLanguage: true);
          } else {
            // Multiple languages available, show selection screen
            state = state.copyWith(isSelectLanguage: false);
          }
        },
        failure: (failure, status) {
          state = state.copyWith(isSelectLanguage: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      // Language already selected, verify it exists in available languages
      final response = await _settingsRepository.getLanguages();
      response.when(
        success: (data) {
          state = state.copyWith(list: data.data ?? []);
          final List<LanguageData> languages = data.data ?? [];
          for (int i = 0; i < languages.length; i++) {
            if (languages[i].id == lang.id) {
              state = state.copyWith(isSelectLanguage: true);
              break;
            }
          }
        },
        failure: (failure, status) {
          state = state.copyWith(isSelectLanguage: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    }
  }

  // Helper method to get translations
  Future<void> _getTranslations(
    BuildContext context,
    LanguageData language,
  ) async {
    final response = await _settingsRepository.getMobileTranslations();
    response.when(
      success: (data) {
        LocalStorage.setTranslations(data.data);
      },
      failure: (failure, status) {
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  checkEmail() {
    return AppValidators.checkEmail(state.email);
  }

  Future<void> login(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (checkEmail()) {
        if (!AppValidators.isValidEmail(state.email)) {
          state = state.copyWith(isEmailNotValid: true);
          return;
        }
      }

      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordNotValid: true);
        return;
      }
      state = state.copyWith(isLoading: true);
      final response = await _authRepository.login(
        email: state.email,
        password: state.password,
      );
      response.when(
        success: (data) async {
          // Persist user to local DB for future offline login
          if (data.data?.user != null) {
            await _appDatabase.upsertUser(
              data.data!.user!.toJson(),
              password: state.password,
            );
          }

          LocalStorage.setToken(data.data?.accessToken ?? '');
          LocalStorage.setAddressSelected(
            AddressData(
              title:
                  data.data?.user?.addresses
                      ?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      )
                      .title ??
                  "",
              address:
                  data.data?.user?.addresses
                      ?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      )
                      .address
                      ?.address ??
                  "",
              location: LocationModel(
                longitude: data.data?.user?.addresses
                    ?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    )
                    .location
                    ?.last,
                latitude: data.data?.user?.addresses
                    ?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    )
                    .location
                    ?.first,
              ),
            ),
          );
          if (data.data?.user?.role == 'seller') {
            AppHelpers.showCheckTopSnackBar(
              context,
              text: AppHelpers.getTranslation(TrKeys.youAreASeller),
              type: SnackBarType.success,
            );
          } else if (data.data?.user?.role == 'deliveryman') {
            AppHelpers.showCheckTopSnackBar(
              context,
              text: AppHelpers.getTranslation(TrKeys.youAreNotADeliveryman),
              type: SnackBarType.success,
            );
          }
          if (AppConstants.isDemo) {
            context.replaceRoute(UiTypeRoute());
          } else {
            AppHelpers.goHome(context);
          }
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          _userRepositoryFacade.updateFirebaseToken(fcmToken);
          state = state.copyWith(isLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, isLoginError: true);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      // Offline: Guest mode and queue request
      if (checkEmail()) {
        if (!AppValidators.isValidEmail(state.email)) {
          state = state.copyWith(isEmailNotValid: true);
          return;
        }
      }
      if (!AppValidators.isValidPassword(state.password)) {
        state = state.copyWith(isPasswordNotValid: true);
        return;
      }

      state = state.copyWith(isLoading: true);

      // 1. Check Local DB for offline re-login
      final localUser = await _appDatabase.getLocalUser(state.email);
      if (localUser != null && localUser.password == state.password) {
        // Success: Found matching local credentials
        final profileMap = jsonDecode(localUser.data);
        final profile = ProfileData.fromJson(profileMap);

        // Use cached token if available, or a placeholder
        LocalStorage.setToken(profile.accessToken ?? 'offline_session');
        LocalStorage.setUser(profile);

        if (profile.addresses?.isNotEmpty ?? false) {
          final addr = profile.addresses!.first;
          LocalStorage.setAddressSelected(
            AddressData(
              title: addr.title ?? "",
              address: addr.address?.address ?? "",
              location: LocationModel(
                latitude: addr.location?.first,
                longitude: addr.location?.last,
              ),
            ),
          );
        }

        state = state.copyWith(isLoading: false);
        AppHelpers.goHome(context);
        return;
      }

      // 2. If no local user but they want to login, queue as Guest/Pending
      state = state.copyWith(isLoading: false);
      LocalStorage.setIsGuest(true);
      LocalStorage.setOfflineUser({
        'email': state.email,
        'password': state.password,
        'type': 'login',
      });
      _backgroundSyncService.enqueueRequest(
        '${AppConstants.baseUrl}/auth/login',
        'POST',
        {'email': state.email, 'password': state.password},
      );
      AppHelpers.goHome(context);
    }
  }

    state = state.copyWith(isLoading: true);
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await GoogleSignIn().signIn();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(e.toString()),
        );
      }
    }
    if (googleUser == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final response = await _authRepository.loginWithGoogle(
      email: googleUser.email,
      displayName: googleUser.displayName ?? '',
      id: googleUser.id,
      avatar: googleUser.photoUrl ?? "",
    );
    response.when(
      success: (data) async {
        state = state.copyWith(isLoading: false);
        LocalStorage.setToken(data.data?.accessToken ?? '');
        LocalStorage.setAddressSelected(
          AddressData(
            title:
                data.data?.user?.addresses
                    ?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    )
                    .title ??
                "",
            address:
                data.data?.user?.addresses
                    ?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    )
                    .address
                    ?.address ??
                "",
            location: LocationModel(
              longitude: data.data?.user?.addresses
                  ?.firstWhere(
                    (element) => element.active ?? false,
                    orElse: () {
                      return AddressNewModel();
                    },
                  )
                  .location
                  ?.last,
              latitude: data.data?.user?.addresses
                  ?.firstWhere(
                    (element) => element.active ?? false,
                    orElse: () {
                      return AddressNewModel();
                    },
                  )
                  .location
                  ?.first,
            ),
          ),
        );
        context.router.popUntilRoot();
        if (data.data?.user?.role == 'seller') {
          AppHelpers.showCheckTopSnackBar(
            context,
            text: AppHelpers.getTranslation(TrKeys.youAreASeller),
            type: SnackBarType.success,
          );
        } else if (data.data?.user?.role == 'deliveryman') {
          AppHelpers.showCheckTopSnackBar(
            context,
            text: AppHelpers.getTranslation(TrKeys.youAreNotADeliveryman),
            type: SnackBarType.success,
          );
        }
        if (AppConstants.isDemo) {
          context.replaceRoute(UiTypeRoute());
        } else {
          AppHelpers.goHome(context);
        }
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        _userRepositoryFacade.updateFirebaseToken(fcmToken);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    final fb = FacebookAuth.instance;
    try {
      TrackingStatus? status;
      if (Platform.isIOS) {
        final permission = await Permission.appTrackingTransparency.request();
        status = await AppTrackingTransparency.trackingAuthorizationStatus;
        debugPrint("permission $permission");
        debugPrint("status: $status");
      }

      final user = await fb.login(
        loginTracking: status == TrackingStatus.authorized
            ? LoginTracking.enabled
            : LoginTracking.limited,
        loginBehavior: LoginBehavior.nativeWithFallback,
      );
      debugPrint(
        '===> login with face token ${user.accessToken?.tokenString}',
      );
      debugPrint('===> login with face authenticationToken ${user.status}');
      final rawNonce = AppHelpers.generateNonce();
      final OAuthCredential credential =
          user.accessToken?.type == AccessTokenType.limited
          ? OAuthCredential(
              providerId: 'facebook.com',
              signInMethod: 'oauth',
              idToken: user.accessToken!.tokenString,
              rawNonce: rawNonce,
            )
          : FacebookAuthProvider.credential(
              user.accessToken?.tokenString ?? "",
            );

      final userObj = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (user.status == LoginStatus.success) {
        final response = await _authRepository.loginWithGoogle(
          email: userObj.user?.email ?? "",
          displayName: userObj.user?.displayName ?? "",
          id: userObj.user?.uid ?? "",
          avatar: userObj.user?.photoURL ?? "",
        );
        response.when(
          success: (data) async {
            state = state.copyWith(isLoading: false);
            LocalStorage.setToken(data.data?.accessToken ?? '');
            LocalStorage.setAddressSelected(
              AddressData(
                title:
                    data.data?.user?.addresses
                        ?.firstWhere(
                          (element) => element.active ?? false,
                          orElse: () {
                            return AddressNewModel();
                          },
                        )
                        .title ??
                    "",
                address:
                    data.data?.user?.addresses
                        ?.firstWhere(
                          (element) => element.active ?? false,
                          orElse: () {
                            return AddressNewModel();
                          },
                        )
                        .address
                        ?.address ??
                    "",
                location: LocationModel(
                  longitude: data.data?.user?.addresses
                      ?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      )
                      .location
                      ?.last,
                  latitude: data.data?.user?.addresses
                      ?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      )
                      .location
                      ?.first,
                ),
              ),
            );
            context.router.popUntilRoot();
            if (AppConstants.isDemo) {
              context.replaceRoute(UiTypeRoute());
            } else {
              AppHelpers.goHome(context);
            }
            String? fcmToken = await FirebaseMessaging.instance.getToken();
            _userRepositoryFacade.updateFirebaseToken(fcmToken);
          },
          failure: (failure, status) {
            state = state.copyWith(isLoading: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      } else {
        state = state.copyWith(isLoading: false);
        if (context.mounted) {
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(TrKeys.somethingWentWrongWithTheServer),
          );
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('===> login with face exception: $e');
    }
  }

  Future<void> loginWithApple(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      OAuthProvider oAuthProvider = OAuthProvider("apple.com");
      final AuthCredential credentialApple = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userObj = await FirebaseAuth.instance.signInWithCredential(
        credentialApple,
      );

      final response = await _authRepository.loginWithGoogle(
        email: credential.email ?? userObj.user?.email ?? "",
        displayName: credential.givenName ?? userObj.user?.displayName ?? "",
        id: credential.userIdentifier ?? userObj.user?.uid ?? "",
        avatar: userObj.user?.displayName ?? "",
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          LocalStorage.setToken(data.data?.accessToken ?? '');
          LocalStorage.setAddressSelected(
            AddressData(
              title:
                  data.data?.user?.addresses
                      ?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      )
                      .title ??
                  "",
              address:
                  data.data?.user?.addresses
                      ?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      )
                      .address
                      ?.address ??
                  "",
              location: LocationModel(
                longitude: data.data?.user?.addresses
                    ?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    )
                    .location
                    ?.last,
                latitude: data.data?.user?.addresses
                    ?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    )
                    .location
                    ?.first,
              ),
            ),
          );
          context.router.popUntilRoot();
          if (AppConstants.isDemo) {
            context.replaceRoute(UiTypeRoute());
          } else {
            AppHelpers.goHome(context);
          }
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          _userRepositoryFacade.updateFirebaseToken(fcmToken);
        },
        failure: (failure, s) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('===> login with apple exception: $e');
    }
  }
}
