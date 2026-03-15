import 'package:venderfoodyman/infrastructure/models/customer/request/edit_profile.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';

abstract class UserFacade {
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

  // Driver Methods
  Future<ApiResult<DeliveryResponse>> getDriverDetails();
  Future<ApiResult<StatisticsResponse>> getDriverStatistics();
  Future<ApiResult<ProfileResponse>> updateGeneralInfo({
    required String firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
  });
  Future<ApiResult<DeliveryResponse>> editCarInfo({
    required String type,
    required String brand,
    required String model,
    required String number,
    required String color,
    required String height,
    required String weight,
    required String length,
    required String width,
    String? imageUrl,
  });
  Future<ApiResult<DeliveryResponse>> createCarInfo({
    required String type,
    required String brand,
    required String model,
    required String number,
    required String color,
    required String height,
    required String weight,
    required String length,
    required String width,
    String? imageUrl,
  });
  Future<ApiResult<StatisticsIncomeResponse>> getStatistics({
    required DateTime startTime,
    required DateTime endTime,
  });
  Future<ApiResult<StatisticsOrderResponse>> getStatisticsOrder({
    DateTime? startTime,
    DateTime? endTime,
    int? page,
    int? perPage,
  });
  Future<ApiResult<RequestModelResponse>> getRequestModel();
  Future<ApiResult<dynamic>> setOnline();
  Future<ApiResult<dynamic>> setCurrentLocation(LatLng location);
  Future<ApiResult<void>> updateDeliveryZones({required List<LatLng> points});
  Future<ApiResult<DeliveryZonePaginate>> getDeliveryZone();

  // Manager Methods
  Future<ApiResult<ProfileResponse>> createUser({
    required String firstname,
    required String lastname,
    required String phone,
    required String email,
  });
  Future<ApiResult<void>> updateShopWorkingDays({
    required List<ShopWorkingDays> workingDays,
    String? uuid,
  });
  Future<ApiResult<SingleShopResponse>> updateShop({
    String? tax,
    num? percentage,
    String? phone,
    String? type,
    num? pricePerKm,
    String? minAmount,
    num? price,
    String? backImg,
    String? orderPayment,
    String? logoImg,
    List<CategoryData>? categories,
    List<ShopTag>? tags,
    DeliveryTime? deliveryTime,
    Translation? translation,
  });
  Future<ApiResult<UsersPaginateResponse>> searchUsers({
    String? query,
    int? page,
  });
  Future<ApiResult<SingleShopResponse>> getMyShop();
  Future<ApiResult<dynamic>> setOnlineOffline();
}




