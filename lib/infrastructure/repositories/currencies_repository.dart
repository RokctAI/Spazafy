import 'package:flutter/material.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'package:venderfoodyman/domain/interface/currencies.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';

class CurrenciesRepository implements CurrenciesRepositoryFacade {
  @override
  Future<ApiResult<CurrenciesResponse>> getCurrencies() async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.system.system.get_currencies',
      );
      return ApiResult.success(
        data: CurrenciesResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get currencies failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
