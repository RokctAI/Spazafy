import 'package:rokctapp/dummy_types.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/domain/interface/auth.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

class AuthRepository implements AuthRepositoryFacade {
  @override
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.login',
        data: {'usr': email, 'pwd': password},
      );
      return ApiResult.success(data: LoginResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> login failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> sendOtp({required String phone}) async {
    final data = {'phone': phone.replaceAll('+', "")};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.send_phone_verification_code',
        data: data,
      );
      return ApiResult.success(data: RegisterResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> send otp failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({
    required String verifyCode,
    String? email,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.verify_email_code',
        data: {'otp': verifyCode, 'email': email},
      );
      return ApiResult.success(
        data: VerifyPhoneResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> verify email failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({
    required String verifyId,
    required String verifyCode,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.verify_phone_code',
        data: {"phone": verifyId, "otp": verifyCode},
      );
      return ApiResult.success(
        data: VerifyPhoneResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> verify phone failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> forgotPassword({
    required String email,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.forgot_password',
        data: {'user': email},
      );
      return ApiResult.success(data: RegisterResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> forgot password failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithData({required dynamic user}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var data = {};

      // Determine field mapping based on the model provided
      if (user is UserModel) {
        data = user.toJsonForSignUp();
      } else {
        // Assume Driver UserData/Manager model (using common properties if possible)
        data = {
          "firstname": user.firstname,
          "lastname": user.lastname,
          "phone": user.phone?.replaceAll('+', ""),
          "email": user.email,
          "password": user.password,
          "password_conformation": user.conPassword ?? user.password,
          "referral": user.referral,
        };
      }

      var res = await client.post(
        '/api/v1/method/paas.api.user.user.register_user',
        data: data,
      );

      return ApiResult.success(
        data: VerifyData.fromJson(res.data['data'] ?? res.data),
      );
    } catch (e) {
      debugPrint('==> sigUpWithData failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithPhone({required dynamic user}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var data = {};

      if (user is UserModel) {
        data = user.toJsonForSignUp(typeFirebase: true);
      } else {
        data = {
          "firstname": user.firstname,
          "lastname": user.lastname,
          "phone": user.phone?.replaceAll('+', ""),
          "email": user.email,
          "password": user.password,
          "password_conformation": user.conPassword ?? user.password,
          "type": "firebase",
          "referral": user.referral,
        };
      }

      final response = await client.post(
        '/api/v1/method/paas.api.user.user.register_user',
        data: data,
      );

      return ApiResult.success(
        data: VerifyData.fromJson(response.data['data'] ?? response.data),
      );
    } catch (e) {
      debugPrint('==> sigUpWithPhone failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirm({
    required String verifyCode,
    required String email,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.forgot_password_confirm',
        data: {'verify_code': verifyCode, 'email': email},
      );
      return ApiResult.success(
        data: VerifyData.fromJson(response.data['data'] ?? response.data),
      );
    } catch (e) {
      debugPrint('==> forgot password confirm failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({
    required String phone,
  }) async {
    // Standardizing on sending OTP to phone for this flow
    return sendOtp(phone: phone).then(
      (value) => value.when(
        success: (data) => ApiResult.success(data: VerifyData()),
        failure: (error, status) =>
            ApiResult.failure(error: error, statusCode: status),
      ),
    );
  }

  @override
  Future<ApiResult<LoginResponse>> loginWithGoogle({
    required String email,
    required String displayName,
    required String id,
    required String avatar,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.login_with_google',
        data: {
          'email': email,
          'display_name': displayName,
          'id': id,
          'avatar': avatar,
        },
      );
      return ApiResult.success(data: LoginResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> login with google failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<LoginResponse>> loginWithSocial({
    String? email,
    String? displayName,
    String? id,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.login_with_google',
        data: {'email': email, 'display_name': displayName, 'id': id},
      );
      return ApiResult.success(data: LoginResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> login with social failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> sigUp({required String email}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      await client.post(
        '/api/v1/method/paas.api.user.user.register_user',
        data: {'email': email},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> signup failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> checkPhone({required String phone}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.check_phone',
        data: {'phone': phone.replaceAll("+", "")},
      );

      // Attempt generic response parsing for CheckPhoneResponse or Boolean
      return ApiResult.success(data: response.data);
    } catch (e) {
      debugPrint('==> check phone failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
