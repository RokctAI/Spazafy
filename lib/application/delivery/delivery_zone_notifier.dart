import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/presentation/theme/customer/app_style.dart';
import 'package:venderfoodyman/domain/interface/user.dart';
import 'delivery_zone_state.dart';

class DeliveryZoneNotifier extends StateNotifier<DeliveryZoneState> {
  final UserFacade _usersRepository;

  DeliveryZoneNotifier(this._usersRepository)
    : super(const DeliveryZoneState());

  Future<void> updateDeliveryZone({VoidCallback? updateSuccess}) async {
    state = state.copyWith(isSaving: true);
    final response = await _usersRepository.updateDeliveryZones(
      points: state.tappedPoints,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isSaving: false);
        updateSuccess?.call();
      },
      failure: (fail, status) {
        state = state.copyWith(isSaving: false);
        debugPrint('===> update delivery zone failed $fail');
      },
    );
  }

  void addTappedPoint(LatLng point) {
    // Role-specific check if needed, e.g. Driver can only edit if certain conditions met
    final user = LocalStorage.getUser();
    if (user?.role == 'deliveryman' && AppHelpers.getDriverCantEdit()) return;

    List<LatLng> points = List.from(state.tappedPoints);
    points.add(point);
    final Set<Polygon> polygon = HashSet<Polygon>();
    if (points.isNotEmpty) {
      polygon.add(
        Polygon(
          polygonId: const PolygonId('1'),
          points: points,
          fillColor: AppStyle.primary.withOpacity(0.3),
          strokeColor: AppStyle.primary,
          geodesic: false,
          strokeWidth: 4,
        ),
      );
    }
    state = state.copyWith(tappedPoints: points, polygon: polygon);
  }

  Future<void> fetchDeliveryZone() async {
    state = state.copyWith(isLoading: true, tappedPoints: []);
    final user = LocalStorage.getUser();

    if (user?.role == 'seller') {
      final response = await _usersRepository.getDeliveryZone();
      response.when(
        success: (data) {
          if (data.data != null && data.data!.isNotEmpty) {
            final List<List<double>> addresses = data.data?.first.address ?? [];
            _processPoints(addresses);
          }
          state = state.copyWith(isLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          debugPrint('==> error fetching manager delivery zone $failure');
        },
      );
    } else {
      // Default/Driver behavior
      final response = await _usersRepository.getProfileDetails();
      response.when(
        success: (data) {
          if (data.data?.deliveryZone?.isNotEmpty ?? false) {
            final List<List<double>> addresses = data.data?.deliveryZone ?? [];
            _processPoints(addresses);
          }
          state = state.copyWith(isLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          debugPrint('==> error fetching profile delivery zone $failure');
        },
      );
    }
  }

  void _processPoints(List<List<double>> addresses) {
    final Set<Polygon> polygon = HashSet<Polygon>();
    List<LatLng> points = [];
    for (final address in addresses) {
      final latLng = LatLng(address[0], address[1]);
      points.add(latLng);
    }
    polygon.add(
      Polygon(
        polygonId: const PolygonId('1'),
        points: points,
        fillColor: AppStyle.primary.withOpacity(0.3),
        strokeColor: AppStyle.primary,
        geodesic: false,
        strokeWidth: 4,
      ),
    );
    state = state.copyWith(
      deliveryZones: addresses,
      polygon: polygon,
      tappedPoints: points,
    );
  }
}
