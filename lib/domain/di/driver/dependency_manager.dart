import 'package:get_it/get_it.dart';
import 'package:rokctapp/domain/interface/driver/notification.dart';
import 'package:rokctapp/domain/interface/driver/parcel.dart';
import 'package:rokctapp/infrastructure/repositories/driver/notification_repository.dart';
import 'package:rokctapp/infrastructure/repositories/driver/parcel_repository.dart';

import 'package:rokctapp/infrastructure/repositories/driver/orders_repository.dart';
import 'package:rokctapp/infrastructure/repositories/driver/repositories.dart';
import 'package:rokctapp/presentation/routes/driver/app_router.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart';
import 'package:rokctapp/domain/interface/driver/interfaces.dart';
import 'package:rokctapp/domain/interface/driver/orders.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerSingleton<HttpService>(HttpService());
  getIt.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  getIt.registerSingleton<UserRepository>(UserRepositoryImpl());
  getIt.registerSingleton<DrawRepository>(DrawRepositoryImpl());
  getIt.registerSingleton<OrdersRepositoryFacade>(OrdersRepository());
  getIt.registerSingleton<ParcelRepositoryFacade>(ParcelRepository());
  getIt.registerSingleton<AppRouter>(AppRouter());
  getIt.registerSingleton<NotificationRepositoryFacade>(
    NotificationRepositoryImpl(),
  );
}

final dioHttp = getIt.get<HttpService>();
final settingsRepository = getIt.get<SettingsRepository>();
final authRepository = getIt.get<AuthRepository>();
final userRepository = getIt.get<UserRepository>();
final drawRepository = getIt.get<DrawRepository>();
final orderRepository = getIt.get<OrdersRepositoryFacade>();
final parcelRepository = getIt.get<ParcelRepositoryFacade>();
final notificationRepo = getIt.get<NotificationRepositoryFacade>();
final appRouter = getIt.get<AppRouter>();
