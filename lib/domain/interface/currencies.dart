import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

abstract class CurrenciesFacade {
  Future<ApiResult<CurrenciesResponse>> getCurrencies();
}
