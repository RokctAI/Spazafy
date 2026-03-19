import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/interface/currencies.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class CurrenciesRepository implements CurrenciesRepositoryFacade {
  @override
  Future<ApiResult<CurrenciesResponse>> getCurrencies() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.system.system.get_currencies',
      );
      final responseData = CurrenciesResponse.fromJson(response.data);

      // Persistence: Cache currencies
      await appDatabase.putItem(
        'settings',
        'currencies',
        responseData.toJson(),
      );

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get currencies failure: $e');

      // Fallback: Try local cache
      try {
        final localData = await appDatabase.getItem('settings', 'currencies');
        if (localData != null) {
          return ApiResult.success(
            data: CurrenciesResponse.fromJson(localData),
          );
        }
      } catch (localError) {
        debugPrint('==> local currency fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
