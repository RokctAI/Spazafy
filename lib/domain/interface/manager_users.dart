import 'package:rokctapp/infrastructure/models/response/users_paginate_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/statistics_response.dart';
import 'package:rokctapp/infrastructure/models/response/statistics_order_response.dart';
import 'package:rokctapp/infrastructure/models/request/edit_profile.dart';
import 'package:rokctapp/infrastructure/models/data/category_data.dart';
import 'package:rokctapp/infrastructure/models/data/manager/shop_data.dart';
import 'package:rokctapp/infrastructure/models/response/delivery_zone_paginate.dart';
import 'package:rokctapp/infrastructure/models/data/translation.dart' as mgr;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/profile_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_shop_response.dart';
import 'package:rokctapp/infrastructure/models/models.dart' as root_models;

abstract class UsersInterface {
  Future<ApiResult<ProfileResponse>> createUser({
    required String firstname,
    required String lastname,
    required String phone,
    required String email,
  });

  Future<ApiResult<StatisticsResponse>> getStatistics({
    required DateTime startTime,
    required DateTime endTime,
  });

  Future<ApiResult<StatisticsOrderResponse>> getStatisticsOrder({
    DateTime? startTime,
    DateTime? endTime,
    int? page,
    int? perPage,
  });

  Future<ApiResult<void>> updateDeliveryZones({required List<LatLng> points});

  Future<ApiResult<DeliveryZonePaginate>> getDeliveryZone();

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
    root_models.DeliveryTime? deliveryTime,
    mgr.Translation? translation,
  });

  Future<ApiResult<UsersPaginateResponse>> searchUsers({
    String? query,
    int? page,
  });

  Future<ApiResult<SingleShopResponse>> getMyShop();

  Future<ApiResult<dynamic>> setOnlineOffline();

  Future<ApiResult<ProfileResponse>> getProfileDetails();

  Future<ApiResult<ProfileResponse>> editProfile({required EditProfile? user});

  Future<ApiResult<ProfileResponse>> updateProfileImage({
    required String firstName,
    required String imageUrl,
  });

  Future<ApiResult<ProfileResponse>> updatePassword({
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResult<void>> updateFirebaseToken(String? token);

  Future<ApiResult<dynamic>> deleteAccount();
}
