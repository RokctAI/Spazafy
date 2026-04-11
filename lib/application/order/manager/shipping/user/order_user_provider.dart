import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/shipping/user/order_user_state.dart';
import 'package:rokctapp/application/order/manager/shipping/user/order_user_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final orderUserProvider =
    StateNotifierProvider<OrderUserNotifier, OrderUserState>(
      (ref) => OrderUserNotifier(managerUsersRepository),
    );
