import 'package:rokctapp/dummy_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
part 'driver_state.freezed.dart';



@freezed
abstract class DriverState with _$DriverState {
  const factory DriverState({DeliveryResponse? driverData}) = _DriverState;

  const DriverState._();
}
