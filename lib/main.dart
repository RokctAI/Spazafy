import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';
import 'package:venderfoodyman/presentation/theme/customer/theme.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'package:venderfoodyman/presentation/theme/customer/app_widget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:venderfoodyman/utils/app_initializer_widget.dart';
import 'package:venderfoodyman/presentation/theme/manager/phoenix_widget.dart';
import 'package:venderfoodyman/infrastructure/services/utils/app_database.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'app_constants.dart';

late final AppDatabase appDatabase;

const fetchBackground = "fetchBackground";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        await LocalStorage.init();
        try {
          Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          final Dio client = Dio(
            BaseOptions(
              headers: {
                'Accept':
                    'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
                'Content-type': 'application/json',
                "Authorization": "Bearer ${LocalStorage.getToken()}",
              },
            ),
          );
          await client.post(
            '${AppConstants.baseUrl}/api/v1/dashboard/deliveryman/settings/location',
            data: {
              "location": {
                "latitude": userLocation.latitude,
                "longitude": userLocation.longitude,
              }
            },
          );
        } catch (e) {
          debugPrint('Background location update failed: $e');
        }
        break;
    }
    return Future.value(true);
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Drift database
  appDatabase = AppDatabase();

  // Firebase — graceful offline boot
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (_) {
    // Firebase unavailable offline — app continues
  }

  // System UI Mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppStyle.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppStyle.transparent,
      systemNavigationBarDividerColor: AppStyle.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await LocalStorage.init();

  // Workmanager for Driver tracking
  try {
    await Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      'location_update',
      fetchBackground,
      frequency: const Duration(minutes: 15),
    );
  } catch (e) {
    debugPrint('Workmanager check: $e');
  }

  setUpDependencies();

  runApp(
    ProviderScope(
      child: Phoenix(
        child: AppInitializerWidget(
          child: AppWidget(),
        ),
      ),
    ),
  );
}
