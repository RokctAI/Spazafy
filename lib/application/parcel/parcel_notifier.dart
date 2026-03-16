import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:venderfoodyman/domain/interface/parcel.dart';
import 'package:venderfoodyman/domain/interface/draw.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/infrastructure/services/utils/marker_image_cropper.dart';
import 'package:venderfoodyman/infrastructure/services/constants/tr_keys.dart';
import 'package:venderfoodyman/customer/app_constants.dart';
import 'package:venderfoodyman/presentation/routes/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'parcel_state.dart';

class ParcelNotifier extends StateNotifier<ParcelState> {
  final ParcelFacade _parcelRepository;
  final DrawFacade _drawRouting;

  ParcelNotifier(this._parcelRepository, this._drawRouting)
    : super(const ParcelState());

  // Pagination for driver orders
  int activeOrderPage = 1;
  int historyOrderPage = 1;
  int availableOrderPage = 1;

  // --- Customer Methods ---

  Future<void> addReview(
    BuildContext context,
    String comment,
    double rating,
  ) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isButtonLoading: true);
      final response = await _parcelRepository.addReview(
        (state.parcel?.id ?? "").toString(),
        rating: rating,
        comment: comment,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isButtonLoading: false);
          context.maybePop(context);
        },
        failure: (failure, status) {
          state = state.copyWith(isButtonLoading: false);
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void changeExpand() {
    state = state.copyWith(expand: !state.expand);
  }

  void setPayment(PaymentData selectPayment) {
    state = state.copyWith(selectPayment: selectPayment);
  }

  void changeAnonymous() {
    state = state.copyWith(anonymous: !state.anonymous);
  }

  Future<void> fetchTypes(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _parcelRepository.getTypes();
      response.when(
        success: (data) {
          state = state.copyWith(isLoading: false, types: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> getCalculate(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, error: false);
      final response = await _parcelRepository.getCalculate(
        typeId: state.types[state.selectType]?.id ?? "",
        from: state.locationFrom ?? LocationModel(),
        to: state.locationTo ?? LocationModel(),
      );
      response.when(
        success: (data) {
          state = state.copyWith(isLoading: false, calculate: data);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, error: true);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  // --- Driver Methods ---

  void changeDeliveryType(int index) {
    state = state.copyWith(deliveryType: index);
  }

  void changeDeliveryTime(int index) {
    state = state.copyWith(deliveryTime: index);
  }

  void changePaymentType(bool isActive) {
    state = state.copyWith(paymentType: isActive);
  }

  Future<void> showOrder(BuildContext context, int orderId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _parcelRepository.showParcel(orderId);
      response.when(
        success: (data) {
          state = state.copyWith(order: data, isLoading: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchActiveOrders(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isActiveLoading: true, activeOrders: []);
      final response = await _parcelRepository.getActiveParcel(1);
      response.when(
        success: (data) {
          state = state.copyWith(
            activeOrders: data.data ?? [],
            isActiveLoading: false,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isActiveLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    }
  }

  // Common helper for routing (from customer)
  void setFromAddress({
    required String? title,
    required LocationModel? location,
    required BuildContext context,
  }) {
    state = state.copyWith(addressFrom: title, locationFrom: location);
    if (state.types.isNotEmpty &&
        state.addressFrom != null &&
        state.addressTo != null) {
      getCalculate(context);
    }
  }

  void setToAddress({
    required String? title,
    required LocationModel? location,
    required BuildContext context,
  }) {
    state = state.copyWith(addressTo: title, locationTo: location);
    if (state.types.isNotEmpty &&
        state.addressFrom != null &&
        state.addressTo != null) {
      getCalculate(context);
    }
  }
}
