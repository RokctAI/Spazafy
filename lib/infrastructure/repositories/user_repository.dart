import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/referral_data.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/response/profile_response.dart';
import 'package:rokctapp/infrastructure/models/response/wallet_histories_response.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/user.dart';

import 'package:rokctapp/infrastructure/models/request/edit_profile.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:rokctapp/infrastructure/models/data/referral_data.dart';
import 'package:rokctapp/infrastructure/models/data/profile_data.dart';
import 'package:rokctapp/infrastructure/models/response/login_response.dart';
import 'package:rokctapp/infrastructure/models/response/profile_response.dart';
import 'package:rokctapp/infrastructure/models/response/wallet_histories_response.dart';

class UserRepository implements UserRepositoryFacade {
  @override
  Future<ApiResult<ProfileResponse>> getProfileDetails() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.get_user_profile',
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get user details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> saveLocation({
    required AddressNewModel? address,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.user.user.add_user_address',
        data: address?.toJson(),
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> save location failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.add_user_address',
          method: 'POST',
          payload: address?.toJson(),
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> updateLocation({
    required AddressNewModel? address,
    required String? addressId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.put(
        '/api/v1/method/paas.api.user.user.update_user_address',
        data: {'name': addressId, 'address_data': address?.toJson()},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> update location failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.update_user_address',
          method: 'PUT',
          payload: {'name': addressId, 'address_data': address?.toJson()},
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteAddress({required String id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.user.user.delete_user_address',
        data: {'name': id},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> delete address failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.delete_user_address',
          method: 'POST',
          payload: {'name': id},
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> logoutAccount({required String fcm}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/method/paas.api.user.user.logout');
      LocalStorage.logout();
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> editProfile({
    required EditProfile? user,
  }) async {
    final data = user?.toJson();
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put(
        '/api/v1/method/paas.api.user.user.update_user_profile',
        data: {'profile_data': data},
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> update profile details failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.update_user_profile',
          method: 'PUT',
          payload: {'profile_data': data},
        );
        // Return dummy response for offline success
        return ApiResult.success(data: ProfileResponse(data: ProfileData()));
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletHistoriesResponse>> getWalletHistories(
    int page,
  ) async {
    final data = {'limit_start': (page - 1) * 10, 'limit_page_length': 10};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.get_wallet_history',
        data: data,
      );
      return ApiResult.success(
        data: WalletHistoriesResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get wallet histories failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> updateFirebaseToken(String? token) async {
    final data = {
      'device_token': token,
      'provider': 'fcm', // Assuming FCM
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.user.user.register_device_token',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> update firebase token failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.register_device_token',
          method: 'POST',
          payload: data,
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // NOTE: The following methods are not supported by the new backend.
  // - getReferralDetails
  // - setActiveAddress
  // - deleteAccount
  // - updateProfileImage
  // - updatePassword
  // - searchUser

  @override
  Future<ApiResult<ReferralModel>> getReferralDetails() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.get_referral_details',
      );
      return ApiResult.success(
        data: ReferralModel.fromJson(response.data['message']),
      );
    } catch (e) {
      debugPrint('==> get referral details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> setActiveAddress({required String id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.user.user.set_active_address',
        data: {'address_id': id},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> set active address failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.set_active_address',
          method: 'POST',
          payload: {'address_id': id},
        );
        return const ApiResult.success(data: null);
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> deleteAccount() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/method/paas.api.user.user.delete_account');
      LocalStorage.logout();
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updateProfileImage({
    required String firstName,
    required String imageUrl,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put(
        '/api/v1/method/paas.api.user.user.update_profile_image',
        data: {'image_url': imageUrl},
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> update profile image failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.update_profile_image',
          method: 'PUT',
          payload: {'image_url': imageUrl},
        );
        return ApiResult.success(data: ProfileResponse(data: ProfileData()));
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updatePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.update_password',
        data: {'password': password},
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> update password failure: $e');

      // Sync Queue fallback
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/v1/method/paas.api.user.user.update_password',
          method: 'POST',
          payload: {'password': password},
        );
        return ApiResult.success(data: ProfileResponse(data: ProfileData()));
      } catch (syncError) {
        debugPrint('==> sync queue failure: $syncError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<dynamic> searchUser({required String name, required int page}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.search_user',
        data: {'name': name, 'page': page},
      );
      // This is used for wallet transfers, return data as expected by UI
      return response.data['message'];
    } catch (e) {
      debugPrint('==> search user failure: $e');
      return null;
    }
  }
}
