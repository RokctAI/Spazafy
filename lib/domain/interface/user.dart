import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/referral_data.dart';
import 'package:rokctapp/infrastructure/models/response/profile_response.dart';
import 'package:rokctapp/infrastructure/models/response/wallet_histories_response.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:rokctapp/infrastructure/models/request/edit_profile.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';





abstract class UserRepositoryFacade {
  Future<ApiResult<ProfileResponse>> getProfileDetails();

  Future<ApiResult<ReferralModel>> getReferralDetails();

  Future<ApiResult<dynamic>> saveLocation({required AddressNewModel? address});

  Future<ApiResult<dynamic>> updateLocation({
    required AddressNewModel? address,
    required String? addressId,
  });

  Future<ApiResult<dynamic>> setActiveAddress({required String id});

  Future<ApiResult<dynamic>> deleteAddress({required String id});

  Future<ApiResult<dynamic>> deleteAccount();

  Future<ApiResult<dynamic>> logoutAccount({required String fcm});

  Future<ApiResult<ProfileResponse>> editProfile({required EditProfile? user});

  Future<ApiResult<ProfileResponse>> updateProfileImage({
    required String firstName,
    required String imageUrl,
  });

  Future<ApiResult<ProfileResponse>> updatePassword({
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResult<WalletHistoriesResponse>> getWalletHistories(int page);

  Future<ApiResult<void>> updateFirebaseToken(String? token);

  Future<dynamic> searchUser({required String name, required int page});
}
