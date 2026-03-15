import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class BrandsFacade {
  Future<ApiResult<BrandsPaginateResponse>> getBrandsPaginate(int page);

  Future<ApiResult<BrandsPaginateResponse>> searchBrands(String query);

  Future<ApiResult<SingleBrandResponse>> getSingleBrand(String uuid);

  Future<ApiResult<BrandsPaginateResponse>> getAllBrands({
    String? categoryId,
    String? shopId,
  });
}
