import 'package:flutter/material.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(context, 
          context,
          AppHelpers.getTranslation(TrKeys.agreeLocation),
        );
      }
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          AppHelpers.showCheckTopSnackBar(context, 
            context,
            AppHelpers.getTranslation(TrKeys.agreeLocation),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(context, 
          context,
          AppHelpers.getTranslation(TrKeys.agreeLocation),
        );
      }
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}
