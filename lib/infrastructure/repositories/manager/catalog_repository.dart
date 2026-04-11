import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart';
import 'package:rokctapp/domain/interface/manager_catalog.dart';
import 'package:rokctapp/infrastructure/models/response/manager/kitchens_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/units_paginate_response.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';


import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';




class CatalogRepository implements CatalogInterface {
  @override
  Future<ApiResult<UnitsPaginateResponse>> getUnits() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale, 'perPage': 100};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_seller_units',
        queryParameters: data,
      );
      return ApiResult.success(
        data: UnitsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get units paginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<KitchensPaginateResponse>> getKitchens() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale, 'perPage': 100};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_operations.seller_operations.get_seller_kitchens',
        queryParameters: data,
      );
      return ApiResult.success(
        data: KitchensPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get kitchens paginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> createCategory({
    required String title,
    String? input,
  }) async {
    final data = {
      'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': title},
      'active': 1,
      'input': input,
      'type': 'main',
    };
    debugPrint('===> create category request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.create_seller_category',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> create category failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategories({
    int? page,
    String? query,
    String? type,
    bool hasProducts = false,
  }) async {
    final shopId = LocalStorage.getUser()?.shop?.id ?? "0";
    final data = {
      if (page != null) 'page': page,
      if (query != null) 'search': query,
      'perPage': 100,
      'lang': LocalStorage.getLanguage()?.locale,
      if (type != null) 'type': type,
      if (type == null) 'type': 'main',
      if (hasProducts) 'has_products': 1,
      if (hasProducts)
        if (type == 'combo') 'c_shop_id': shopId else 'p_shop_id': shopId,
      'active': '1',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_seller_categories',
        queryParameters: data,
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get categories paginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getShopCategories({
    int? page,
    String? query,
  }) async {
    final data = {
      if (page != null) 'page': page,
      if (query != null) 'search': query,
      'perPage': 100,
      'lang': LocalStorage.getLanguage()?.locale,
      'type': 'main',
      "has_products": 1,
      "p_shop_id": LocalStorage.getUser()?.shop?.id ?? "0",
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_seller_categories',
        queryParameters: data,
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get categories paginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesSub({
    int? page,
    String? query,
  }) async {
    final data = {
      if (page != null) 'page': page,
      if (query != null) 'search': query,
      'perPage': 100,
      'lang': LocalStorage.getLanguage()?.locale,
      'type': 'sub_shop',
      'active': '1',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_seller_categories',
        queryParameters: data,
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get categories paginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> deleteCategory({required String? id}) async {
    final data = {'ids[0]': id};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.delete_seller_category',
        data: {
          'ids': [id],
        },
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> delete categories failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}

