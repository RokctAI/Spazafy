import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/shops.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/data/filter_model.dart';

class ShopsRepository implements ShopsFacade {
  // --- Common & Customer (Frappe/ERPNext) ---

  @override
  Future<ApiResult<ShopsPaginateResponse>> searchShops({required String text, String? categoryId}) async {
    final params = {'search': text, if (categoryId != null) 'category_id': categoryId};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.search_shops', queryParameters: params);
      return ApiResult.success(data: ShopsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getAllShops(int page, {String? categoryId, FilterModel? filterModel, required bool isOpen, bool? verify}) async {
    final params = {
      'limit_start': (page - 1) * 10, 'limit_page_length': 10,
      if (categoryId != null) 'category_id': categoryId,
      if (filterModel?.sort != null) 'order_by': filterModel!.sort,
      if (isOpen) 'open': 1, if (verify ?? false) 'verify': 1,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_shops', queryParameters: params);
      return ApiResult.success(data: ShopsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<SingleShopResponse>> getSingleShop({required String uuid}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_shop_by_uuid', queryParameters: {'uuid': uuid});
      return ApiResult.success(data: SingleShopResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<bool>> checkDriverZone(LatLng location, {String? shopId}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.check_delivery_zone', queryParameters: {'latitude': location.latitude, 'longitude': location.longitude, if (shopId != null) 'shop_id': shopId});
      return ApiResult.success(data: response.data["status"] == "success");
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<void>> createShop({
    required double tax, required List<String> documents, required double deliveryTo, required double deliveryFrom,
    required String deliveryType, required String phone, required String name, required String category,
    required String description, required double startPrice, required double perKm, required AddressNewModel address,
    String? logoImage, String? backgroundImage,
  }) async {
    final data = {
      'tax': tax, 'documents': documents, 'delivery_to': deliveryTo, 'delivery_from': deliveryFrom, 'delivery_type': deliveryType,
      'phone': phone.replaceAll('+', ""), 'name': name, 'category': category, 'description': description,
      'start_price': startPrice, 'per_km': perKm, 'address': address.toJson(),
      'title': {LocalStorage.getLanguage()?.locale ?? "en": name},
      'location': {'latitude': address.latitude, 'longitude': address.longitude},
      if (logoImage != null) 'logo': logoImage, if (backgroundImage != null) 'background': backgroundImage,
      if (logoImage != null) 'images': [logoImage, backgroundImage],
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      // Try PaaS endpoint
      try {
        await client.post('/api/method/paas.api.shop.shop.create_shop', data: data);
        return const ApiResult.success(data: null);
      } catch (e) {
        // Fallback to V1
        await client.post('/api/v1/dashboard/user/shops', data: data);
        return const ApiResult.success(data: null);
      }
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  // --- Helpers & Proxies ---

  @override
  Future<ApiResult<ShopsPaginateResponse>> getNearbyShops(double latitude, double longitude) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_nearby_shops', queryParameters: {'latitude': latitude, 'longitude': longitude});
      return ApiResult.success(data: ShopsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<BranchResponse>> getShopBranch({required String uuid}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_shop_branch', queryParameters: {'shop_id': uuid});
      return ApiResult.success(data: BranchResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult> joinOrder({required String shopId, required String name, required String cartId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.shop.shop.join_order', data: {'shop_id': shopId, 'name': name, 'cart_id': cartId});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopFilter({String? categoryId, required int page, String? subCategoryId}) => getAllShops(page, categoryId: categoryId, isOpen: false);

  @override
  Future<ApiResult<ShopsPaginateResponse>> getPickupShops() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_pickup_shops');
      return ApiResult.success(data: ShopsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsByIds(List<String> shopIds) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_shops_by_ids', queryParameters: {'ids': shopIds});
      return ApiResult.success(data: ShopsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsRecommend(int page) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_shops_recommend', queryParameters: {'page': page});
      return ApiResult.success(data: ShopsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<List<List<StoryModel?>?>?>> getStory(int page) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.get_story', queryParameters: {'page': page});
      return ApiResult.success(data: storyModelFromJson(response.data['message']));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TagResponse>> getTags(String categoryId) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_tags', queryParameters: {'category_id': categoryId});
      return ApiResult.success(data: TagResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<PriceModel>> getSuggestPrice() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.shop.shop.get_suggest_price');
      return ApiResult.success(data: PriceModel.fromJson(response.data['message']));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
