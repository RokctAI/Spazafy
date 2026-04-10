import 'package:rokctapp/domain/interface/manager_notification.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';

import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/infrastructure/models/data/count_of_notifications_data.dart';
import 'package:rokctapp/infrastructure/models/response/notification_response.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';

import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';

class NotificationRepository implements NotificationInterface {
  @override
  Future<ApiResult<NotificationResponse>> getNotifications({int? page}) async {
    final data = {
      if (page != null) 'page': page,
      'column': 'created_at',
      'sort': 'desc',
      'perPage': 7,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.notification.notification.get_notifications',
        queryParameters: data,
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
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
      final response = await client.post(
        '/api/v1/method/paas.api.notification.notification.read_all_notifications',
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> readOne({String? id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.notification.notification.mark_notification_as_read',
        data: {'notification_id': id},
      );
      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<NotificationResponse>> getAllNotifications() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.notification.notification.get_notifications',
        queryParameters: data,
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CountNotificationModel>> getCount() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/method/paas.api.notification.notification.get_notification_count',
      );
      return ApiResult.success(
        data: CountNotificationModel.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
