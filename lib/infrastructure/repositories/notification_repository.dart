import 'package:flutter/material.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/domain/handlers/network_exceptions.dart';
import 'package:rokctapp/domain/interface/notification.dart';
import 'package:rokctapp/infrastructure/models/data/count_of_notifications_data.dart';
import 'package:rokctapp/infrastructure/models/response/notification_response.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class NotificationRepositoryImpl extends NotificationRepositoryFacade {
  @override
  Future<ApiResult<NotificationResponse>> getNotifications({int? page}) async {
    final data = {'limit_start': ((page ?? 1) - 1) * 7, 'limit_page_length': 7};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.user.user.get_user_notifications',
        queryParameters: data,
      );
      final responseData = NotificationResponse.fromJson(response.data);

      // Persistence: Cache notifications
      if (responseData.data != null) {
        for (final notification in responseData.data!) {
          await appDatabase.upsertNotification(notification.toJson());
        }
      }

      return ApiResult.success(data: responseData);
    } catch (e) {
      debugPrint('==> get notification failure: $e');

      // Fallback
      try {
        final localData = await appDatabase.getNotificationsLocally();
        if (localData.isNotEmpty) {
          final notifications = localData
              .map((e) => NotificationModel.fromJson(jsonDecode(e.data)))
              .toList();
          return ApiResult.success(
            data: NotificationResponse(data: notifications),
          );
        }
      } catch (localError) {
        debugPrint('==> local fallback failure: $localError');
      }

      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<NotificationResponse>> readAll() async {
    const url = '/api/method/paas.api.read_all_notifications';
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(url);
      return ApiResult.success(data: NotificationResponse());
    } catch (e) {
      debugPrint('==> read all notifications failure: $e');

      // Queue the request
      await appDatabase.enqueueSyncRequest(
        url: url,
        method: 'POST',
        payload: {},
      );

      return ApiResult.success(data: NotificationResponse());
    }
  }

  @override
  Future<ApiResult<dynamic>> readOne({int? id}) async {
    const url = '/api/method/paas.api.read_one_notification';
    final payload = {'notification_id': id};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(url, data: payload);
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> read one notification failure: $e');

      // Queue the request
      if (id != null) {
        await appDatabase.enqueueSyncRequest(
          url: url,
          method: 'POST',
          payload: payload,
        );
      }

      return const ApiResult.success(data: null);
    }
  }

  @override
  Future<ApiResult<CountNotificationModel>> getCount() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.get_notification_count',
      );
      return ApiResult.success(
        data: CountNotificationModel.fromJson(response.data['message']),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
