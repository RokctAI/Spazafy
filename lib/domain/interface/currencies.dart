import 'package:rokctapp/infrastructure/models/response/currencies_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';

import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/response/currencies_response.dart';

abstract class CurrenciesRepositoryFacade {
  Future<ApiResult<CurrenciesResponse>> getCurrencies();
}
