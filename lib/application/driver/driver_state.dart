import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:driver/infrastructure/driver/models/models.dart';

part 'driver_state.freezed.dart';

@freezed
abstract class DriverState with _$DriverState {
  const factory DriverState({DeliveryResponse? driverData}) = _DriverState;

  const DriverState._();
}








