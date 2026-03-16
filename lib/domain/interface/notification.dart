import 'package:venderfoodyman/domain/handlers/api_result.dart';
import 'package:venderfoodyman/infrastructure/models/data/count_of_notifications_data.dart';
import 'package:venderfoodyman/infrastructure/models/response/notification_response.dart';

abstract class NotificationFacade {
  Future<ApiResult<NotificationResponse>> getNotifications({int? page});

  Future<ApiResult<dynamic>> readOne({dynamic id});

  Future<ApiResult<NotificationResponse>> readAll();

  Future<ApiResult<CountNotificationModel>> getCount();

  Future<ApiResult<NotificationResponse>> getAllNotifications();
}
