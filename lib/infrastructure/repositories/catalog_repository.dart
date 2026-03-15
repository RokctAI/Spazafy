import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/categories.dart'; // Ensure correct interface
import 'package:venderfoodyman/domain/interface/interfaces.dart'; // For CatalogInterface
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';

class CatalogRepository implements CategoriesFacade, CatalogInterface {
  // --- Common & Customer (Frappe/PaaS) ---

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getAllCategories({
    required int page,
    String? shopId,
  }) async {
    final params = {
      'limit_start': (page - 1) * 10,
      'limit_page_length': 10,
      if (shopId != null) 'shop_id': shopId,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      // Try PaaS first
      try {
        final response = await client.get('/api/method/paas.api.get_categories',
            queryParameters: params);
        return ApiResult.success(
            data: CategoriesPaginateResponse.fromJson(response.data));
      } catch (e) {
        // Fallback to V1 (from manager/catalog_repository)
        return getCategories(page: page);
      }
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> searchCategories(
      {required String text}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
          '/api/method/paas.api.search_categories',
          queryParameters: {'search': text});
      return ApiResult.success(
          data: CategoriesPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesByShop(
      {required String shopId}) async {
    return getAllCategories(page: 1, shopId: shopId);
  }

  // --- Manager Specific (V1) ---

  @override
  Future<ApiResult<UnitsPaginateResponse>> getUnits() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client
          .get('/api/v1/dashboard/seller/units/paginate', queryParameters: {
        'lang': LocalStorage.getLanguage()?.locale,
        'perPage': 100
      });
      return ApiResult.success(
          data: UnitsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<KitchensPaginateResponse>> getKitchens() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/kitchen/',
          queryParameters: {
            'lang': LocalStorage.getLanguage()?.locale,
            'perPage': 100
          });
      return ApiResult.success(
          data: KitchensPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<void>> createCategory(
      {required String title, int? input}) async {
    final data = {
      'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': title},
      'active': 1,
      if (input != null) 'input': input,
      'type': 'main',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      // Try PaaS (later) or V1
      await client.post('/api/v1/dashboard/seller/categories', data: data);
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategories(
      {int? page,
      String? query,
      String? type,
      bool hasProducts = false}) async {
    final shopId = LocalStorage.getUser()?.shop?.id;
    final data = {
      if (page != null) 'page': page,
      if (query != null) 'search': query,
      'perPage': 100,
      'lang': LocalStorage.getLanguage()?.locale,
      'type': type ?? 'main',
      if (hasProducts) 'has_products': 1,
      if (hasProducts)
        if (type == 'combo') 'c_shop_id': shopId else 'p_shop_id': shopId,
      'active': '1',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/categories',
          queryParameters: data);
      return ApiResult.success(
          data: CategoriesPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getShopCategories(
      {int? page, String? query}) async {
    return getCategories(page: page, query: query, hasProducts: true);
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesSub(
      {int? page, String? query}) async {
    return getCategories(page: page, query: query, type: 'sub_shop');
  }

  @override
  Future<ApiResult> deleteCategory({required String? id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete('/api/v1/dashboard/seller/categories/delete',
          queryParameters: {'ids[0]': id});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
