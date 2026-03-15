import 'package:venderfoodyman/domain/handlers/manager/api_result.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';

abstract class SubscriptionsFacade {
  Future<ApiResult<SubscriptionResponse>> getSubscriptions({required int page});

  Future<ApiResult> purchaseSubscription({
    required String? id,
    required String? paymentId,
  });

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String? id,
    required String? paymentId,
  });
}
