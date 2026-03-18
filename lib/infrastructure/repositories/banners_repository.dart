import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/banners.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

class BannersRepository implements BannersRepositoryFacade {
  @override
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate({
    required int page,
    int? pageSize,
  }) async {
    final params = {
      'page': page,
      'limit_page_length': pageSize ?? 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.get_banners',
        queryParameters: params,
      );
      final responseData = BannersPaginateResponse.fromJson(response.data);

      // Persistence: Cache banners locally on success (first page)
      if (responseData.data != null && page == 1) {
        for (final banner in responseData.data!) {
          await appDatabase.upsertBanner(banner.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get banners failure: $e');

      // Fallback: If network fails, try fetching from local DB
      try {
        final localBanners = await appDatabase.getBannersLocally();
        if (localBanners.isNotEmpty) {
          return ApiResult.success(
            data: BannersPaginateResponse(
              data: localBanners.map((e) => BannerData.fromJson(e)).toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannerData>> getBannerById(int? bannerId) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.get_banner',
        queryParameters: {
          'id': bannerId,
          'lang': LocalStorage.getLanguage()?.locale,
        },
      );
      final responseData = BannerData.fromJson(response.data);

      // Persistence: Cache the banner locally
      await appDatabase.upsertBanner(responseData.toJson());

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get banner by id failure: $e');

      // Fallback
      if (bannerId != null) {
        try {
          final localBanner =
              await appDatabase.getItem('banners', bannerId.toString());
          if (localBanner != null) {
            return ApiResult.success(data: BannerData.fromJson(localBanner));
          }
        } catch (localError) {
          debugPrint('==> local fallback failure: $localError');
        }
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // NOTE: The following methods are not supported by the new backend.
  // - getAdsPaginate
  // - getAdsById
  // - likeBanner

  @override
  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate({
    required int page,
    int? pageSize,
  }) async {
    final params = {
      'page': page,
      'limit_page_length': pageSize ?? 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.get_ads',
        queryParameters: params,
      );
      final responseData = BannersPaginateResponse.fromJson(response.data);

      // Persistence: Cache ads (banners) locally on success (first page)
      if (responseData.data != null && page == 1) {
        for (final ad in responseData.data!) {
          await appDatabase.upsertBanner(ad.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get ads failure: $e');

      // Fallback: Ads share the same table as banners in our current Drift schema
      try {
        final localAds = await appDatabase.getBannersLocally();
        if (localAds.isNotEmpty) {
          return ApiResult.success(
            data: BannersPaginateResponse(
              data: localAds.map((e) => BannerData.fromJson(e)).toList(),
            ),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannerData>> getAdsById(int? bannerId) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.get_ad',
        queryParameters: {
          'id': bannerId,
          'lang': LocalStorage.getLanguage()?.locale,
        },
      );
      final responseData = BannerData.fromJson(response.data);

      // Persistence: Cache the ad locally
      await appDatabase.upsertBanner(responseData.toJson());

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get ad by id failure: $e');

      // Fallback
      if (bannerId != null) {
        try {
          final localAd =
              await appDatabase.getItem('banners', bannerId.toString());
          if (localAd != null) {
            return ApiResult.success(data: BannerData.fromJson(localAd));
          }
        } catch (localError) {
          debugPrint('==> local fallback failure: $localError');
        }
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> likeBanner(int? bannerId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.like_banner',
        data: {'id': bannerId, 'lang': LocalStorage.getLanguage()?.locale},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> like banner failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
