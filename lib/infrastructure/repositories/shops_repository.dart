import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/shops.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/infrastructure/models/data/filter_model.dart';

class ShopsRepository implements ShopsRepositoryFacade {
  @override
  Future<ApiResult<ShopsPaginateResponse>> searchShops({
    required String text,
    String? categoryId,
  }) async {
    final params = {
      'search': text,
      if (categoryId != null) 'category_id': categoryId,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.search_shops',
        queryParameters: params,
      );
      final responseData = ShopsPaginateResponse.fromJson(response.data);

      // Persistence: Cache searched shops
      if (responseData.data != null) {
        for (final shop in responseData.data!) {
          await appDatabase.upsertShop(shop.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> search shops failure: $e');

      // Fallback: search locally
      try {
        final localShops = await appDatabase.getShopsLocally(
          categoryId: categoryId,
        );
        if (localShops.isNotEmpty) {
          final filtered = localShops
              .map((e) => ShopData.fromJson(e))
              .where((s) =>
                  (s.translation?.title
                          ?.toLowerCase()
                          .contains(text.toLowerCase()) ??
                      false))
              .toList();

          return ApiResult.success(
            data: ShopsPaginateResponse(data: filtered),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getAllShops(
    int page, {
    String? categoryId,
    FilterModel? filterModel,
    bool? isOpen,
    bool? verify,
  }) async {
    final params = {
      'limit_start': (page - 1) * 10,
      'limit_page_length': 10,
      if (categoryId != null) 'category_id': categoryId,
      if (filterModel?.sort != null) 'order_by': filterModel!.sort,
      if (isOpen ?? false) 'open': 1,
      if (verify ?? false) 'verify': 1,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_shops',
        queryParameters: params,
      );
      final responseData = ShopsPaginateResponse.fromJson(response.data);

      // Persistence: Cache shops locally on success (first page)
      if (responseData.data != null && page == 1) {
        for (final shop in responseData.data!) {
          await appDatabase.upsertShop(shop.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get all shops failure: $e');

      // Fallback: If network fails, try fetching from local DB
      try {
        final localShops = await appDatabase.getShopsLocally(
          categoryId: categoryId,
        );
        if (localShops.isNotEmpty) {
          return ApiResult.success(
            data: ShopsPaginateResponse(
              data: localShops.map((e) => ShopData.fromJson(e)).toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleShopResponse>> getSingleShop({
    required String uuid,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_shop_by_uuid',
        queryParameters: {'uuid': uuid},
      );
      final responseData = SingleShopResponse.fromJson(response.data);

      // Persistence: Cache single shop info
      if (responseData.data != null) {
        await appDatabase.upsertShop(responseData.data!.toJson());
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get single shop failure: $e');

      // Fallback
      try {
        final localShop = await appDatabase.getItem('shop', uuid);
        if (localShop != null) {
          return ApiResult.success(
            data: SingleShopResponse(data: ShopData.fromJson(localShop)),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> checkDriverZone(
    LatLng location, {
    String? shopId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final data = {
        'latitude': location.latitude,
        'longitude': location.longitude,
        if (shopId != null) 'shop_id': shopId,
      };
      final response = await client.get(
        '/api/method/paas.api.shop.shop.check_delivery_zone',
        queryParameters: data,
      );
      return ApiResult.success(data: response.data["status"] == "success");
    } catch (e) {
      debugPrint('==> get delivery zone failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // NOTE: The following methods are not supported by the new backend or have been consolidated.
  // - getNearbyShops
  // - getShopBranch
  // - joinOrder
  // - getShopFilter
  // - getPickupShops
  // - getShopsByIds
  // - createShop
  // - getShopsRecommend
  // - getStory
  // - getTags
  // - getSuggestPrice

  @override
  Future<ApiResult<ShopsPaginateResponse>> getNearbyShops(
    double latitude,
    double longitude,
  ) async {
    final params = {'latitude': latitude, 'longitude': longitude};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_nearby_shops',
        queryParameters: params,
      );
      final responseData = ShopsPaginateResponse.fromJson(response.data);

      // Persistence: Cache nearby shops
      if (responseData.data != null) {
        for (final shop in responseData.data!) {
          await appDatabase.upsertShop(shop.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get nearby shops failure: $e');

      // Fallback: Show all local shops since we can't easily do geo-filtering here
      try {
        final localShops = await appDatabase.getShopsLocally();
        if (localShops.isNotEmpty) {
          return ApiResult.success(
            data: ShopsPaginateResponse(
              data: localShops.map((e) => ShopData.fromJson(e)).toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BranchResponse>> getShopBranch({
    required String uuid,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_shop_branch',
        queryParameters: {'shop_id': uuid},
      );
      return ApiResult.success(data: BranchResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get shop branch failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> joinOrder({
    required String shopId,
    required String name,
    required String cartId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.shop.shop.join_order',
        data: {'shop_id': shopId, 'name': name, 'cart_id': cartId},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> join order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopFilter({
    String? categoryId,
    required int page,
    String? subCategoryId,
  }) async {
    return getAllShops(page, categoryId: categoryId);
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getPickupShops() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_pickup_shops',
      );
      final responseData = ShopsPaginateResponse.fromJson(response.data);

      // Persistence: Cache pickup shops
      if (responseData.data != null) {
        for (final shop in responseData.data!) {
          await appDatabase.upsertShop(shop.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get pickup shops failure: $e');

      // Fallback
      try {
        final localShops = await appDatabase.getShopsLocally();
        if (localShops.isNotEmpty) {
          return ApiResult.success(
            data: ShopsPaginateResponse(
              data: localShops.map((e) => ShopData.fromJson(e)).toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsByIds(
    List<String> shopIds,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_shops_by_ids',
        queryParameters: {'ids': shopIds},
      );
      final responseData = ShopsPaginateResponse.fromJson(response.data);

      // Persistence: Cache these shops
      if (responseData.data != null) {
        for (final shop in responseData.data!) {
          await appDatabase.upsertShop(shop.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get shops by ids failure: $e');

      // Fallback: Fetch from local DB
      try {
        List<ShopData> localShops = [];
        for (final id in shopIds) {
          final data = await appDatabase.getItem('shop', id);
          if (data != null) {
            localShops.add(ShopData.fromJson(data));
          }
        }
        if (localShops.isNotEmpty) {
          return ApiResult.success(
            data: ShopsPaginateResponse(data: localShops),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> createShop({
    required double tax,
    required List<String> documents,
    required double deliveryTo,
    required double deliveryFrom,
    required String deliveryType,
    required String phone,
    required String name,
    required String category,
    required String description,
    required double startPrice,
    required double perKm,
    AddressNewModel? address,
    String? logoImage,
    String? backgroundImage,
  }) async {
    final data = {
      'tax': tax,
      'documents': documents,
      'delivery_to': deliveryTo,
      'delivery_from': deliveryFrom,
      'delivery_type': deliveryType,
      'phone': phone,
      'name': name,
      'category': category,
      'description': description,
      'start_price': startPrice,
      'per_km': perKm,
      if (address != null) 'address': address.toJson(),
      if (logoImage != null) 'logo': logoImage,
      if (backgroundImage != null) 'background': backgroundImage,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.shop.shop.create_shop',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> create shop failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsRecommend(int page) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_shops_recommend',
        queryParameters: {'page': page},
      );
      final responseData = ShopsPaginateResponse.fromJson(response.data);

      // Persistence: Cache recommended shops (first page)
      if (responseData.data != null && page == 1) {
        for (final shop in responseData.data!) {
          await appDatabase.upsertShop(shop.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get recommended shops failure: $e');

      // Fallback
      try {
        final localShops = await appDatabase.getShopsLocally();
        if (localShops.isNotEmpty) {
          return ApiResult.success(
            data: ShopsPaginateResponse(
              data: localShops.map((e) => ShopData.fromJson(e)).toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<List<StoryModel?>?>?>> getStory(int page) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.get_story',
        queryParameters: {'page': page},
      );
      return ApiResult.success(
        data: storyModelFromJson(response.data['message']),
      );
    } catch (e) {
      debugPrint('==> get story failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TagResponse>> getTags(String categoryId) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_tags',
        queryParameters: {'category_id': categoryId},
      );
      return ApiResult.success(data: TagResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get tags failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<PriceModel>> getSuggestPrice() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.shop.shop.get_suggest_price',
      );
      return ApiResult.success(
        data: PriceModel.fromJson(response.data['message']),
      );
    } catch (e) {
      debugPrint('==> get suggest price failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
