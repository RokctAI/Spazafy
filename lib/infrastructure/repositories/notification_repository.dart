import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/domain/interface/notification.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';

class NotificationRepositoryImpl extends NotificationRepositoryFacade {
  // --- Common & Customer (Frappe/PaaS) ---

  @override
  Future<ApiResult<NotificationResponse>> getNotifications({int? page}) async {
    final data = {
      'page': page ?? 1,
      'limit_start': ((page ?? 1) - 1) * 7,
      'limit_page_length': 7,
      'column': 'created_at',
      'sort': 'desc',
      'perPage': 7,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      // Try PaaS endpoint first
      try {
        final response = await client.get(
          '/api/method/paas.api.user.user.get_user_notifications',
          queryParameters: data,
        );
        return ApiResult.success(
            data: NotificationResponse.fromJson(response.data));
      } catch (e) {
        // Fallback to V1
        final response = await client.get(
          '/api/v1/dashboard/notifications',
          queryParameters: data,
        );
        return ApiResult.success(
            data: NotificationResponse.fromJson(response.data));
      }
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<NotificationResponse>> readAll() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      try {
        await client.post('/api/method/paas.api.read_all_notifications');
        return ApiResult.success(data: NotificationResponse());
      } catch (e) {
        final response =
            await client.post('/api/v1/dashboard/notifications/read-all');
        return ApiResult.success(
            data: NotificationResponse.fromJson(response.data));
      }
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> readOne({dynamic id}) async {
    // id can be int or String, we convert to String for Frappe readiness
    final stringId = id?.toString();
    try {
      final client = dioHttp.client(requireAuth: true);
      try {
        await client.post(
          '/api/method/paas.api.read_one_notification',
          data: {'notification_id': stringId},
        );
        return const ApiResult.success(data: true);
      } catch (e) {
        await client.post(
          '/api/v1/dashboard/notifications/$id/read-at',
          queryParameters: {'lang': LocalStorage.getLanguage()?.locale},
        );
        return const ApiResult.success(data: true);
      }
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CountNotificationModel>> getCount() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      try {
        final response =
            await client.get('/api/method/paas.api.get_notification_count');
        return ApiResult.success(
            data: CountNotificationModel.fromJson(response.data['message']));
      } catch (e) {
        final response = await client
            .get('/api/v1/dashboard/user/profile/notifications-statistic');
        return ApiResult.success(
            data: CountNotificationModel.fromJson(response.data));
      }
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  // --- Driver/Manager Specific ---

  @override
  Future<ApiResult<NotificationResponse>> getAllNotifications() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/notifications',
        queryParameters: data,
      );
      return ApiResult.success(
          data: NotificationResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
