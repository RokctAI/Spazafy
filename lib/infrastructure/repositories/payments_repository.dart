import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/payments.dart'; // Ensure correct interface name
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import '../models/data/saved_card.dart';

class PaymentsRepository implements PaymentsRepositoryFacade {
  // --- Common & Customer (Frappe/PaaS) ---

  @override
  Future<ApiResult<PaymentsResponse>> getPayments() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      // Try PaaS first
      try {
        final response = await client.get('/api/method/paas.api.payment.payment.get_payment_gateways');
        return ApiResult.success(data: PaymentsResponse.fromJson(response.data));
      } catch (e) {
        // Fallback to V1
        final response = await client.get(
          '/api/v1/rest/payments',
          queryParameters: {"lang": LocalStorage.getLanguage()?.locale ?? 'en'},
        );
        return ApiResult.success(data: PaymentsResponse.fromJson(response.data));
      }
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.payment.create_transaction',
        data: {'order_id': orderId, 'payment_id': paymentId},
      );
      return ApiResult.success(data: TransactionsResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<List<SavedCardModel>>> getSavedCards() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/method/paas.api.payment.payment.get_saved_cards');
      return ApiResult.success(
        data: (response.data['data'] as List).map((e) => SavedCardModel.fromJson(e)).toList(),
      );
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<String>> tokenizeCard({
    required String cardNumber,
    required String cardName,
    required String expiryDate,
    required String cvc,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.payment.tokenize_card',
        data: {'card_number': cardNumber, 'card_holder': cardName, 'expiry_date': expiryDate, 'cvc': cvc},
      );
      return ApiResult.success(data: response.data['data']['token']);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<bool>> deleteCard(String cardId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.payment.payment.delete_card', data: {'card_name': cardId});
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<bool>> setDefaultCard(String cardId) async {
    return const ApiResult.success(data: true);
  }

  @override
  Future<ApiResult<String>> processTokenPayment(OrderBodyData orderData, String token) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/method/paas.api.payment.payment.process_token_payment', data: {'order_id': orderData.cartId, 'token': token});
      return const ApiResult.success(data: "Success");
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<String>> processDirectCardPayment(OrderBodyData orderBody, String cardNumber, String cardName, String expiryDate, String cvc) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.payment.process_direct_card_payment',
        data: {'order_id': orderBody.cartId, 'card_number': cardNumber, 'card_holder': cardName, 'expiry_date': expiryDate, 'cvc': cvc},
      );
      return ApiResult.success(data: response.data['message']);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  // --- Manager/Seller Specific (V1) ---

  @override
  Future<ApiResult<NonExistPaymentResponse>> getNonExistPayments() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/seller/shop-payments/shop-non-exist',
        queryParameters: {"lang": LocalStorage.getLanguage()?.locale ?? 'en'},
      );
      return ApiResult.success(data: NonExistPaymentResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<String>> paymentWalletWebView({required String name, required num price}) async {
    try {
      final data = {
        'wallet_id': LocalStorage.getUser()?.wallet?.uuid ?? '',
        'total_price': price,
        "currency_id": LocalStorage.getSelectedCurrency()?.id,
      };
      final client = dioHttp.client(requireAuth: true);
      final res = await client.post('/api/v1/dashboard/user/$name-process', data: data);
      return ApiResult.success(data: res.data["data"]["data"]["url"] ?? "");
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<MaksekeskusResponse>> paymentMaksekeskusView({num? price}) async {
    try {
      final data = {
        'wallet_id': LocalStorage.getUser()?.wallet?.uuid,
        'total_price': price ?? 0,
        "currency_id": LocalStorage.getSelectedCurrency()?.id,
      };
      final client = dioHttp.client(requireAuth: true);
      final res = await client.post('/api/v1/dashboard/user/maksekeskus-process', data: data);
      return ApiResult.success(data: MaksekeskusResponse.fromJson(res.data["data"]));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<String>> paymentSubscriptionWebView({required String name, required String? subscriptionId}) async {
    try {
      final data = {
        'subscription_id': subscriptionId,
        "currency_id": LocalStorage.getSelectedCurrency()?.id,
      };
      final client = dioHttp.client(requireAuth: true);
      final res = await client.post('/api/v1/dashboard/user/$name-process', data: data);
      return ApiResult.success(data: res.data["data"]["data"]["url"] ?? "");
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
