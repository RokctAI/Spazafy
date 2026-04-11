import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/parcel/driver/parcel_notifier.dart';
import 'package:rokctapp/application/parcel/driver/parcel_state.dart';

final parcelRepositoryFacade = driverParcelRepository;

final parcelProvider = StateNotifierProvider<ParcelNotifier, ParcelState>(
  (ref) => ParcelNotifier(parcelRepository),
);
