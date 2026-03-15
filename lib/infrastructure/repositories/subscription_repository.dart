import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:venderfoodyman/domain/interface/subscription_facade.dart';

class SubscriptionsRepository implements SubscriptionsFacade {
  @override
  Future<ApiResult<SubscriptionResponse>> getSubscriptions({required int page}) async {
    final data = {'lang': LocalStorage.getLanguage()?.locale, 'page': page};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/seller/subscriptions', queryParameters: data);
      return ApiResult.success(data: SubscriptionResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult> purchaseSubscription({required String? id, required String? paymentId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/dashboard/seller/subscriptions/$id/attach', data: {'payment_sys_id': paymentId});
      return ApiResult.success(data: response.data['data']['id']);
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({required String? id, required String? paymentId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post('/api/v1/payments/subscription/$id/transactions', data: {'payment_sys_id': paymentId});
      return ApiResult.success(data: TransactionsResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
