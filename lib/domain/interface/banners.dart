import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class BannersFacade {
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate({
    required int page,
  });

  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate({
    required int page,
  });

  Future<ApiResult<BannerData>> getBannerById(int? bannerId);

  Future<ApiResult<BannerData>> getAdsById(int? bannerId);

  Future<ApiResult<void>> likeBanner(int? bannerId);
}
