import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final authRepository = driverAuthRepository;
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart';
import 'package:rokctapp/domain/interface/driver/interfaces.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final data = {
      if (AppValidators.isValidEmail(email)) 'email': email,
      if (!AppValidators.isValidEmail(email)) 'phone': email,
      'password': password,
    };
    debugPrint('===> login request $data');
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
  Future<ApiResult<LoginResponse>> loginWithSocial({
    String? email,
    String? displayName,
    String? id,
  }) async {
    final data = {
      if (email != null) 'email': email,
      if (displayName != null) 'name': displayName,
      if (id != null) 'id': id,
    };
    debugPrint('===> login request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.login_with_google',
        data: data,
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
  Future<ApiResult<RegisterResponse>> sendOtp({required String phone}) async {
    final data = {'phone': phone};
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
  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({
    required String verifyId,
    required String verifyCode,
  }) async {
    final data = {'verifyId': verifyId, 'verifyCode': verifyCode};
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
    final data = {'email': email};
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
  Future<ApiResult<VerifyData>> forgotPasswordConfirm({
    required String verifyCode,
    required String email,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.forgot_password_confirm',
        data: {'verifyCode': verifyCode, 'email': email},
      );

      return ApiResult.success(
        data: VerifyData.fromJson(response.data["data"]),
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
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.forgot_password_confirm_with_phone',
        data: {"phone": phone, "type": "firebase"},
      );

      return ApiResult.success(
        data: VerifyData.fromJson(response.data["data"]),
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
  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({
    required String verifyCode,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/rcore.tenant.api.verify_my_email',
        queryParameters: {'token': verifyCode},
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
  Future<ApiResult<VerifyData>> sigUpWithData({required UserData user}) async {
    final data = {
      "firstname": user.firstname,
      "lastname": user.lastname,
      "phone": user.phone,
      "email": user.email,
      "password": user.password,
      "password_conformation": user.conPassword,
      if (user.referral?.isNotEmpty ?? false) 'referral': user.referral,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/v1/method/paas.api.user.user.signup_with_data',
        data: data,
      );
      return ApiResult.success(data: VerifyData.fromJson(res.data["data"]));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithPhone({required UserData user}) async {
    final data = {
      "firstname": user.firstname,
      "lastname": user.lastname,
      "phone": user.phone,
      "email": user.email,
      "password": user.password,
      "password_conformation": user.conPassword,
      "type": "firebase",
      if (user.referral?.isNotEmpty ?? false) 'referral': user.referral,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/v1/method/paas.api.user.user.signup_with_phone',
        data: data,
      );
      return ApiResult.success(data: VerifyData.fromJson(res.data["data"]));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> signUp({required String email}) async {
    final data = SignUpRequest(email: email);
    try {
      final client = dioHttp.client(requireAuth: false);
      await client.post(
        '/api/v1/method/paas.api.user.user.register_user',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> checkPhone({required String phone}) async {
    final data = {'phone': phone};
    debugPrint('===> login request $data');
    try {
      final client = dioHttp.client(requireAuth: false);
      await client.post(
        '/api/v1/method/paas.api.user.user.check_phone',
        queryParameters: data,
      );
      return const ApiResult.success(data: true);
    } catch (e, s) {
      debugPrint('==> check phone failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}





