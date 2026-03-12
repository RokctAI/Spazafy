import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';
import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/domain/interface/interfaces.dart';
import 'package:venderfoodyman/infrastructure/services/app_database.dart';
import 'package:venderfoodyman/main.dart';

class ProductsRepository implements ProductsInterface {
  @override
  Future<ApiResult<void>> deleteExtrasGroup({String? groupId}) async {
    final data = {
      'ids': [groupId],
    };
    debugPrint('====> delete extras group request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete(
        '/api/v1/dashboard/seller/extra/groups/delete',
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
      final response = await client.put(
        '/api/v1/dashboard/seller/extra/groups/$groupId',
        data: data,
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
  Future<ApiResult<void>> deleteExtrasItem({required String? extrasId}) async {
    final data = {
      'ids': [extrasId],
    };
    debugPrint('====> delete extras item request ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete(
        '/api/v1/dashboard/seller/extra/values/delete',
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
    required String? extrasId,
    required String? groupId,
    required String title,
  }) async {
    final data = {'value': title, 'extra_group_id': groupId};
    debugPrint('===> update extras item ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put(
        '/api/v1/dashboard/seller/extra/values/$extrasId',
        data: data,
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
    required String? groupId,
    required String title,
  }) async {
    final data = {'value': title, 'extra_group_id': groupId};
    debugPrint('===> create extras item ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/seller/extra/values',
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
        '/api/v1/dashboard/seller/extra/groups',
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
      data['products[$i][quantity]'] = stocks[i].cartCount?.toString() ?? '0';
    }
    debugPrint('===> get calculation ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/seller/order/products/calculate',
        queryParameters: data,
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
        '/api/v1/dashboard/seller/extra/groups/$groupId',
        queryParameters: data,
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
    required List<String?> deletedStocks,
    String? uuid,
    bool isAddon = false,
  }) async {
    // 1. Fetch from local drift database
    Map<String, dynamic>? existing;
    if (uuid != null) {
      existing = await appDatabase.getItem('products', uuid);
    }

    List<Stock> processedStocks = [];

    if (existing != null) {
      final oldStocksJson = existing['stocks'] as List<dynamic>? ?? [];
      final oldStocks = oldStocksJson.map((s) => Stock.fromJson(s)).toList();

      for (var stock in stocks) {
        final oldStock = oldStocks.cast<Stock?>().firstWhere(
          (s) => s?.id == stock.id,
          orElse: () => null,
        );

        if (oldStock != null) {
          final int currentQty = oldStock.quantity ?? 0;
          final int newTotalQty = stock.quantity ?? 0;
          final num currentCost = oldStock.costPrice ?? 0;
          final num purchasePrice =
              stock.purchasePrice ?? stock.costPrice ?? currentCost;

          final int addedQty = newTotalQty - currentQty;

          if (addedQty > 0) {
            final num newCostPrice =
                (currentQty * currentCost + addedQty * purchasePrice) /
                newTotalQty;
            stock = stock.copyWith(costPrice: newCostPrice);
          } else {
            stock = stock.copyWith(costPrice: currentCost);
          }
        } else {
          stock = stock.copyWith(
            costPrice: stock.purchasePrice ?? stock.costPrice,
          );
        }
        processedStocks.add(stock);
      }

      // Update the local database before sending remote request
      existing['stocks'] = processedStocks.map((s) => s.toJson()).toList();
      await appDatabase.putItem('products', uuid!, existing);
    } else {
      processedStocks = List.from(stocks);
    }

    final List<Map<String, dynamic>> extras = [];
    for (final stock in processedStocks) {
      List<String?> ids = [];
      List<String?> addonsIds = [];
      if (stock.extras != null && (stock.extras?.isNotEmpty ?? false)) {
        for (final item in stock.extras!) {
          ids.add(item.id ?? '');
        }
      }
      ids = ids.toSet().toList();
      if (stock.localAddons != null &&
          (stock.localAddons?.isNotEmpty ?? false)) {
        for (final item in stock.localAddons!) {
          addonsIds.add(item.product?.id ?? '');
        }
      }
      addonsIds = addonsIds.toSet().toList();
      extras.add({
        'price': stock.price,
        if (stock.costPrice != null) 'cost_price': stock.costPrice,
        if (stock.sku?.isNotEmpty ?? false) 'sku': stock.sku,
        'quantity': stock.quantity,
        if (stock.id != '-1' && stock.id != null) "stock_id": stock.id,
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
        '/api/v1/dashboard/seller/products/$uuid/stocks',
        data: data,
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
      final response = await client.put(
        '/api/v1/dashboard/seller/products/$uuid',
        data: data,
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
    required List<String?> extrasIds,
    String? productUuid,
  }) async {
    final data = {'extras': extrasIds};
    debugPrint('===> update extras ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/seller/products/$productUuid/extras',
        data: data,
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
        '/api/v1/dashboard/seller/extra/groups',
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
        '/api/v1/dashboard/seller/products',
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
        '/api/v1/dashboard/seller/products/$uuid',
        queryParameters: data,
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
        '/api/v1/dashboard/seller/products/paginate',
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
