import 'package:get_it/get_it.dart';
import 'package:rokctapp/domain/interface/notification.dart';
import 'package:rokctapp/domain/interface/parcel.dart';
import 'package:rokctapp/infrastructure/repositories/notification_repository.dart';
import 'package:rokctapp/infrastructure/repositories/parcel_repository.dart';

import 'package:rokctapp/infrastructure/repositories/orders_repository.dart';
import 'package:rokctapp/infrastructure/repositories/repositories.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/domain/interface/interfaces.dart';
import 'package:rokctapp/domain/interface/orders.dart';

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
