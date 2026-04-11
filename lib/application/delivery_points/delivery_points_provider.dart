import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/delivery_points/delivery_points_notifier.dart';
import 'package:rokctapp/application/delivery_points/delivery_points_state.dart';

final deliveryPointsProvider =
    StateNotifierProvider<DeliveryPointsNotifier, DeliveryPointsState>(
      (ref) => DeliveryPointsNotifier(deliveryPointsRepository),
    );
