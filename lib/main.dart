import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'domain/di/dependency_manager.dart';
import 'presentation/app_widget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'utils/app_initializer_widget.dart';

import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rokctapp/infrastructure/models/data/driver/local_location_data.dart';
import 'package:dio/dio.dart';
import 'package:rokctapp/presentation/phoenix_widget.dart';
import 'package:rokctapp/app_constants.dart' as global_constants;

const fetchBackground = "fetchBackground";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        await LocalStorage.init();
        Position userLocation = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
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
        )..interceptors.add(
            LogInterceptor(
              responseHeader: false,
              requestHeader: true,
              responseBody: true,
              requestBody: true,
            ),
          );
        await client.post(
          '${global_constants.AppConstants.baseUrl}/api/v1/method/paas.api.driver.driver.update_location',
          data: {
            "location": LocalLocationData(
              latitude: userLocation.latitude,
              longitude: userLocation.longitude,
            ).toJson(),
          },
        );
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
  await Firebase.initializeApp();
  await LocalStorage.init();

  final role = LocalStorage.getUser()?.role;
  if (role == 'deliveryman') {
    await Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      'a',
      fetchBackground,
      frequency: const Duration(seconds: 10),
    );
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
