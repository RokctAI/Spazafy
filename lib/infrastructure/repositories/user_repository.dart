import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/user.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/request/edit_profile.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';

class UserRepository implements UserFacade {
  // --- Common & Customer (Frappe/ERPNext) ---

  @override
  Future<ApiResult<ProfileResponse>> getProfileDetails() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      // Try PaaS first
      final response = await client.post('/api/method/paas.api.user.user.get_user_profile');
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: true);
        final response = await client.get('/api/v1/dashboard/user/profile/show');
        return ApiResult.success(data: ProfileResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<dynamic>> logoutAccount({required String fcm}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.user.user.logout');
      LocalStorage.logout();
      return const ApiResult.success(data: null);
    } catch (e) {
      LocalStorage.logout(); // Always logout locally
      return const ApiResult.success(data: null);
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> editProfile({required EditProfile? user}) async {
    final data = user?.toJson();
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put(
        '/api/method/paas.api.user.user.update_user_profile',
        data: {'profile_data': data},
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      // Fallback to V1
      try {
        final client = dioHttp.client(requireAuth: true);
        final response = await client.put('/api/v1/dashboard/user/profile/update', data: data);
        return ApiResult.success(data: ProfileResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<void>> updateFirebaseToken(String? token) async {
    final data = {'device_token': token, 'provider': 'fcm', 'firebase_token': token};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.user.user.register_device_token', data: data);
      return const ApiResult.success(data: null);
    } catch (e) {
      try {
        final client = dioHttp.client(requireAuth: true);
        await client.post('/api/v1/dashboard/user/profile/firebase/token/update', data: {'firebase_token': token});
        return const ApiResult.success(data: null);
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteAccount() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.user.user.delete_account');
      LocalStorage.logout();
      return const ApiResult.success(data: null);
    } catch (e) {
      try {
        final client = dioHttp.client(requireAuth: true);
        await client.delete('/api/v1/dashboard/user/profile/delete');
        LocalStorage.logout();
        return const ApiResult.success(data: null);
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updateProfileImage({required String firstName, required String imageUrl}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put('/api/method/paas.api.user.user.update_profile_image', data: {'image_url': imageUrl});
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      try {
        final client = dioHttp.client(requireAuth: true);
        final response = await client.put('/api/v1/dashboard/user/profile/update', data: {'firstname': firstName, 'images': [imageUrl]});
        return ApiResult.success(data: ProfileResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updatePassword({required String password, required String passwordConfirmation}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/method/paas.api.user.user.update_password', data: {'password': password});
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      try {
        final client = dioHttp.client(requireAuth: true);
        final response = await client.post('/api/v1/dashboard/user/profile/password/update', data: {'password': password, 'password_confirmation': passwordConfirmation});
        return ApiResult.success(data: ProfileResponse.fromJson(response.data));
      } catch (e2) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e2));
      }
    }
  }

  // --- Customer Specific (Location/Wallet) ---

  @override
  Future<ApiResult<dynamic>> saveLocation({required AddressNewModel? address}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.user.user.add_user_address', data: address?.toJson());
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> updateLocation({required AddressNewModel? address, required String? addressId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.put('/api/method/paas.api.user.user.update_user_address', data: {'name': addressId, 'address_data': address?.toJson()});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> setActiveAddress({required String id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.user.user.set_active_address', data: {'address_id': id});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteAddress({required String id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.user.user.delete_user_address', data: {'name': id});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<WalletHistoriesResponse>> getWalletHistories(int page) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/method/paas.api.user.user.get_wallet_history', data: {'limit_start': (page - 1) * 10, 'limit_page_length': 10});
      return ApiResult.success(data: WalletHistoriesResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ReferralModel>> getReferralDetails() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/method/paas.api.user.user.get_referral_details');
      return ApiResult.success(data: ReferralModel.fromJson(response.data['message']));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<dynamic> searchUser({required String name, required int page}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/method/paas.api.user.user.search_user', data: {'name': name, 'page': page});
      return response.data['message'];
    } catch (e) {
      return null;
    }
  }

  // --- Driver Specific ---

  @override
  Future<ApiResult<DeliveryResponse>> getDriverDetails() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/deliveryman/settings');
      return ApiResult.success(data: DeliveryResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<StatisticsResponse>> getDriverStatistics() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/deliveryman/statistics/count');
      return ApiResult.success(data: StatisticsResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updateGeneralInfo({
    required String firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {
    final data = {
      'firstname': firstName,
      if (lastName != null) 'lastname': lastName,
      if (phone != null) 'phone': phone.replaceAll("+", ""),
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (confirmPassword != null) 'password_confirmation': confirmPassword,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put('/api/v1/dashboard/user/profile/update', data: data);
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<DeliveryResponse>> editCarInfo({
    required String type, required String brand, required String model, required String number, required String color,
    required String height, required String weight, required String length, required String width, String? imageUrl,
  }) async {
    final data = {
      'type_of_technique': type, 'brand': brand, 'model': model, 'number': number, 'color': color,
      'height': int.tryParse(height) ?? 0, 'width': int.tryParse(width) ?? 0, 'kg': int.tryParse(weight) ?? 0, 'length': int.tryParse(length) ?? 0,
      "online": (LocalStorage.getUser()?.active ?? false) ? 1 : 0, if (imageUrl != null) 'images[0]': imageUrl,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/deliveryman/settings', data: data);
      return ApiResult.success(data: DeliveryResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<DeliveryResponse>> createCarInfo({
    required String type, required String brand, required String model, required String number, required String color,
    required String height, required String weight, required String length, required String width, String? imageUrl,
  }) async {
    final data = {
      "data": {
        "type_of_technique": type, "brand": brand, "model": model, "number": number, "color": color,
        'height': int.tryParse(height) ?? 0, 'width': int.tryParse(width) ?? 0, 'kg': int.tryParse(weight) ?? 0, 'length': int.tryParse(length) ?? 0,
        "online": (LocalStorage.getUser()?.active ?? false) ? 1 : 0, if (imageUrl != null) 'images[0]': imageUrl,
      },
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/user/request-models', data: data);
      return ApiResult.success(data: DeliveryResponse.fromJson(response.data['data']));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<StatisticsOrderResponse>> getStatisticsOrder({DateTime? startTime, DateTime? endTime, int? page, int? perPage}) async {
      final data = {
        if (endTime != null) "date_from": endTime.toString().substring(0, 10),
        if (startTime != null) "date_to": startTime.toString().substring(0, 10),
        "page": page, "perPage": perPage ?? 10,
      };
      try {
        final client = dioHttp.client(requireAuth: true);
        final response = await client.get('/api/v1/dashboard/seller/orders/report/paginate', queryParameters: data);
        return ApiResult.success(data: StatisticsOrderResponse.fromJson(response.data));
      } catch (e) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e));
      }
  }

  @override
  Future<ApiResult<StatisticsIncomeResponse>> getStatistics({required DateTime startTime, required DateTime endTime}) async {
      final data = {"date_from": endTime.toString().substring(0, 10), "date_to": startTime.toString().substring(0, 10), "type": "day"};
      try {
        final client = dioHttp.client(requireAuth: true);
        final response = await client.get('/api/v1/dashboard/deliveryman/order/report', queryParameters: data);
        return ApiResult.success(data: StatisticsIncomeResponse.fromJson(response.data));
      } catch (e) {
        return ApiResult.failure(error: AppHelpers.errorHandler(e));
      }
  }

  @override
  Future<ApiResult<RequestModelResponse>> getRequestModel() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final res = await client.get('/api/v1/dashboard/user/request-models');
      return ApiResult.success(data: RequestModelResponse.fromJson(res.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> setOnline() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/deliveryman/settings/online');
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> setCurrentLocation(LatLng location) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final res = await client.post('/api/v1/dashboard/deliveryman/settings/location', data: {"location": LocalLocationData(latitude: location.latitude, longitude: location.longitude).toJson()});
      LocalStorage.setDeliveryInfo(DeliveryResponse.fromJson(res.data));
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<void>> updateDeliveryZones({required List<LatLng> points}) async {
    final tapped = points.map((p) => {'0': p.latitude, '1': p.longitude}).toList();
    try {
      final client = dioHttp.client(requireAuth: true);
      // Both seller and deliveryman use similar endpoints but one might need shop_id
      await client.post('/api/v1/dashboard/deliveryman/delivery-zones', data: {'address': tapped});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<DeliveryZonePaginate>> getDeliveryZone() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/deliveryman/delivery-zones', queryParameters: {'perPage': 1});
      return ApiResult.success(data: DeliveryZonePaginate.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  // --- Manager Specific ---

  @override
  Future<ApiResult<ProfileResponse>> createUser({required String firstname, required String lastname, required String phone, required String email}) async {
    final data = {'firstname': firstname, 'lastname': lastname, 'email': email, 'phone': phone.replaceAll("+", ""), 'role': 'user'};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/seller/users', data: data);
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<void>> updateShopWorkingDays({required List<ShopWorkingDays> workingDays, String? uuid}) async {
    final days = workingDays.map((w) => {'day': w.day, 'from': w.from, 'to': w.to, 'disabled': w.disabled}).toList();
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.put('/api/v1/dashboard/seller/shop-working-days/${uuid ?? LocalStorage.getShop()?.uuid}', data: {'dates': days});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<SingleShopResponse>> updateShop({
    String? tax, num? percentage, String? phone, String? type, num? pricePerKm, String? minAmount, num? price,
    String? backImg, String? orderPayment, String? logoImg, List<CategoryData>? categories, List<ShopTag>? tags,
    DeliveryTime? deliveryTime, Translation? translation,
  }) async {
    final data = {
      'tax': tax, if (percentage != null) 'percentage': percentage, 'phone': phone?.replaceAll("+", ""), 'type': type,
      if (pricePerKm != null) 'price_per_km': pricePerKm, if (orderPayment != null) 'order_payment': orderPayment,
      'min_amount': minAmount, if (price != null) 'price': price,
      'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': translation?.title},
      'description': {LocalStorage.getSystemLanguage()?.locale ?? 'en': translation?.description},
      'address': {LocalStorage.getSystemLanguage()?.locale ?? 'en': translation?.address},
      'images': [logoImg, backImg],
      'delivery_time_type': deliveryTime?.type, 'delivery_time_from': deliveryTime?.from, 'delivery_time_to': deliveryTime?.to,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put('/api/v1/dashboard/seller/shops', data: data);
      return ApiResult.success(data: SingleShopResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<UsersPaginateResponse>> searchUsers({String? query, int? page}) async {
    final data = {if (query != null) 'search': query, 'perPage': 14, if (page != null) 'page': page, 'sort': 'desc', 'column': 'created_at'};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/users/paginate', queryParameters: data);
      return ApiResult.success(data: UsersPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<SingleShopResponse>> getMyShop() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/shops', queryParameters: {'lang': LocalStorage.getLanguage()?.locale, 'currency_id': LocalStorage.getSelectedCurrency()?.id});
      return ApiResult.success(data: SingleShopResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> setOnlineOffline() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/seller/shops/working/status');
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
