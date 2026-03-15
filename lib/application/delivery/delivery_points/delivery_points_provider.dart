import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/customer/dependency_manager.dart';
import 'delivery_points_notifier.dart';
import 'delivery_points_state.dart';

final deliveryPointsProvider =
    StateNotifierProvider<DeliveryPointsNotifier, DeliveryPointsState>(
  (ref) => DeliveryPointsNotifier(deliveryPointsRepository),
);



