import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'notification_notifier.dart';
import 'notification_state.dart';

final notificationRepositoryFacade = driverNotificationRepo;

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(notificationRepo),
    );
