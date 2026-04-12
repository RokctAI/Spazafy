import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/register_response.dart';
import 'package:rokctapp/infrastructure/models/response/login_response.dart';
import 'package:rokctapp/infrastructure/models/response/verify_phone_response.dart';

import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class AuthRepositoryFacade {
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<LoginResponse>> loginWithGoogle({
    required String email,
    required String displayName,
    required String id,
    required String avatar,
  });

  Future<ApiResult<LoginResponse>> loginWithSocial({
    String? email,
    String? displayName,
    String? id,
  });

  Future<ApiResult<dynamic>> sigUp({required String email});

  Future<ApiResult<VerifyData>> sigUpWithData({required dynamic user});

  Future<ApiResult<VerifyData>> sigUpWithPhone({required dynamic user});

  Future<ApiResult<RegisterResponse>> sendOtp({required String phone});

  Future<ApiResult<RegisterResponse>> forgotPassword({required String email});

  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({
    required String verifyCode,
    String? email,
  });

  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({
    required String verifyId,
    required String verifyCode,
  });

  Future<ApiResult<VerifyData>> forgotPasswordConfirm({
    required String verifyCode,
    required String email,
  });

  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({
    required String phone,
  });

  Future<ApiResult<dynamic>> checkPhone({required String phone});
}
