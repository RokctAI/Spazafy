import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/manager/kitchens_paginate_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/units_paginate_response.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/categories_paginate_response.dart';

abstract class CatalogInterface {
  Future<ApiResult<UnitsPaginateResponse>> getUnits();

  Future<ApiResult<KitchensPaginateResponse>> getKitchens();

  Future<ApiResult<void>> createCategory({
    required String title,
    String? input,
  });

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
