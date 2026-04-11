import 'package:rokctapp/infrastructure/models/response/notification_response.dart';
import 'package:rokctapp/infrastructure/models/data/count_notification_data.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';

abstract class NotificationInterface {
  Future<ApiResult<NotificationResponse>> getNotifications({int? page});

  Future<ApiResult<NotificationResponse>> getAllNotifications();

  Future<ApiResult<dynamic>> readOne({String? id});

  Future<ApiResult<NotificationResponse>> readAll();

  Future<ApiResult<CountNotificationModel>> getCount();
}
