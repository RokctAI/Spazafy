import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/order/manager/shipping/user/create/create_user_notifier.dart';
import 'package:rokctapp/application/order/manager/shipping/user/create/create_user_state.dart';

final createUserProvider =
    StateNotifierProvider.autoDispose<CreateUserNotifier, CreateUserState>(
      (ref) => CreateUserNotifier(managerUsersRepository),
    );
