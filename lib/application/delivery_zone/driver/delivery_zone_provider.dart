import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/delivery_zone/driver/delivery_zone_state.dart';
import 'package:rokctapp/application/delivery_zone/driver/delivery_zone_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final deliveryZoneProvider =
    StateNotifierProvider<DeliveryZoneNotifier, DeliveryZoneState>(
      (ref) => DeliveryZoneNotifier(driverUserRepository),
    );
