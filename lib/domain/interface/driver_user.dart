import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/statistics_response.dart';
import 'package:rokctapp/infrastructure/models/response/statistics_order_response.dart';
import 'package:rokctapp/infrastructure/models/response/request_model_response.dart';
import 'package:rokctapp/infrastructure/models/request/edit_profile.dart';
import 'package:rokctapp/infrastructure/models/response/profile_response.dart';
import 'package:rokctapp/infrastructure/models/response/statistics_income_response.dart';
import 'package:rokctapp/infrastructure/models/response/driver_show_response.dart';
import 'package:rokctapp/infrastructure/models/response/delivery_zone_paginate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart' hide ApiResult;

abstract class UserRepository {
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

  Future<ApiResult<ProfileResponse>> getProfileDetails();

  Future<ApiResult<RequestModelResponse>> getRequestModel();

  Future<ApiResult<dynamic>> setOnline();

  Future<ApiResult<dynamic>> setCurrentLocation(LatLng location);

  Future<ApiResult<ProfileResponse>> editProfile({required EditProfile? user});

  Future<ApiResult<ProfileResponse>> updateProfileImage({
    String? firstName,
    String? imageUrl,
  });

  Future<ApiResult<ProfileResponse>> updatePassword({
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResult<void>> updateFirebaseToken(String? token);

  Future<ApiResult<dynamic>> deleteAccount();

  Future<ApiResult<void>> updateDeliveryZones({required List<LatLng> points});

  Future<ApiResult<DeliveryZonePaginate>> getDeliveryZone();
}
