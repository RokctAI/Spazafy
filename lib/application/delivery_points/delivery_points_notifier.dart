import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/delivery_points.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/application/delivery_points/delivery_points_state.dart';

class DeliveryPointsNotifier extends StateNotifier<DeliveryPointsState> {
  final DeliveryPointsRepositoryFacade _deliveryPointsRepository;

  DeliveryPointsNotifier(this._deliveryPointsRepository)
    : super(const DeliveryPointsState());

  Future<void> fetchDeliveryPoints(
    BuildContext context, {
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _deliveryPointsRepository.getDeliveryPoints(
      latitude: latitude,
      longitude: longitude,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false, deliveryPoints: data);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure.toString());
      },
    );
  }
}
