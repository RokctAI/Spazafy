import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'package:rokctapp/infrastructure/models/data/address_old_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rokctapp/infrastructure/services/constants/enums.dart';

import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'view_map_state.dart';

class ViewMapNotifier extends StateNotifier<ViewMapState> {
  ViewMapNotifier() : super(const ViewMapState());

  void changePlace(AddressData place) {
    state = state.copyWith(place: place, isSetAddress: true);
  }

  void checkAddress(BuildContext context, Widget addAddressWidget) {
    AddressData? data = LocalStorage.getAddressSelected();
    if (data == null) {
      state = state.copyWith(isSetAddress: false);
      AppHelpers.showAlertDialog(context: context, child: addAddressWidget);
    } else {
      state = state.copyWith(isSetAddress: true);
    }
  }

  void updateActive() {
    state = state.copyWith(isLoading: true);
  }
}
