import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/products.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/app_database.dart';

class ProductsRepository implements ProductsFacade {
  // --- Common & Customer ---

  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts({
    required String text,
    int? page,
  }) async {
    final params = {
      'search': text,
      'limit_start': ((page ?? 1) - 1) * 14,
      'limit_page_length': 14,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: params,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(String uuid) async {
    // Note: Manager uses dashboard/seller, Customer uses paas.api
    // We favor the more comprehensive one if authorized
    try {
      final client = dioHttp.client(requireAuth: LocalStorage.getToken().isNotEmpty);
      final response = await client.get(
        LocalStorage.getToken().isNotEmpty 
          ? '/api/v1/dashboard/seller/products/$uuid'
          : '/api/method/paas.api.product.product.get_product_by_uuid',
        queryParameters: {'uuid': uuid, 'lang': LocalStorage.getLanguage()?.locale},
      );
      return ApiResult.success(data: SingleProductResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({
    String? shopId,
    String? categoryId,
    String? brandId,
    required int page,
    String? orderBy,
  }) async {
    final params = {
      'limit_start': (page - 1) * 14,
      'limit_page_length': 14,
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (orderBy != null) 'order_by': orderBy,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: params,
      );
      return ApiResult.success(data: ProductsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<AllProductsResponse>> getAllProducts({required String shopId}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: {'shop_id': shopId, 'limit_page_length': 100},
      );
      return ApiResult.success(data: AllProductsResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Manager Hub Logic ---

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
    final data = {
      if (page != null) 'page': page,
      if (categoryId != null) 'category_id': categoryId,
      if (query != null) 'search': query,
      if (active) 'active': 1,
      if (needAddons) 'addon': 1,
      if (type != null) 'type': type,
      'lang': LocalStorage.getLanguage()?.locale,
    };

    // 1. Return Local Results Immediately
    try {
      final localResults = await appDatabase.searchProducts(
        query: query,
        categoryId: categoryId,
      );
      if (localResults.isNotEmpty) {
        final products = localResults.map((e) => ProductData.fromJson(jsonDecode(e.data))).toList();
        _backgroundSyncProducts(data);
        return ApiResult.success(
          data: ProductsPaginateResponse(
            data: products,
            meta: Meta(total: products.length, lastPage: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('==> Local search failed: $e');
    }

    // 2. API Fallback
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/seller/products/paginate',
        queryParameters: data,
      );
      final result = ProductsPaginateResponse.fromJson(response.data);
      for (final product in result.data ?? []) {
        appDatabase.upsertProduct(product.toJson());
      }
      return ApiResult.success(data: result);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  void _backgroundSyncProducts(Map<String, dynamic> data) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/seller/products/paginate',
        queryParameters: data,
      );
      final result = ProductsPaginateResponse.fromJson(response.data);
      for (final product in result.data ?? []) {
        await appDatabase.upsertProduct(product.toJson());
      }
    } catch (e) {}
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
      'description': {LocalStorage.getSystemLanguage()?.locale ?? 'en': description},
      'tax': num.tryParse(tax),
      'interval': num.tryParse(interval),
      'min_qty': num.tryParse(minQty),
      'max_qty': num.tryParse(maxQty),
      'active': active ? 1 : 0,
      'type': type,
      if (qrcode.isNotEmpty) 'sku': qrcode,
      if (uid != null) 'uid': uid,
      if (categoryId != null) 'category_id': categoryId,
      if (kitchenId != null) 'kitchen_id': kitchenId,
      if (unitId != null) 'unit_id': unitId,
      if (images != null) 'images': images,
      if (isAddon) 'addon': 1,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/seller/products', data: data);
      return ApiResult.success(data: SingleProductResponse.fromJson(response.data));
    } catch (e) {
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
    String? kitchenId,
    String? unitId,
    List<String>? images,
    String? uuid,
    bool needAddons = false,
  }) async {
    final data = {
      'title': {for (var k in titlesAndDescriptions.keys) k: titlesAndDescriptions[k]?.first ?? ""},
      'description': {for (var k in titlesAndDescriptions.keys) k: titlesAndDescriptions[k]?.last ?? ""},
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
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put('/api/v1/dashboard/seller/products/$uuid', data: data);
      return ApiResult.success(data: SingleProductResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Extras Management (Manager) ---

  @override
  Future<ApiResult<ExtrasGroupsResponse>> getExtrasGroups({bool needOnlyValid = true}) async {
    final params = {'lang': LocalStorage.getLanguage()?.locale, if (needOnlyValid) 'valid': true, 'perPage': 50};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/extra/groups', queryParameters: params);
      return ApiResult.success(data: ExtrasGroupsResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleExtrasGroupResponse>> createExtrasGroup({required String title}) async {
    final data = {'title': {LocalStorage.getSystemLanguage()?.locale ?? 'en': title}, 'active': 1, 'type': 'text'};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/seller/extra/groups', data: data);
      return ApiResult.success(data: SingleExtrasGroupResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteExtrasGroup({String? groupId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete('/api/v1/dashboard/seller/extra/groups/delete', data: {'ids': [groupId]});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CreateGroupExtrasResponse>> createExtrasItem({required String? groupId, required String title}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/seller/extra/values', data: {'value': title, 'extra_group_id': groupId});
      return ApiResult.success(data: CreateGroupExtrasResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Calculations ---

  @override
  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(List<CartProductData> cartProducts) async {
    final products = cartProducts.map((p) => {'product_id': p.selectedStock?.id, 'quantity': p.quantity}).toList();
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post('/api/method/paas.api.product.product.order_products_calculate', data: {'products': products});
      return ApiResult.success(data: ProductCalculateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CalculateResponse>> getProductsCalculation(List<Stock> stocks) async {
    final data = {'currency_id': LocalStorage.getSelectedCurrency()?.id};
    for (int i = 0; i < stocks.length; i++) {
        data['products[$i][stock_id]'] = stocks[i].id;
        data['products[$i][quantity]'] = stocks[i].cartCount?.toString() ?? '1';
    }
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/order/products/calculate', queryParameters: data);
      return ApiResult.success(data: CalculateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // --- Proxies & Helpers ---

  @override
  Future<ApiResult<ProductsPaginateResponse>> getDiscountProducts({String? shopId, String? brandId, String? categoryId, int? page}) async {
    final params = {'limit_start': ((page ?? 1) - 1) * 14, 'limit_page_length': 14, if (shopId != null) 'shop_id': shopId, if (categoryId != null) 'category_id': categoryId, if (brandId != null) 'brand_id': brandId};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.product.product.get_discounted_products', queryParameters: params);
      return ApiResult.success(data: ProductsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getNewProducts({String? shopId, String? brandId, String? categoryId, int? page}) => getProductsPaginate(shopId: shopId, brandId: brandId, categoryId: categoryId, page: page ?? 1, orderBy: 'created_at');

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProfitableProducts({String? brandId, String? categoryId, int? page}) => getProductsPaginate(brandId: brandId, categoryId: categoryId, page: page ?? 1, orderBy: 'discount');

  @override
  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts({String? shopId, String? categoryId, String? brandId}) {
     final params = {'limit_page_length': 14, if (shopId != null) 'shop_id': shopId, if (categoryId != null) 'category_id': categoryId, if (brandId != null) 'brand_id': brandId};
     return searchProducts(text: '', page: 1); // Proxy or implement correctly if API exists
  }
  
  @override
  Future<ApiResult<void>> addReview(String productUuid, String comment, double rating, String? imageUrl) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.product.product.add_product_review', data: {'uuid': productUuid, 'rating': rating, if (comment.isNotEmpty) 'comment': comment});
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> updateStocks({required List<Stock> stocks, required List<String?> deletedStocks, String? uuid, bool isAddon = false}) async {
      final List<Map<String, dynamic>> extras = [];
      for (final stock in stocks) {
          extras.add({
              'price': stock.price,
              if (stock.costPrice != null) 'cost_price': stock.costPrice,
              'quantity': stock.quantity,
              if (stock.id != null) "stock_id": stock.id,
              'ids': stock.extras?.map((e) => e.id).toList() ?? [],
          });
      }
      try {
          final client = dioHttp.client(requireAuth: true);
          final response = await client.post('/api/v1/dashboard/seller/products/$uuid/stocks', data: {'extras': extras, if (isAddon) 'addon': 1, if (deletedStocks.isNotEmpty) 'delete_ids': deletedStocks});
          return ApiResult.success(data: SingleProductResponse.fromJson(response.data));
      } catch (e) {
          return ApiResult.failure(error: AppHelpers.errorHandler(e));
      }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByIds(List<String> ids) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get('/api/method/paas.api.product.product.get_products_by_ids', queryParameters: {'ids': ids});
      return ApiResult.success(data: ProductsPaginateResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
