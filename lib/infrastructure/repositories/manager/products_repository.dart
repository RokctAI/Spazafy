import 'package:rokctapp/infrastructure/services/constants/manager/enums.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/manager/create_group_extras_response.dart';
import 'package:rokctapp/infrastructure/models/data/manager/stock.dart';
import 'package:rokctapp/infrastructure/models/response/manager/single_extras_group_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/extras_groups_response.dart';
import 'package:rokctapp/infrastructure/models/response/products_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_product_response.dart';
import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/response/manager/group_extras_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/calculate_response.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

import 'package:rokctapp/infrastructure/models/response/products_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/response/single_product_response.dart';
import 'package:rokctapp/domain/interface/manager_products.dart';

class ProductsRepository implements ProductsInterface {
  @override
  Future<ApiResult<void>> deleteExtrasGroup({String? groupId}) async {
    final data = {
      'ids': [groupId],
    };
    debugPrint('====> delete extras group request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.delete_extras_group',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> delete extra group failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleExtrasGroupResponse>> updateExtrasGroup({
    required String title,
    String? groupId,
  }) async {
    final data = {
      'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': title},
      'type': 'text',
    };
    debugPrint('===> update extras group ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.update_extras_group',
        data: {...data, 'id': groupId},
      );
      return ApiResult.success(
        data: SingleExtrasGroupResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update extra groups failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteExtrasItem({required String extrasId}) async {
    final data = {
      'ids': [extrasId],
    };
    debugPrint('====> delete extras item request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.delete_extras_value',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> delete extra item failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CreateGroupExtrasResponse>> updateExtrasItem({
    required String extrasId,
    required String groupId,
    required String title,
  }) async {
    final data = {'value': title, 'extra_group_id': groupId};
    debugPrint('===> update extras item ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.update_extras_value',
        data: {...data, 'id': extrasId},
      );
      return ApiResult.success(
        data: CreateGroupExtrasResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update extra item failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CreateGroupExtrasResponse>> createExtrasItem({
    required String groupId,
    required String title,
  }) async {
    final data = {'value': title, 'extra_group_id': groupId};
    debugPrint('===> create extras item ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.create_extras_value',
        data: data,
      );
      return ApiResult.success(
        data: CreateGroupExtrasResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create extra item failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleExtrasGroupResponse>> createExtrasGroup({
    required String title,
  }) async {
    final data = {
      'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': title},
      'active': 1,
      'type': 'text',
    };
    debugPrint('===> create extras group ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.create_extras_group',
        data: data,
      );
      return ApiResult.success(
        data: SingleExtrasGroupResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create extra groups failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CalculateResponse>> getProductsCalculation(
    List<Stock> stocks,
  ) async {
    final data = {'currency_id': LocalStorage.getSelectedCurrency()?.id};
    for (int i = 0; i < stocks.length; i++) {
      data['products[$i][stock_id]'] = stocks[i].id;
      data['products[$i][quantity]'] = stocks[i].cartCount;
    }
    debugPrint('===> get calculation ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.order.order.get_calculate',
        data: data,
      );
      return ApiResult.success(data: CalculateResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> get calculations failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<GroupExtrasResponse>> getExtras({String? groupId}) async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_extras_values',
        queryParameters: {...data, 'id': groupId},
      );
      return ApiResult.success(
        data: GroupExtrasResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get extras failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateStocks({
    required List<Stock> stocks,
    required List<String> deletedStocks,
    String? uuid,
    bool isAddon = false,
  }) async {
    final List<Map<String, dynamic>> extras = [];
    for (final stock in stocks) {
      List<int> ids = [];
      List<int> addonsIds = [];
      if (stock.extras != null && (stock.extras?.isNotEmpty ?? false)) {
        for (final item in stock.extras!) {
          ids.add(int.tryParse(item.id ?? "0") ?? 0);
        }
      }
      ids = ids.toSet().toList();
      if (stock.localAddons != null &&
          (stock.localAddons?.isNotEmpty ?? false)) {
        for (final item in stock.localAddons!) {
          addonsIds.add(int.tryParse(item.product?.id ?? "0") ?? 0);
        }
      }
      addonsIds = addonsIds.toSet().toList();
      extras.add({
        'price': stock.price,
        if (stock.sku?.isNotEmpty ?? false) 'sku': stock.sku,
        'quantity': stock.quantity,
        if (stock.id != -1 && stock.id != null) "stock_id": stock.id,
        'ids': ids,
        if (addonsIds.isNotEmpty) 'addons': addonsIds,
      });
    }
    final data = {
      'extras': extras,
      if (isAddon) 'addon': 1,
      if (deletedStocks.isNotEmpty) 'delete_ids': deletedStocks,
    };
    debugPrint('===> update stocks request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.update_product_stocks',
        data: data,
        queryParameters: {'uuid': uuid},
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update stocks fail: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateProduct({
    required Map<String, List<String>> titlesAndDescriptions,
    required String tax,
    required String interval,
    required String minQty,
    required String maxQty,
    required bool active,
    String? qrcode,
    String? categoryId,
    String? unitId,
    String? kitchenId,
    List<String>? images,
    String? uuid,
    bool needAddons = false,
  }) async {
    final data = {
      'title': {
        for (int i = 0; i < titlesAndDescriptions.keys.length; i++)
          titlesAndDescriptions.keys.toList()[i]:
              titlesAndDescriptions[titlesAndDescriptions.keys.toList()[i]]
                  ?.first ??
              "",
      },
      'description': {
        for (String locale in titlesAndDescriptions.keys)
          locale: titlesAndDescriptions[locale]?.last ?? "",
      },
      'tax': num.tryParse(tax),
      'interval': num.tryParse(interval),
      'min_qty': int.tryParse(minQty),
      'max_qty': int.tryParse(maxQty),
      'active': active ? 1 : 0,
      if (qrcode != null) 'bar_code': qrcode,
      if (categoryId != null) 'category_id': categoryId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (unitId != null) 'unit_id': unitId,
      if (images != null) 'images': images,
      if (needAddons) 'addon': 1,
    };
    debugPrint('===> update product ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.update_product',
        data: {...data, 'product_id': uuid},
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update product fail: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateExtras({
    required List<String> extrasIds,
    String? productUuid,
  }) async {
    final data = {'extras': extrasIds};
    debugPrint('===> update extras ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.update_product_extras',
        data: {...data, 'product_id': productUuid},
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update extras failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ExtrasGroupsResponse>> getExtrasGroups({
    bool needOnlyValid = true,
  }) async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      if (needOnlyValid) 'valid': true,
      "perPage": 50,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_extras_groups',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ExtrasGroupsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get extras groups failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> createProduct({
    required String title,
    required String description,
    required String tax,
    required String interval,
    required String minQty,
    required String maxQty,
    required String qrcode,
    required bool active,
    String? categoryId,
    String? kitchenId,
    String? unitId,
    List<String>? images,
    bool isAddon = false,
    String type = 'single',
    String? uid,
  }) async {
    final data = {
      'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': title},
      'description': {
        LocalStorage.getSystemLanguage()?.locale ?? 'en': description,
      },
      'tax': num.tryParse(tax),
      'interval': num.tryParse(interval),
      'min_qty': num.tryParse(minQty),
      'max_qty': num.tryParse(maxQty),
      'active': active ? 1 : 0,
      'type': type,
      if (qrcode.isNotEmpty) 'sku': qrcode,
      if (uid != null && uid.isNotEmpty) 'uid': uid,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (categoryId != null) 'category_id': categoryId,
      if (unitId != null) 'unit_id': unitId,
      if (images != null) 'images': images,
      if (isAddon) 'addon': 1,
    };
    debugPrint('===> create product ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.seller_product.seller_product.create_product',
        data: data,
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create product fail: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(
    String uuid,
  ) async {
    final data = {
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_product_details',
        queryParameters: {...data, 'product_id': uuid},
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get product details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProducts({
    int? page,
    String? categoryId,
    String? query,
    ProductStatus? status,
    bool needAddons = false,
    bool active = false,
    String? type,
  }) async {
    String? statusText;
    if (status != null) {
      switch (status) {
        case ProductStatus.pending:
          statusText = 'pending';
          break;
        case ProductStatus.published:
          statusText = 'published';
          break;
        case ProductStatus.unpublished:
          statusText = 'unpublished';
          break;
      }
    }
    final data = {
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      if (page != null) 'page': page,
      if (categoryId != null) 'category_id': categoryId,
      if (query != null) 'search': query,
      if (statusText != null) 'status': statusText,
      if (needAddons) 'addon': 1,
      if (type != null) 'type': type,
      'perPage': 10,
      'addon_status': "published",
      if (active) "active": 1,
      if (active) "status": "published",
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.seller_product.seller_product.get_seller_products_paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
