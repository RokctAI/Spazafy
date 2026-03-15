import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

import '../../infrastructure/models/data/saved_card.dart';

abstract class PaymentsFacade {
  Future<ApiResult<PaymentsResponse?>> getPayments();

  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
  });

  Future<ApiResult<List<SavedCardModel>>> getSavedCards();

  Future<ApiResult<String>> processDirectCardPayment(
    OrderBodyData orderBody,
    String cardNumber,
    String cardName,
    String expiryDate,
    String cvc,
  );

  Future<ApiResult<String>> tokenizeCard({
    required String cardNumber,
    required String cardName,
    required String expiryDate,
    required String cvc,
  });

  Future<ApiResult<String>> tokenizeAfterPayment(
    String cardNumber,
    String cardName,
    String expiryDate,
    String cvc, [
    String? token,
    String? lastFour,
    String? cardType,
  ]);

  Future<ApiResult<String>> processTokenPayment(
    OrderBodyData orderBody,
    String token,
  );

  Future<ApiResult<bool>> deleteCard(String cardId);

  Future<ApiResult<bool>> setDefaultCard(String cardId);

  // Manager Methods
  Future<ApiResult<NonExistPaymentResponse>> getNonExistPayments();
  Future<ApiResult<String>> paymentWalletWebView({
    required String name,
    required num price,
  });
  Future<ApiResult<MaksekeskusResponse>> paymentMaksekeskusView({num? price});
  Future<ApiResult<String>> paymentSubscriptionWebView({
    required String name,
    required String? subscriptionId,
  });
  Future<ApiResult<bool>> sendWallet({
    required String uuid,
    required num price,
  });
}
