import 'package:venderfoodyman/infrastructure/models/customer/response/categories_paginate_response.dart';
import 'package:venderfoodyman/domain/handlers/handlers.dart';

abstract class CategoriesFacade {
  Future<ApiResult<CategoriesPaginateResponse>> getAllCategories({
    required int page,
  });

  Future<ApiResult<CategoriesPaginateResponse>> searchCategories({
    required String text,
  });

  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesByShop({
    required String shopId,
  });

  // Manager Methods
  Future<ApiResult<UnitsPaginateResponse>> getUnits();
  Future<ApiResult<KitchensPaginateResponse>> getKitchens();
  Future<ApiResult<void>> createCategory({required String title, int? input});
  Future<ApiResult<CategoriesPaginateResponse>> getCategories({
    int? page,
    String? query,
    String? type,
    bool hasProducts = false,
  });
  Future<ApiResult<CategoriesPaginateResponse>> getShopCategories({
    int? page,
    String? query,
  });
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesSub({
    int? page,
    String? query,
  });
  Future<ApiResult> deleteCategory({required String? id});
}
