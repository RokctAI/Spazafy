import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/restaurant/manager/restaurant_state.dart';
import 'package:rokctapp/application/restaurant/manager/restaurant_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantState>(
      (ref) =>
          RestaurantNotifier(managerUsersRepository, managerSettingsRepository),
    );
