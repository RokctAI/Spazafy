import 'package:rokctapp/infrastructure/models/response/all_products_response.dart';

import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

abstract class ProductsFacade {
  Future<ApiResult<ProductsPaginateResponse>> searchProducts({
    required String text,
    int page,
  });

  Future<ApiResult<SingleProductResponse>> getProductDetails(String uuid);

  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({
    String? shopId,
    String? categoryId,
    String? brandId,
    required int page,
    String? orderBy,
  });

  Future<ApiResult<AllProductsResponse>> getAllProducts({
    required String shopId,
  });

  Future<ApiResult<ProductsPaginateResponse>> getProductsPopularPaginate({
    String? shopId,
    required int page,
  });

  Future<ApiResult<ProductsPaginateResponse>> getProductsByCategoryPaginate({
    String? shopId,
    required int page,
    required String categoryId,
  });

  Future<ApiResult<ProductsPaginateResponse>>
  getProductsShopByCategoryPaginate({
    String? shopId,
    List<String>? brands,
    int? sortIndex,
    required int page,
    required String categoryId,
  });

  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts({
    String? shopId,
    String? categoryId,
    String? brandId,
  });

  Future<ApiResult<ProductsPaginateResponse>> getRelatedProducts(
    String? brandId,
    String? shopId,
    String? categoryId,
  );

  Future<ApiResult<ProductCalculateResponse>> getProductCalculations(
    String stockId,
    int quantity,
  );

  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(
    List<CartProductData> cartProducts,
  );

  Future<ApiResult<ProductsPaginateResponse>> getProductsByIds(
    List<String> ids,
  );

  Future<ApiResult<void>> addReview(
    String productUuid,
    String comment,
    double rating,
    String? imageUrl,
  );

  Future<ApiResult<ProductsPaginateResponse>> getNewProducts({
    String? shopId,
    String? brandId,
    String? categoryId,
    int? page,
  });

  Future<ApiResult<ProductsPaginateResponse>> getDiscountProducts({
    String? shopId,
    String? brandId,
    String? categoryId,
    int? page,
  });

  Future<ApiResult<ProductsPaginateResponse>> getProfitableProducts({
    String? brandId,
    String? categoryId,
    int? page,
  });

  // Manager Methods
  Future<ApiResult<void>> deleteExtrasGroup({String? groupId});
  Future<ApiResult<SingleExtrasGroupResponse>> updateExtrasGroup({
    required String title,
    String? groupId,
  });
  Future<ApiResult<void>> deleteExtrasItem({required String? extrasId});
  Future<ApiResult<CreateGroupExtrasResponse>> updateExtrasItem({
    required String? extrasId,
    required String? groupId,
    required String title,
  });
  Future<ApiResult<CreateGroupExtrasResponse>> createExtrasItem({
    required String? groupId,
    required String title,
  });
  Future<ApiResult<SingleExtrasGroupResponse>> createExtrasGroup({
    required String title,
  });
  Future<ApiResult<CalculateResponse>> getProductsCalculation(
    List<Stock> stocks,
  );
  Future<ApiResult<GroupExtrasResponse>> getExtras({String? groupId});
  Future<ApiResult<SingleProductResponse>> updateStocks({
    required List<Stock> stocks,
    required List<String?> deletedStocks,
    String? uuid,
    bool isAddon = false,
  });
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
  });
  Future<ApiResult<SingleProductResponse>> updateExtras({
    required List<String?> extrasIds,
    String? productUuid,
  });
  Future<ApiResult<ExtrasGroupsResponse>> getExtrasGroups({
    bool needOnlyValid = true,
  });
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
  });
  Future<ApiResult<ProductsPaginateResponse>> getProducts({
    int? page,
    String? categoryId,
    String? query,
    ProductStatus? status,
    bool needAddons = false,
    bool active = false,
    String? type,
  });
}
