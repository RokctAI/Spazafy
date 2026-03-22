import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class BannersRepositoryFacade {
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate({
    required int page,
  });

  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate({
    required int page,
  });

  Future<ApiResult<BannerData>> getBannerById(String? bannerId);

  Future<ApiResult<BannerData>> getAdsById(String? bannerId);

  Future<ApiResult<void>> likeBanner(String? bannerId);
}
