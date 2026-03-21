import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/payments_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/non_exist_payment_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/maksekeskus_response.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/domain/handlers/manager/handlers.dart' hide ApiResult;

abstract class PaymentsFacade {
  Future<ApiResult<PaymentsResponse>> getPayments();

  Future<ApiResult<NonExistPaymentResponse>> getNonExistPayments();

  Future<ApiResult<String>> paymentWalletWebView({
    required String name,
    required num price,
  });

  Future<ApiResult<MaksekeskusResponse>> paymentMaksekeskusView({num? price});

  Future<ApiResult<String>> paymentSubscriptionWebView({
    required String name,
    required String subscriptionId,
  });

  Future<ApiResult<bool>> sendWallet({
    required String uuid,
    required num price,
  });
}
