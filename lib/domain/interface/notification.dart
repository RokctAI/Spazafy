import 'package:rokctapp/domain/handlers/driver/handlers.dart';
import 'package:rokctapp/infrastructure/models/data/count_notification_data.dart';
import 'package:rokctapp/infrastructure/models/response/notification_response.dart';

abstract class NotificationRepositoryFacade {
  Future<ApiResult<NotificationResponse>> getNotifications({int? page});

  Future<ApiResult<dynamic>> readOne({String? id});

  Future<ApiResult<NotificationResponse>> readAll();

  Future<ApiResult<CountNotificationModel>> getCount();
}
