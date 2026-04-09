import 'package:rokctapp/infrastructure/models/response/manager/users_paginate_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/driver/statistics_response.dart';
import 'package:rokctapp/infrastructure/models/response/driver/statistics_order_response.dart';
import 'package:rokctapp/infrastructure/models/request/edit_profile.dart';
import 'package:rokctapp/infrastructure/models/data/manager/category_data.dart';
import 'package:rokctapp/infrastructure/models/data/manager/shop_data.dart';
import 'package:rokctapp/infrastructure/models/response/driver/delivery_zone_paginate.dart';
import 'package:rokctapp/infrastructure/models/data/manager/translation.dart'
    as mgr;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/models/models.dart' as root_models;
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/profile_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_shop_response.dart';
import 'package:rokctapp/domain/interface/manager_users.dart';

class UsersRepository implements UsersInterface {
  @override
  Future<ApiResult<ProfileResponse>> createUser({
    required String firstname,
    required String lastname,
    required String phone,
    required String email,
  }) async {
    final data = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone.replaceAll("+", ""),
      'role': 'user',
    };
    debugPrint('===> create user ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_user.seller_user.create_seller_user',
        data: data,
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('===> create user fail $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<StatisticsResponse>> getStatistics({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final data = {
        "date_from": endTime.toString().substring(
          0,
          endTime.toString().indexOf(" "),
        ),
        "date_to": startTime.toString().substring(
          0,
          startTime.toString().indexOf(" "),
        ),
        "type": "day",
      };
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_report.seller_report.get_order_report',
        queryParameters: data,
      );
      return ApiResult.success(
        data: StatisticsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('===> get statistics error $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<StatisticsOrderResponse>> getStatisticsOrder({
    DateTime? startTime,
    DateTime? endTime,
    int? page,
    int? perPage,
  }) async {
    try {
      final data = {
        if (endTime != null)
          "date_from": endTime.toString().substring(
            0,
            endTime.toString().indexOf(" "),
          ),
        if (startTime != null)
          "date_to": startTime.toString().substring(
            0,
            startTime.toString().indexOf(" "),
          ),
        "page": page,
        "perPage": perPage ?? 10,
      };
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_report.seller_report.get_order_report_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: StatisticsOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('===> get statistics order error $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> updateDeliveryZones({
    required List<LatLng> points,
  }) async {
    List<Map<String, dynamic>> tapped = [];
    for (final point in points) {
      final location = {'0': point.latitude, '1': point.longitude};
      tapped.add(location);
    }
    final data = {'shop_id': LocalStorage.getShop()?.id, 'address': tapped};
    debugPrint('====> update delivery zone ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.delivery_zone.delivery_zone.update_shop_delivery_zones',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> update delivery zones failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<DeliveryZonePaginate>> getDeliveryZone() async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'perPage': 1,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.delivery_zone.delivery_zone.get_shop_delivery_zones',
        queryParameters: data,
      );
      return ApiResult.success(
        data: DeliveryZonePaginate.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('===> error get delivery zone $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> updateShopWorkingDays({
    required List<root_models.ShopWorkingDays> workingDays,
    String? uuid,
  }) async {
    List<Map<String, dynamic>> days = [];
    for (final workingDay in workingDays) {
      final data = {
        'day': workingDay.day,
        'from': workingDay.from,
        'to': workingDay.to,
        'disabled': workingDay.disabled,
      };
      days.add(data);
    }
    final data = {'dates': days};
    debugPrint('====> update working days ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_shop_settings.seller_shop_settings.update_shop_working_days',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> update shop working days failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
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
    root_models.DeliveryTime? deliveryTime,
    mgr.Translation? translation,
    List<root_models.ShopTag>? tags,
  }) async {
    List<String> categoryIds = [];
    List<String> tagIds = [];
    if (categories != null && categories.isNotEmpty) {
      for (int i = 0; i < categories.length; i++) {
        categoryIds.add(categories[i].id ?? "");
      }
    }
    if (tags != null && tags.isNotEmpty) {
      for (int i = 0; i < tags.length; i++) {
        tagIds.add(tags[i].id ?? "");
      }
    }
    categoryIds = categoryIds.toSet().toList();
    tagIds = tagIds.toSet().toList();
    final data = {
      'tax': tax,
      if (percentage != null) 'percentage': percentage,
      'phone': phone?.replaceAll("+", ""),
      'type': type,
      if (pricePerKm != null) 'price_per_km': pricePerKm,
      if (orderPayment != null) 'order_payment': orderPayment,
      'min_amount': minAmount,
      if (price != null) 'price': price,
      'title': {
        LocalStorage.getSystemLanguage()?.locale ?? 'en': translation?.title,
      },
      'description': {
        LocalStorage.getSystemLanguage()?.locale ?? 'en':
            translation?.description,
      },
      'address': {
        LocalStorage.getSystemLanguage()?.locale ?? 'en': translation?.address,
      },
      'images': [logoImg, backImg],
      // 'categories': categoryIds,
      //   'tags': tagIds,
      'delivery_time_type': deliveryTime?.type,
      'delivery_time_from': deliveryTime?.from,
      'delivery_time_to': deliveryTime?.to,
    };
    debugPrint('====> update shop ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_shop.seller_shop.update_shop',
        data: data,
      );
      return ApiResult.success(
        data: SingleShopResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update shop failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<UsersPaginateResponse>> searchUsers({
    String? query,
    int? page,
  }) async {
    final data = {
      if (query != null) 'search': query,
      'perPage': 14,
      if (page != null) 'page': page,
      'sort': 'desc',
      'column': 'created_at',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.user.user.search_user',
        queryParameters: data,
      );
      return ApiResult.success(
        data: UsersPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> search users failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleShopResponse>> getMyShop() async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_shop.seller_shop.get_shop',
        queryParameters: data,
      );
      return ApiResult.success(
        data: SingleShopResponse.fromJson(response.data),
      );
    } catch (e, s) {
      debugPrint('===> error fetching my shop $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> setOnlineOffline() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_shop.seller_shop.set_shop_working_status',
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('===> error switch shop online $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> getProfileDetails() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.user.user.get_profile',
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
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
    debugPrint('===> update general info data ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.update_profile',
        data: data,
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> update profile details failure: $e');
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
    final data = {
      'firstname': firstName,
      'images': [imageUrl],
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.update_profile',
        data: data,
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> update profile image failure: $e');
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
    final data = {
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.user.user.update_password',
        data: data,
      );
      return ApiResult.success(data: ProfileResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> update password failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> updateFirebaseToken(String? token) async {
    final data = {if (token != null) 'firebase_token': token};
    debugPrint('===> update firebase token ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.user.user.update_firebase_token',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> update firebase token failure: $e');
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
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
