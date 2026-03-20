import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';

final parcelRepositoryFacade = driverParcelRepository;
import 'parcel_notifier.dart';
import 'parcel_state.dart';

final parcelProvider = StateNotifierProvider<ParcelNotifier, ParcelState>(
  (ref) => ParcelNotifier(parcelRepository),
);
