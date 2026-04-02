import 'package:rokctapp/infrastructure/models/response/manager/subscriptions_response.dart';
import 'package:rokctapp/infrastructure/models/response/transactions_response.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/transactions_response.dart';

abstract class SubscriptionsFacade {
  Future<ApiResult<SubscriptionResponse>> getSubscriptions({required int page});

  Future<ApiResult> purchaseSubscription({
    required String id,
    required String paymentId,
  });

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String id,
    required String paymentId,
  });
}
