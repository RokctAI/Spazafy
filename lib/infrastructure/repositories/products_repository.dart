import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/products.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/models/response/all_products_response.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'dart:convert';

class ProductsRepository implements ProductsRepositoryFacade {
  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts({
    required String text,
    int? page,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.search_products',
        queryParameters: params,
      );
      final responseData = ProductsPaginateResponse.fromJson(response.data);

      // Persistence: Cache products locally on success
      if (responseData.data != null) {
        for (final product in responseData.data!) {
          await appDatabase.upsertProduct(product.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      // Fallback: Try searching locally
      try {
        final localProducts = await appDatabase.searchProducts(query: text);
        if (localProducts.isNotEmpty) {
          return ApiResult.success(
            data: ProductsPaginateResponse(
              data: localProducts
                  .map((e) => ProductData.fromJson(jsonDecode(e.data)))
                  .toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local search fallback failure: $localError');
      }

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
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_product_by_uuid',
        queryParameters: {'uuid': uuid},
      );
      final responseData = SingleProductResponse.fromJson(response.data);

      // Persistence: Cache product detail
      if (responseData.data != null) {
        await appDatabase.upsertProduct(responseData.data!.toJson());
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get product details failure: $e');

      // Fallback
      try {
        final localProduct = await appDatabase.searchProducts(query: uuid);
        if (localProduct.isNotEmpty) {
          return ApiResult.success(
            data: SingleProductResponse(
              data: ProductData.fromJson(jsonDecode(localProduct.first.data)),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local details fallback failure: $localError');
      }

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
    int? page,
    String? orderBy,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: params,
      );
      final responseData = ProductsPaginateResponse.fromJson(response.data);

      // Persistence: Cache products locally on success
      if (responseData.data != null) {
        for (final product in responseData.data!) {
          await appDatabase.upsertProduct(product.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> getProductsPaginate failure: $e');

      // Fallback: Try fetching locally by category
      try {
        final localProducts = await appDatabase.searchProducts(
          categoryId: categoryId,
        );
        if (localProducts.isNotEmpty) {
          return ApiResult.success(
            data: ProductsPaginateResponse(
              data: localProducts
                  .map((e) => ProductData.fromJson(jsonDecode(e.data)))
                  .toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local pagination fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts({
    String? shopId,
    String? categoryId,
    String? brandId,
  }) async {
    final params = {
      'limit_page_length': 14,
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.most_sold_products',
        queryParameters: params,
      );
      final responseData = ProductsPaginateResponse.fromJson(response.data);

      // Persistence: Cache most sold
      if (responseData.data != null) {
        for (final product in responseData.data!) {
          await appDatabase.upsertProduct(product.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get most sold products failure: $e');

      // Fallback
      try {
        final localProducts = await appDatabase.searchProducts(
          categoryId: categoryId,
        );
        if (localProducts.isNotEmpty) {
          return ApiResult.success(
            data: ProductsPaginateResponse(
              data: localProducts
                  .map((e) => ProductData.fromJson(jsonDecode(e.data)))
                  .toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local most sold fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(
    List<CartProductData> cartProducts,
  ) async {
    final products = cartProducts
        .map((p) => {'product_id': p.selectedStock?.id, 'quantity': p.quantity})
        .toList();

    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/method/paas.api.product.product.order_products_calculate',
        data: {'products': products},
      );
      return ApiResult.success(
        data: ProductCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all calculations failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByIds(
    List<String> ids,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products_by_ids',
        queryParameters: {'ids': ids},
      );
      final responseData = ProductsPaginateResponse.fromJson(response.data);

      // Persistence: Cache products
      if (responseData.data != null) {
        for (final product in responseData.data!) {
          await appDatabase.upsertProduct(product.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get products by ids failure: $e');

      // Fallback: Fetch what we have from local DB
      try {
        final List<ProductData> locals = [];
        for (final id in ids) {
          final local = await appDatabase.searchProducts(query: id);
          if (local.isNotEmpty) {
            locals.add(ProductData.fromJson(jsonDecode(local.first.data)));
          }
        }
        if (locals.isNotEmpty) {
          return ApiResult.success(
            data: ProductsPaginateResponse(data: locals),
          );
        }
      } catch (localError) {
        debugPrint('==> local batch fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> addReview(
    String productUuid,
    String comment,
    double rating,
    String? imageUrl,
  ) async {
    final data = {
      'uuid': productUuid,
      'rating': rating,
      if (comment.isNotEmpty) 'comment': comment,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.product.product.add_product_review',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add review failure: $e');

      // Persistence: Queue for background sync
      try {
        await appDatabase.enqueueSyncRequest(
          url: '/api/method/paas.api.product.product.add_product_review',
          method: 'POST',
          payload: data,
        );
        return const ApiResult.success(data: null);
      } catch (localError) {
        debugPrint('==> local review queue failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getDiscountProducts({
    String? shopId,
    String? brandId,
    String? categoryId,
    int? page,
  }) async {
    final params = {
      'limit_start': ((page ?? 1) - 1) * 14,
      'limit_page_length': 14,
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_discounted_products',
        queryParameters: params,
      );
      final responseData = ProductsPaginateResponse.fromJson(response.data);

      // Persistence: Cache discounted products
      if (responseData.data != null) {
        for (final product in responseData.data!) {
          await appDatabase.upsertProduct(product.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get discount products failure: $e');

      // Fallback
      try {
        final localProducts = await appDatabase.searchProducts(
          categoryId: categoryId,
        );
        if (localProducts.isNotEmpty) {
          return ApiResult.success(
            data: ProductsPaginateResponse(
              data: localProducts
                  .map((e) => ProductData.fromJson(jsonDecode(e.data)))
                  .toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local discount fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // NOTE: The following methods are now covered by the enhanced getProductsPaginate method
  // or are no longer needed.
  // - getProductsByCategoryPaginate
  // - getAllProducts
  // - getProductsShopByCategoryPaginate
  // - getProductsPopularPaginate
  // - getRelatedProducts
  // - getProductCalculations
  // - getNewProducts
  // - getProfitableProducts

  @override
  Future<ApiResult<AllProductsResponse>> getAllProducts({
    required String shopId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: {'shop_id': shopId, 'limit_page_length': 100},
      );
      final responseData = AllProductsResponse.fromJson(response.data);

      // Persistence: Cache these products
      if (responseData.data != null) {
        for (final product in responseData.data!) {
          await appDatabase.upsertProduct(product.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get all products failure: $e');

      // Fallback: Fetch from local DB
      try {
        final localProducts = await appDatabase.searchProducts(shopId: shopId);
        if (localProducts.isNotEmpty) {
          return ApiResult.success(
            data: AllProductsResponse(
              data: localProducts
                  .map((e) => ProductData.fromJson(jsonDecode(e.data)))
                  .toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local all products fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getNewProducts({
    String? shopId,
    String? brandId,
    String? categoryId,
    int? page,
  }) async {
    return getProductsPaginate(
      shopId: shopId,
      brandId: brandId,
      categoryId: categoryId,
      page: page,
      orderBy: 'created_at',
    );
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getProductCalculations(
    String stockId,
    int quantity,
  ) async {
    return getAllCalculations([
      CartProductData(
        selectedStock: Stocks(id: stockId),
        quantity: quantity,
      ),
    ]);
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByCategoryPaginate({
    String? shopId,
    required int page,
    required String categoryId,
  }) async {
    return getProductsPaginate(
      shopId: shopId,
      categoryId: categoryId,
      page: page,
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPopularPaginate({
    String? shopId,
    required int page,
  }) async {
    return getProductsPaginate(shopId: shopId, page: page, orderBy: 'rating');
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>>
      getProductsShopByCategoryPaginate({
    String? shopId,
    List<String>? brands,
    int? sortIndex,
    required int page,
    required String categoryId,
  }) async {
    return getProductsPaginate(
      shopId: shopId,
      categoryId: categoryId,
      page: page,
      // Implement sort index logic if needed
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProfitableProducts({
    String? brandId,
    String? categoryId,
    int? page,
  }) async {
    return getProductsPaginate(
      brandId: brandId,
      categoryId: categoryId,
      page: page,
      orderBy: 'discount',
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getRelatedProducts(
    String? brandId,
    String? shopId,
    String? categoryId,
  ) async {
    return getProductsPaginate(
      shopId: shopId,
      brandId: brandId,
      categoryId: categoryId,
      page: 1,
    );
  }
}
