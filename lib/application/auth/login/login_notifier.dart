import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:venderfoodyman/domain/interface/auth.dart';
import 'package:venderfoodyman/domain/interface/user.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/address_old_data.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/customer/app_constants.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/customer/app_validators.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/infrastructure/services/utils/tr_keys.dart';
import 'package:venderfoodyman/presentation/routes/app_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:venderfoodyman/domain/interface/customer/settings.dart';

import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthFacade _authRepository;
  final SettingsRepositoryFacade _settingsRepository;
  final UserFacade _userRepositoryFacade;

  LoginNotifier(
    this._authRepository,
    this._settingsRepository,
    this._userRepositoryFacade,
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
      final connect = await AppConnectivity.connectivity();
      if (connect) {
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
        if (context.mounted) {
          AppHelpers.showNoConnectionSnackBar(context);
        }
      }
    } else {
      // Language already selected, verify it exists in available languages
      final connect = await AppConnectivity.connectivity();
      if (connect) {
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
      } else {
        if (context.mounted) {
          AppHelpers.showNoConnectionSnackBar(context);
        }
      }
    }
  }

  // Helper method to get translations
  Future<void> _getTranslations(
    BuildContext context,
    LanguageData language,
  ) async {
    final connect = await AppConnectivity.connectivity();
    if (connect) {
      final response = await _settingsRepository.getMobileTranslations();
      response.when(
        success: (data) {
          LocalStorage.setTranslations(data.data);
        },
        failure: (failure, status) {
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  checkEmail() {
    return AppValidators.checkEmail(state.email);
  }

  Future<void> getProfileDetails(BuildContext context) async {
    state = state.copyWith(isProfileDetailsLoading: true);
    final response = await _userRepositoryFacade.getProfileDetails();
    response.when(
      success: (data) async {
        final user = data.data;
        LocalStorage.setUser(user);
        if (user?.wallet != null) {
          LocalStorage.setWallet(user?.wallet);
        }
        
        // Driver specific: online status
        if (user?.role == 'deliveryman') {
           // We can also trigger the driver user repo fetch if needed, 
           // but for now, we ensure the basic user is set.
        }

        state = state.copyWith(isProfileDetailsLoading: false);
      },
      failure: (failure, status) {
        state = state.copyWith(isProfileDetailsLoading: false);
        debugPrint('==> get profile details failure: $failure');
      },
    );
  }

  Future<void> login({
    required BuildContext context,
    VoidCallback? loginSuccess,
    VoidCallback? youAreNotDeliveryman,
    VoidCallback? seller,
    VoidCallback? admin,
    VoidCallback? accessDenied,
    int index = 0, // 0 for phone, 1 for email (standardizing role-specific inputs)
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      // Validate inputs based on role-specific patterns
      if (index == 0 && AppConstants.isPhoneFirebase) {
         if (!AppValidators.isValidPhone(state.email)) {
            state = state.copyWith(isPhoneNotValid: true);
            return;
         }
      } else {
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
          final accessToken = data.data?.accessToken ?? '';
          LocalStorage.setToken(accessToken);
          
          // Hydrate user and wallet
          await getProfileDetails(context);
          
          final user = data.data?.user;
          
          // Role-specific redirection logic
          if (user?.role == 'deliveryman') {
            if (youAreNotDeliveryman != null) {
              // Custom redirection for driver entry point
              loginSuccess?.call();
            } else {
              AppHelpers.goHome(context);
            }
          } else if (user?.role == 'seller') {
            seller?.call() ?? AppHelpers.goHome(context);
          } else if (user?.role == 'admin') {
            admin?.call() ?? accessDenied?.call() ?? AppHelpers.goHome(context);
          } else {
            if (AppConstants.isDemo) {
              context.replaceRoute(UiTypeRoute());
            } else {
              AppHelpers.goHome(context);
            }
          }

          String? fcmToken = await FirebaseMessaging.instance.getToken();
          _userRepositoryFacade.updateFirebaseToken(fcmToken);
          state = state.copyWith(isLoading: false);
          loginSuccess?.call();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, isLoginError: true);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await GoogleSignIn().signIn();
      } catch (e) {
        state = state.copyWith(isLoading: false);
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
              title: data.data?.user?.addresses?.firstWhere(
                    (element) => element.active ?? false,
                    orElse: () {
                      return AddressNewModel();
                    },
                  ).title ??
                  "",
              address: data.data?.user?.addresses
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
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
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
                  title: data.data?.user?.addresses?.firstWhere(
                        (element) => element.active ?? false,
                        orElse: () {
                          return AddressNewModel();
                        },
                      ).title ??
                      "",
                  address: data.data?.user?.addresses
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
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> loginWithApple(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
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
                title: data.data?.user?.addresses?.firstWhere(
                      (element) => element.active ?? false,
                      orElse: () {
                        return AddressNewModel();
                      },
                    ).title ??
                    "",
                address: data.data?.user?.addresses
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
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}




