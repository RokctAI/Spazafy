import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/domain/interface/auth.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import '../models/models.dart';

class AuthRepository implements AuthFacade {
  @override
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    // We try the unified v1 login first as it's more standard,
    // but customer-specific endpoints might be needed if configuring for PaaS.
    // For lux consolidation, we provide logic for both.
    final v1Data = {
      if (AppValidators.isValidEmail(email)) 'email': email,
      if (!AppValidators.isValidEmail(email))
        'phone': email.replaceAll('+', ""),
      'password': password,
    };

    try {
      final client = dioHttp.client(requireAuth: false);

      // If we are in customer mode (Frappe), we might want the /api/method/paas... call
      // But typically unified repos should handle the most robust endpoint.
      // We'll use a check or just prioritize the correct one based on user feedback
      // which shows customer uses paas.api.

      final response = await client.post(
        '/api/method/paas.api.user.user.login',
        data: {'usr': email, 'pwd': password},
      );

      return ApiResult.success(data: LoginResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to standard V1 login if PaaS fails or isn't used
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.post('/api/v1/auth/login', data: v1Data);
        return ApiResult.success(data: LoginResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(
          error: AppHelpers.errorHandler(e2),
          statusCode: NetworkExceptions.getDioStatus(e2),
        );
      }
    }
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
        '/api/method/paas.api.login_with_google',
        data: {
          'email': email,
          'display_name': displayName,
          'id': id,
          'avatar': avatar,
        },
      );
      return ApiResult.success(data: LoginResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.post(
          '/api/v1/auth/google/callback',
          data: {
            'email': email,
            'name': displayName,
            'id': id,
            'avatar': avatar,
          },
        );
        return ApiResult.success(data: LoginResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> sendOtp({required String phone}) async {
    final data = {'phone': phone.replaceAll('+', "")};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/method/paas.api.send_phone_verification_code',
        data: data,
      );
      return ApiResult.success(data: RegisterResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.post('/api/v1/auth/register', data: data);
        return ApiResult.success(
          data: RegisterResponse.fromJson(response.data),
        );
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
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
        '/api/method/paas.api.verify_phone_code',
        data: {"phone": verifyId, "otp": verifyCode},
      );
      return ApiResult.success(
        data: VerifyPhoneResponse.fromJson(response.data),
      );
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.post(
          '/api/v1/auth/verify/phone',
          data: {"verifyId": verifyId, "verifyCode": verifyCode},
        );
        return ApiResult.success(
          data: VerifyPhoneResponse.fromJson(response.data),
        );
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({
    required String verifyCode,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.verify_my_email',
        queryParameters: {'token': verifyCode},
      );
      return ApiResult.success(
        data: VerifyPhoneResponse.fromJson(response.data),
      );
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.get('/api/v1/auth/verify/$verifyCode');
        return ApiResult.success(
          data: VerifyPhoneResponse.fromJson(response.data),
        );
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> forgotPassword({
    required String email,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/method/paas.api.forgot_password',
        data: {'user': email},
      );
      return ApiResult.success(data: RegisterResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.post(
          AppValidators.isValidEmail(email)
              ? '/api/v1/auth/forgot/email-password'
              : '/api/v1/auth/forgot/password',
          queryParameters: {'email': email, 'phone': email.replaceAll('+', "")},
        );
        return ApiResult.success(
          data: RegisterResponse.fromJson(response.data),
        );
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
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
        '/api/method/paas.api.forgot_password_confirm',
        data: {'verify_code': verifyCode, 'email': email},
      );
      return ApiResult.success(
        data: VerifyData.fromJson(response.data['data'] ?? response.data),
      );
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        final response = await client.post(
          '/api/v1/auth/forgot/email-password/$verifyCode?email=$email',
        );
        return ApiResult.success(
          data: VerifyData.fromJson(response.data["data"]),
        );
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({
    required String phone,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/forgot/password/confirm',
        data: {"phone": phone.replaceAll('+', ""), "type": "firebase"},
      );
      return ApiResult.success(
        data: VerifyData.fromJson(response.data["data"]),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithData({required UserModel user}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/method/paas.api.register_user',
        data: user.toJsonForSignUp(),
      );
      return ApiResult.success(
        data: VerifyData.fromJson(res.data['data'] ?? res.data),
      );
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        var res = await client.post(
          '/api/v1/auth/after-verify',
          data: user.toJsonForSignUp(),
        );
        return ApiResult.success(data: VerifyData.fromJson(res.data["data"]));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithPhone({
    required UserModel user,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/method/paas.api.register_user',
        data: user.toJsonForSignUp(),
      );
      return ApiResult.success(
        data: VerifyData.fromJson(response.data['data'] ?? response.data),
      );
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        var res = await client.post(
          '/api/v1/auth/verify/phone',
          data: user.toJsonForSignUp(typeFirebase: true),
        );
        return ApiResult.success(data: VerifyData.fromJson(res.data["data"]));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult> sigUp({required String email}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      await client.post(
        '/api/method/paas.api.register_user',
        data: {'email': email},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: false);
        await client.post(
          '/api/v1/auth/register',
          queryParameters: {'email': email},
        );
        return const ApiResult.success(data: null);
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<CheckPhoneResponse>> checkPhone({
    required String phone,
  }) async {
    final data = {'phone': phone.replaceAll("+", "")};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/check/phone',
        queryParameters: data,
      );
      return ApiResult.success(
        data: CheckPhoneResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
