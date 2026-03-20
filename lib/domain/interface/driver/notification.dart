import 'package:rokctapp/domain/handlers/driver/api_result.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';

abstract class NotificationRepositoryFacade {
  Future<ApiResult<NotificationResponse>> getNotifications({int? page});

  Future<ApiResult<NotificationResponse>> getAllNotifications();

  Future<ApiResult<dynamic>> readOne({String? id});

  Future<ApiResult<NotificationResponse>> readAll();

  Future<ApiResult<CountNotificationModel>> getCount();
}
