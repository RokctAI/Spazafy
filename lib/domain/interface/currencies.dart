import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class CurrenciesFacade {
  Future<ApiResult<CurrenciesResponse>> getCurrencies();
}
