import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';
import 'package:rokctapp/domain/interface/interfaces.dart';
import 'package:rokctapp/infrastructure/repositories/address_repository.dart';
import 'package:rokctapp/infrastructure/repositories/auth_repository.dart';
import 'package:rokctapp/infrastructure/repositories/banners_repository.dart';
import 'package:rokctapp/infrastructure/repositories/blogs_repository.dart';
import 'package:rokctapp/infrastructure/repositories/brands_repository.dart';
import 'package:rokctapp/infrastructure/repositories/cart_repository.dart';
import 'package:rokctapp/infrastructure/repositories/categories_repository.dart';
import 'package:rokctapp/infrastructure/repositories/currencies_repository.dart';
import 'package:rokctapp/infrastructure/repositories/draw_repository.dart';
import 'package:rokctapp/infrastructure/repositories/gallery_repository.dart';
import 'package:rokctapp/infrastructure/repositories/notification_repository.dart';
import 'package:rokctapp/infrastructure/repositories/orders_repository.dart';
import 'package:rokctapp/infrastructure/repositories/parcel_repository.dart';
import 'package:rokctapp/infrastructure/repositories/payments_repository.dart';
import 'package:rokctapp/infrastructure/repositories/products_repository.dart';
import 'package:rokctapp/infrastructure/repositories/settings_repository.dart';
import 'package:rokctapp/infrastructure/repositories/shops_repository.dart';
import 'package:rokctapp/infrastructure/repositories/user_repository.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/repositories/loans_repository.dart';
import 'package:rokctapp/infrastructure/repositories/wallet_repository.dart';
import 'package:rokctapp/domain/handlers/http_service.dart';

import 'package:rokctapp/infrastructure/repositories/delivery_points_repository.dart';
import 'package:rokctapp/infrastructure/services/utils/app_database.dart';

import 'package:rokctapp/infrastructure/repositories/mock/mock_auth_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_settings_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_shops_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_products_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_categories_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_banners_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_cart_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_orders_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_address_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_brands_repository.dart';

// Driver specific imports
import 'package:rokctapp/domain/handlers/driver/handlers.dart' as driver_handlers;
import 'package:rokctapp/domain/interface/interfaces.dart' as driver_interfaces;
import 'package:rokctapp/infrastructure/repositories/driver/repositories.dart' as driver_repos;

// Manager specific imports
import 'package:rokctapp/domain/interface/interfaces.dart' as manager_interfaces;
import 'package:rokctapp/domain/interface/manager_payment.dart';
import 'package:rokctapp/domain/interface/manager_subscription.dart';
import 'package:rokctapp/domain/interface/manager_table.dart';
import 'package:rokctapp/infrastructure/repositories/manager/repositories.dart' as manager_repos;
import 'package:rokctapp/presentation/routes/app_router.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerSingleton<AppRouter>(AppRouter());

  final user = LocalStorage.getUser();
  final role = user?.role ?? '';

  if (role == 'deliveryman') {
    getIt.registerSingleton<driver_interfaces.SettingsRepository>(
      driver_repos.SettingsRepositoryImpl(),
    );
    getIt.registerSingleton<driver_interfaces.AuthRepository>(
      AuthRepository(),
    );
    getIt.registerSingleton<driver_interfaces.UserRepository>(
      driver_repos.UserRepositoryImpl(),
    );
    getIt.registerSingleton<driver_interfaces.DrawRepository>(
      driver_repos.DrawRepositoryImpl(),
    );
    getIt.registerSingleton<driver_interfaces.OrdersRepositoryFacade>(
      driver_repos.OrdersRepository(),
    );
    getIt.registerSingleton<driver_interfaces.ParcelRepositoryFacade>(
      driver_repos.ParcelRepository(),
    );
    getIt.registerSingleton<driver_interfaces.NotificationRepositoryFacade>(
      driver_repos.NotificationRepositoryImpl(),
    );
  } else if (role == 'seller') {
    getIt.registerSingleton<manager_interfaces.AuthInterface>(
      AuthRepository(),
    );
    getIt.registerSingleton<manager_interfaces.TableInterface>(
      manager_repos.TableRepository(),
    );
    getIt.registerSingleton<manager_interfaces.UsersInterface>(
      manager_repos.UsersRepository(),
    );
    getIt.registerSingleton<manager_interfaces.ShopsInterface>(
      manager_repos.ShopsRepository(),
    );
    getIt.registerSingleton<manager_interfaces.OrdersInterface>(
      manager_repos.OrdersRepository(),
    );
    getIt.registerSingleton<manager_interfaces.CatalogInterface>(
      manager_repos.CatalogRepository(),
    );
    getIt.registerSingleton<manager_interfaces.SettingsInterface>(
      manager_repos.SettingsRepository(),
    );
    getIt.registerSingleton<manager_interfaces.ProductsInterface>(
      manager_repos.ProductsRepository(),
    );
    getIt.registerSingleton<manager_interfaces.NotificationInterface>(
      manager_repos.NotificationRepository(),
    );
    getIt.registerSingleton<PaymentsFacade>(manager_repos.PaymentRepository());
    getIt.registerSingleton<SubscriptionsFacade>(
      manager_repos.SubscriptionsRepository(),
    );
  }

  // Common/Customer dependencies
  if (AppConstants.isDemo) {
    getIt.registerSingleton<SettingsRepositoryFacade>(MockSettingsRepository());
    getIt.registerSingleton<AuthRepositoryFacade>(MockAuthRepository());
    getIt.registerSingleton<ShopsRepositoryFacade>(MockShopsRepository());
    getIt.registerSingleton<ProductsRepositoryFacade>(MockProductsRepository());
    getIt.registerSingleton<CategoriesRepositoryFacade>(
      MockCategoriesRepository(),
    );
    getIt.registerSingleton<BannersRepositoryFacade>(MockBannersRepository());
    getIt.registerSingleton<CartRepositoryFacade>(MockCartRepository());
    getIt.registerSingleton<OrdersRepositoryFacade>(MockOrdersRepository());
    getIt.registerSingleton<AddressRepositoryFacade>(MockAddressRepository());
    getIt.registerSingleton<BrandsRepositoryFacade>(MockBrandsRepository());
  } else {
    getIt.registerSingleton<SettingsRepositoryFacade>(SettingsRepository());
    getIt.registerSingleton<AuthRepositoryFacade>(AuthRepository());
    getIt.registerSingleton<ShopsRepositoryFacade>(ShopsRepository());
    getIt.registerSingleton<ProductsRepositoryFacade>(ProductsRepository());
    getIt.registerSingleton<CategoriesRepositoryFacade>(CategoriesRepository());
    getIt.registerSingleton<BannersRepositoryFacade>(BannersRepository());
    getIt.registerSingleton<CartRepositoryFacade>(CartRepository());
    getIt.registerSingleton<OrdersRepositoryFacade>(OrdersRepository());
    getIt.registerSingleton<AddressRepositoryFacade>(AddressRepository());
    getIt.registerSingleton<BrandsRepositoryFacade>(BrandsRepository());
  }

  getIt.registerSingleton<GalleryRepositoryFacade>(GalleryRepository());
  getIt.registerSingleton<CurrenciesRepositoryFacade>(CurrenciesRepository());
  getIt.registerSingleton<GooglePlace>(GooglePlace(AppConstants.googleApiKey));
  getIt.registerSingleton<PaymentsRepositoryFacade>(PaymentsRepository());
  getIt.registerSingleton<UserRepositoryFacade>(UserRepository());
  getIt.registerSingleton<BlogsRepositoryFacade>(BlogsRepository());
  getIt.registerSingleton<DrawRepositoryFacade>(DrawRepository());
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
//final walletRepository = WalletRepository();
final walletRepository = getIt.get<WalletRepositoryFacade>();
final loansRepository = getIt.get<LoansRepositoryFacade>();
final deliveryPointsRepository = getIt.get<DeliveryPointsRepositoryFacade>();

// Driver specific accessors
final driverSettingsRepository = getIt.get<driver_interfaces.SettingsRepository>();
final driverAuthRepository = getIt.get<driver_interfaces.AuthRepository>();
final driverUserRepository = getIt.get<driver_interfaces.UserRepository>();
final driverDrawRepository = getIt.get<driver_interfaces.DrawRepository>();
final driverOrderRepository = getIt.get<driver_interfaces.OrdersRepositoryFacade>();
final driverParcelRepository = getIt.get<driver_interfaces.ParcelRepositoryFacade>();
final driverNotificationRepo =
    getIt.get<driver_interfaces.NotificationRepositoryFacade>();
final appRouter = getIt.get<AppRouter>();

// Manager specific accessors
final managerAuthRepository = getIt.get<manager_interfaces.AuthInterface>();
final managerShopsRepository = getIt.get<manager_interfaces.ShopsInterface>();
final managerTableRepository = getIt.get<manager_interfaces.TableInterface>();
final managerUsersRepository = getIt.get<manager_interfaces.UsersInterface>();
final managerOrdersRepository = getIt.get<manager_interfaces.OrdersInterface>();
final managerCatalogRepository = getIt.get<manager_interfaces.CatalogInterface>();
final managerProductRepository = getIt.get<manager_interfaces.ProductsInterface>();
final managerSettingsRepository = getIt.get<manager_interfaces.SettingsInterface>();
final managerNotificationRepository =
    getIt.get<manager_interfaces.NotificationInterface>();
final managerSubscriptionRepository = getIt.get<SubscriptionsFacade>();
final managerPaymentRepositoryNew = getIt.get<PaymentsFacade>();

