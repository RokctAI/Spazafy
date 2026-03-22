import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'parcel_notifier.dart';
import 'parcel_state.dart';


final parcelRepositoryFacade = driverParcelRepository;

final parcelProvider = StateNotifierProvider<ParcelNotifier, ParcelState>(
  (ref) => ParcelNotifier(parcelRepository),
);
