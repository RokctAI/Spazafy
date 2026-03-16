import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/infrastructure/driver/models/models.dart';
import 'driver_state.dart';

class DriverNotifier extends StateNotifier<DriverState> {
  DriverNotifier() : super(const DriverState());

  void setDriverData(DeliveryResponse? data) {
    state = state.copyWith(driverData: data);
  }
}
