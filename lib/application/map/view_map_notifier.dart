import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venderfoodyman/domain/interface/user.dart';
import 'package:venderfoodyman/infrastructure/models/data/address_new_data.dart';
import 'package:venderfoodyman/infrastructure/models/data/address_old_data.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/domain/interface/shops.dart';
import 'package:venderfoodyman/infrastructure/services/utils/tr_keys.dart';
// Note: Relative import for local components if needed
import 'view_map_state.dart';

class ViewMapNotifier extends StateNotifier<ViewMapState> {
  final ShopsFacade _shopsRepository;
  final UserFacade _userRepository;

  ViewMapNotifier(this._shopsRepository, this._userRepository)
    : super(const ViewMapState());

  void scrolling(bool scroll) {
    state = state.copyWith(isScrolling: scroll);
  }

  void changePlace(AddressNewModel place) {
    state = state.copyWith(place: place, isSetAddress: true);
  }

  void checkAddress(BuildContext context, {Widget? addAddressWidget}) {
    AddressData? data = LocalStorage.getAddressSelected();
    if (data?.location?.latitude == null) {
      state = state.copyWith(isSetAddress: false);
      if (addAddressWidget != null) {
        AppHelpers.showAlertDialog(context: context, child: addAddressWidget);
      }
    } else {
      state = state.copyWith(isSetAddress: true);
    }
  }

  void updateActive() {
    state = state.copyWith(isLoading: true);
  }

  Future<void> saveLocation(
    BuildContext context, {
    VoidCallback? onSuccess,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _userRepository.saveLocation(
        address: state.place?.copyWith(
          title: LocalStorage.getAddressSelected()?.title,
        ),
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          onSuccess?.call();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> updateLocation(
    BuildContext context,
    String? id, {
    VoidCallback? onSuccess,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _userRepository.updateLocation(
        address: state.place?.copyWith(
          title: LocalStorage.getAddressSelected()?.title,
        ),
        addressId: id,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false);
          onSuccess?.call();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> checkDriverZone({
    required BuildContext context,
    required LatLng location,
    String? shopId,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isActive: false);
      final response = await _shopsRepository.checkDriverZone(
        location,
        shopId: shopId,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, isActive: data);
          if (!data) {
            AppHelpers.showCheckTopSnackBarInfo(
              context,
              AppHelpers.getTranslation(TrKeys.noDriverZone),
            );
          }
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          if (!(status == 400 || status == 404)) {
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
}
