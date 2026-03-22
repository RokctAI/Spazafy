import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/count_of_notifications_data.dart';
import 'package:rokctapp/infrastructure/models/response/notification_response.dart';

abstract class NotificationRepositoryFacade {
  Future<ApiResult<NotificationResponse>> getNotifications({int? page});

  Future<ApiResult<dynamic>> readOne({String? id});

  Future<ApiResult<NotificationResponse>> readAll();

  Future<ApiResult<CountNotificationModel>> getCount();
}
