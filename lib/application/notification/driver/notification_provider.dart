import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/notification/driver/notification_notifier.dart';
import 'package:rokctapp/application/notification/driver/notification_state.dart';

final notificationRepositoryFacade = driverNotificationRepo;

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(notificationRepo),
    );
