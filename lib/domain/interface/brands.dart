import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class BrandsRepositoryFacade {
  Future<ApiResult<BrandsPaginateResponse>> getBrandsPaginate(int page);

  Future<ApiResult<BrandsPaginateResponse>> searchBrands(String query);

  Future<ApiResult<SingleBrandResponse>> getSingleBrand(String uuid);

  Future<ApiResult<BrandsPaginateResponse>> getAllBrands({
    String? categoryId,
    String? shopId,
  });
}
