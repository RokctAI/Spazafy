import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/domain/interface/categories.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

class CategoriesRepository implements CategoriesRepositoryFacade {
  @override
  Future<ApiResult<CategoriesPaginateResponse>> getAllCategories({
    required int page,
    String? shopId,
  }) async {
    final params = {
      'limit_start': (page - 1) * 10,
      'limit_page_length': 10,
      if (shopId != null) 'shop_id': shopId,
    };

    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.category.category.get_categories',
        queryParameters: params,
      );
      final responseData = CategoriesPaginateResponse.fromJson(response.data);

      // Persistence: Cache categories locally on success (first page mainly)
      if (responseData.data != null && page == 1) {
        for (final category in responseData.data!) {
          await appDatabase.upsertCategory(category.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get categories failure: $e');

      // Fallback: If network fails, try fetching from local DB
      try {
        final localCategories = await appDatabase.getCategoriesLocally();
        if (localCategories.isNotEmpty) {
          return ApiResult.success(
            data: CategoriesPaginateResponse(
              data: localCategories
                  .map((e) => CategoryData.fromJson(e))
                  .toList(),
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
  Future<ApiResult<CategoriesPaginateResponse>> searchCategories({
    required String text,
  }) async {
    final params = {'search': text};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/method/paas.api.category.category.search_categories',
        queryParameters: params,
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> search categories failure: $e');

      // Fallback: search locally
      try {
        final localCategories = await appDatabase.getCategoriesLocally();
        if (localCategories.isNotEmpty) {
          final filtered = localCategories
              .map((e) => CategoryData.fromJson(e))
              .where(
                (c) =>
                    (c.title?.toLowerCase().contains(text.toLowerCase()) ??
                    false),
              )
              .toList();

          return ApiResult.success(
            data: CategoriesPaginateResponse(data: filtered),
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
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesByShop({
    required String shopId,
  }) async {
    return getAllCategories(page: 1, shopId: shopId);
  }
}
