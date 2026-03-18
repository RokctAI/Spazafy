import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

abstract class AppConnectivity {
  AppConnectivity._();

  static Future<bool> connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }

  // New method that automatically shows dialog when no connection
  static Future<bool> connectivityWithDialog(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool hasConnection =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.ethernet) ||
            connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasConnection) {
      // Automatically show dialog when no connection
      if (context.mounted) AppHelpers.showNoConnectionDialog(context);
    }

    return hasConnection;
  }

  // Stream for connectivity changes
  static Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged;

  // Convenience stream that emits true if connected, false otherwise
  static Stream<bool> get onConnectionChangedBool =>
      onConnectivityChanged.map((results) =>
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.wifi));

  // Alternative: Replace the existing method to always show dialog
  static Future<bool> connectivityAndShowDialog(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool hasConnection =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.ethernet) ||
            connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasConnection) {
      if (context.mounted) AppHelpers.showNoConnectionDialog(context);
    }

    return hasConnection;
  }
}
