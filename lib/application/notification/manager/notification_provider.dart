import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/notification/manager/notification_notifier.dart';
import 'package:rokctapp/application/notification/manager/notification_state.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(managerNotificationRepository),
    );
