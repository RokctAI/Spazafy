import 'package:rokctapp/infrastructure/repositories/manager/notification_repository.dart';
import 'package:rokctapp/domain/interface/loans.dart';
import 'package:rokctapp/domain/interface/auth.dart';
import 'package:rokctapp/domain/interface/wallet.dart';
import 'package:rokctapp/domain/interface/brands.dart';
import 'package:rokctapp/domain/interface/shops.dart';
import 'package:rokctapp/domain/interface/banners.dart';
import 'package:rokctapp/domain/interface/delivery_points.dart';
import 'package:rokctapp/domain/interface/user.dart';
import 'package:rokctapp/domain/interface/notification.dart';
import 'package:rokctapp/domain/interface/cart.dart';
import 'package:rokctapp/domain/interface/gallery.dart';
import 'package:rokctapp/domain/interface/categories.dart';
import 'package:rokctapp/domain/interface/address.dart';
import 'package:rokctapp/domain/interface/products.dart';
import 'package:rokctapp/domain/interface/parcel.dart';
import 'package:rokctapp/domain/interface/settings.dart';
import 'package:rokctapp/domain/interface/draw.dart';
import 'package:rokctapp/domain/interface/blogs.dart';
import 'package:rokctapp/domain/interface/currencies.dart';
import 'package:rokctapp/domain/interface/payments.dart';
import 'package:rokctapp/domain/interface/orders.dart';
import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';

import 'package:rokctapp/infrastructure/repositories/address_repository.dart';
import 'package:rokctapp/infrastructure/repositories/auth_repository.dart';
import 'package:rokctapp/infrastructure/repositories/banners_repository.dart';
import 'package:rokctapp/infrastructure/repositories/blogs_repository.dart';
import 'package:rokctapp/infrastructure/repositories/brands_repository.dart';
import 'package:rokctapp/infrastructure/repositories/cart_repository.dart';
import 'package:rokctapp/infrastructure/repositories/categories_repository.dart';
import 'package:rokctapp/infrastructure/repositories/currencies_repository.dart';
import 'package:rokctapp/infrastructure/repositories/draw_repository.dart'
    as cust_draw;
import 'package:rokctapp/infrastructure/repositories/gallery_repository.dart';
import 'package:rokctapp/infrastructure/repositories/notification_repository.dart';
import 'package:rokctapp/infrastructure/repositories/orders_repository.dart'
    as cust;
import 'package:rokctapp/infrastructure/repositories/parcel_repository.dart';
import 'package:rokctapp/infrastructure/repositories/payments_repository.dart';
import 'package:rokctapp/infrastructure/repositories/products_repository.dart'
    as cust;
import 'package:rokctapp/infrastructure/repositories/settings_repository.dart'
    as cust_settings;
import 'package:rokctapp/infrastructure/repositories/shops_repository.dart'
    as cust;
import 'package:rokctapp/infrastructure/repositories/user_repository.dart'
    as cust_user;

import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/repositories/loans_repository.dart';
import 'package:rokctapp/infrastructure/repositories/wallet_repository.dart';
import 'package:rokctapp/domain/handlers/http_service.dart';
import 'package:rokctapp/infrastructure/repositories/delivery_points_repository.dart';
import 'package:rokctapp/infrastructure/services/utils/app_database.dart';
import 'package:rokctapp/infrastructure/services/utils/background_sync_service.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart'
    as driver_handlers
    hide ApiResult;

import 'package:rokctapp/domain/interface/interfaces.dart' as driver_interfaces;
import 'package:rokctapp/domain/interface/interfaces.dart'
    as manager_interfaces;
import 'package:rokctapp/infrastructure/repositories/driver/repositories.dart';
import 'package:rokctapp/domain/interface/manager_payment.dart';
import 'package:rokctapp/domain/interface/manager_subscription.dart';
import 'package:rokctapp/domain/interface/manager_table.dart';

import 'package:rokctapp/infrastructure/repositories/manager/catalog_repository.dart';

import 'package:rokctapp/infrastructure/repositories/manager/orders_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/payment_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/products_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/settings_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/shops_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/subscription_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/table_repository.dart';
import 'package:rokctapp/infrastructure/repositories/manager/users_repository.dart';
import 'package:rokctapp/infrastructure/repositories/driver/user_repository_impl.dart';

import 'package:rokctapp/domain/interface/driver_draw.dart';
import 'package:rokctapp/domain/interface/driver_settings.dart'
    hide SettingsRepository;
import 'package:rokctapp/domain/interface/driver_user.dart';

import 'package:rokctapp/domain/interface/manager_catalog.dart';
import 'package:rokctapp/domain/interface/manager_notification.dart';
import 'package:rokctapp/domain/interface/manager_orders.dart';

import 'package:rokctapp/domain/interface/manager_products.dart';
import 'package:rokctapp/domain/interface/manager_settings.dart';
import 'package:rokctapp/domain/interface/manager_shops.dart';

import 'package:rokctapp/domain/interface/manager_users.dart';

import 'package:rokctapp/infrastructure/repositories/manager/repositories.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerLazySingleton<HttpService>(() => HttpService());

  final user = LocalStorage.getUser();
  final role = user?.role ?? '';

  if (role == 'deliveryman') {
    getIt.registerSingleton<SettingsRepositoryFacade>(
      cust_settings.SettingsRepository(),
    );
    getIt.registerSingleton<AuthRepositoryFacade>(AuthRepository());
    getIt.registerSingleton<driver_interfaces.UserRepository>(
      UserRepositoryImpl(),
    );
    getIt.registerSingleton<DrawRepositoryFacade>(cust_draw.DrawRepository());
    getIt.registerSingleton<driver_interfaces.OrdersRepositoryFacade>(
      cust.OrdersRepository(),
    );
    getIt.registerSingleton<driver_interfaces.ParcelRepositoryFacade>(
      ParcelRepository(),
    );
    getIt.registerSingleton<driver_interfaces.NotificationRepositoryFacade>(
      NotificationRepositoryImpl(),
    );
  } else if (role == 'seller') {
    getIt.registerSingleton<AuthRepositoryFacade>(AuthRepository());
    getIt.registerSingleton<manager_interfaces.TableInterface>(
      TableRepository(),
    );
    getIt.registerSingleton<manager_interfaces.UsersInterface>(
      UsersRepository(),
    );
    getIt.registerSingleton<manager_interfaces.ShopsInterface>(
      ShopsRepository(),
    );
    getIt.registerSingleton<manager_interfaces.OrdersInterface>(
      OrdersRepository(),
    );
    getIt.registerSingleton<manager_interfaces.CatalogInterface>(
      CatalogRepository(),
    );
    getIt.registerSingleton<manager_interfaces.SettingsInterface>(
      SettingsRepository(),
    );
    getIt.registerSingleton<manager_interfaces.ProductsInterface>(
      ProductsRepository(),
    );
    getIt.registerSingleton<manager_interfaces.NotificationInterface>(
      NotificationRepository(),
    );
    getIt.registerSingleton<PaymentsFacade>(PaymentRepository());
    getIt.registerSingleton<SubscriptionsFacade>(SubscriptionsRepository());
  }

  // Common/Customer dependencies
  getIt.registerSingleton<SettingsRepositoryFacade>(
    cust_settings.SettingsRepository(),
  );
  getIt.registerSingleton<AuthRepositoryFacade>(AuthRepository());
  getIt.registerSingleton<ShopsRepositoryFacade>(cust.ShopsRepository());
  getIt.registerSingleton<ProductsRepositoryFacade>(cust.ProductsRepository());
  getIt.registerSingleton<CategoriesRepositoryFacade>(CategoriesRepository());
  getIt.registerSingleton<BannersRepositoryFacade>(BannersRepository());
  getIt.registerSingleton<CartRepositoryFacade>(CartRepository());
  getIt.registerSingleton<OrdersRepositoryFacade>(cust.OrdersRepository());
  getIt.registerSingleton<AddressRepositoryFacade>(AddressRepository());
  getIt.registerSingleton<BrandsRepositoryFacade>(BrandsRepository());

  getIt.registerSingleton<GalleryRepositoryFacade>(GalleryRepository());
  getIt.registerSingleton<CurrenciesRepositoryFacade>(CurrenciesRepository());
  getIt.registerSingleton<GooglePlace>(GooglePlace(AppConstants.googleApiKey));
  getIt.registerSingleton<PaymentsRepositoryFacade>(PaymentsRepository());
  getIt.registerSingleton<UserRepositoryFacade>(cust_user.UserRepository());
  getIt.registerSingleton<BlogsRepositoryFacade>(BlogsRepository());
  getIt.registerSingleton<DrawRepositoryFacade>(cust_draw.DrawRepository());
  getIt.registerSingleton<ParcelRepositoryFacade>(ParcelRepository());
  getIt.registerSingleton<NotificationRepositoryFacade>(
    NotificationRepositoryImpl(),
  );
  getIt.registerSingleton<Map>(LocalStorage.getTranslations());
  getIt.registerSingleton<WalletRepositoryFacade>(WalletRepository());
  getIt.registerSingleton<LoansRepositoryFacade>(LoansRepository());
  getIt.registerSingleton<DeliveryPointsRepositoryFacade>(
    DeliveryPointsRepository(),
  );
}

final dioHttp = getIt.get<HttpService>();
final appDatabase = getIt.get<AppDatabase>();
final notificationRepo = getIt.get<NotificationRepositoryFacade>();
final drawRepository = getIt.get<DrawRepositoryFacade>();
final settingsRepository = getIt.get<SettingsRepositoryFacade>();
final authRepository = getIt.get<AuthRepositoryFacade>();
final productsRepository = getIt.get<ProductsRepositoryFacade>();
final shopsRepository = getIt.get<ShopsRepositoryFacade>();
final brandsRepository = getIt.get<BrandsRepositoryFacade>();
final galleryRepository = getIt.get<GalleryRepositoryFacade>();
final categoriesRepository = getIt.get<CategoriesRepositoryFacade>();
final currenciesRepository = getIt.get<CurrenciesRepositoryFacade>();
final addressesRepository = getIt.get<AddressRepositoryFacade>();
final bannersRepository = getIt.get<BannersRepositoryFacade>();
final googlePlace = getIt.get<GooglePlace>();
final paymentsRepository = getIt.get<PaymentsRepositoryFacade>();
final ordersRepository = getIt.get<OrdersRepositoryFacade>();
final userRepository = getIt.get<UserRepositoryFacade>();
final blogsRepository = getIt.get<BlogsRepositoryFacade>();
final cartRepository = getIt.get<CartRepositoryFacade>();
final parcelRepository = getIt.get<ParcelRepositoryFacade>();
final translation = getIt.get<Map>();
final walletRepository = getIt.get<WalletRepositoryFacade>();
final loansRepository = getIt.get<LoansRepositoryFacade>();
final deliveryPointsRepository = getIt.get<DeliveryPointsRepositoryFacade>();
final backgroundSyncService = BackgroundSyncService(
  database: appDatabase,
  httpService: dioHttp,
);

// Driver specific accessors
final driverSettingsRepository = getIt
    .get<driver_interfaces.SettingsRepository>();
final driverAuthRepository = getIt.get<AuthRepositoryFacade>();
final driverUserRepository = getIt.get<driver_interfaces.UserRepository>();
final driverDrawRepository = getIt.get<DrawRepositoryFacade>();
final driverOrderRepository = getIt
    .get<driver_interfaces.OrdersRepositoryFacade>();
final driverParcelRepository = getIt
    .get<driver_interfaces.ParcelRepositoryFacade>();
final driverNotificationRepo = getIt
    .get<driver_interfaces.NotificationRepositoryFacade>();

// Manager specific accessors
final managerAuthRepository = getIt.get<AuthRepositoryFacade>();
final managerShopsRepository = getIt.get<manager_interfaces.ShopsInterface>();
final managerTableRepository = getIt.get<manager_interfaces.TableInterface>();
final managerUsersRepository = getIt.get<manager_interfaces.UsersInterface>();
final managerOrdersRepository = getIt.get<manager_interfaces.OrdersInterface>();
final managerCatalogRepository = getIt
    .get<manager_interfaces.CatalogInterface>();
final managerProductRepository = getIt
    .get<manager_interfaces.ProductsInterface>();
final managerSettingsRepository = getIt
    .get<manager_interfaces.SettingsInterface>();
final managerNotificationRepository = getIt
    .get<manager_interfaces.NotificationInterface>();
final managerSubscriptionRepository = getIt.get<SubscriptionsFacade>();
final managerPaymentRepositoryNew = getIt.get<PaymentsFacade>();

// Compatibility Bridge (Aliases for legacy code)
final subscriptionRepository = managerSubscriptionRepository;
final paymentRepositoryNew = managerPaymentRepositoryNew;
final driverOrderRepositoryNew = driverOrderRepository;
final driverParcelRepositoryNew = driverParcelRepository;
