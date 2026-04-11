import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/parcels_list/parcel_list_notifier.dart';
import 'package:rokctapp/application/parcels_list/parcel_list_state.dart';

final parcelListProvider =
    StateNotifierProvider<ParcelListNotifier, ParcelListState>(
      (ref) => ParcelListNotifier(parcelRepository),
    );
