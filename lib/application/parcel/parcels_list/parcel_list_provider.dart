import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/customer/dependency_manager.dart';

import 'parcel_list_notifier.dart';
import 'parcel_list_state.dart';

final parcelListProvider =
    StateNotifierProvider<ParcelListNotifier, ParcelListState>(
  (ref) => ParcelListNotifier(parcelRepository),
);



