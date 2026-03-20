import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/domain/interface/manager/interfaces.dart';

class AuthRepository implements AuthInterface {
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
  Future<ApiResult<LoginResponse>> loginWithGoogle({
    required String email,
    required String displayName,
    required String id,
    required String avatar,
  }) async {
    final data = {
      'email': email,
      'name': displayName,
      'id': id,
      "avatar": avatar,
    };
    debugPrint('===> login request $data');
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.login_with_google',
        queryParameters: data,
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
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.verify_my_email',
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
  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({
    required String verifyCode,
    required String verifyId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.verify_phone_code',
        data: {"phone": verifyId, "otp": verifyCode},
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
  Future<ApiResult<RegisterResponse>> forgotPassword({
    required String email,
  }) async {
    final data = {
      if (AppValidators.isValidEmail(email)) "email": email,
      if (!AppValidators.isValidEmail(email))
        "phone": email.replaceAll('+', ""),
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.forgot_password',
        data: data,
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
        data: {"phone": phone.replaceAll('+', ""), "type": "firebase"},
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
  Future<ApiResult<dynamic>> signUp({required String email}) async {
    final data = SignUpRequest(email: email);
    try {
      final client = dioHttp.client(requireAuth: false);
      await client.post(
        '/api/v1/method/paas.api.register_user',
        queryParameters: data.toJson(),
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithData({required UserModel user}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/v1/method/paas.api.user.user.signup_with_data',
        data: user.toJsonForSignUp(),
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
  Future<ApiResult<VerifyData>> sigUpWithPhone({
    required UserModel user,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/v1/method/paas.api.user.user.signup_with_phone',
        data: user.toJsonForSignUp(typeFirebase: true),
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
  Future<ApiResult<CheckPhoneResponse>> checkPhone({
    required String phone,
  }) async {
    final data = {'phone': phone.replaceAll("+", "")};
    debugPrint('===> login request $data');
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.check_phone',
        queryParameters: data,
      );
      return ApiResult.success(
        data: CheckPhoneResponse.fromJson(response.data),
      );
    } catch (e, s) {
      debugPrint('==> check phone failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
