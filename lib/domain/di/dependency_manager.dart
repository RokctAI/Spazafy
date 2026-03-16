import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';

// Handlers
import 'package:rokctapp/domain/handlers/handlers.dart';

// Customer Interfaces
import 'package:rokctapp/domain/interface/address.dart';
import 'package:rokctapp/domain/interface/auth.dart';
import 'package:rokctapp/domain/interface/banners.dart';
import 'package:rokctapp/domain/interface/blogs.dart';
import 'package:rokctapp/domain/interface/brands.dart';
import 'package:rokctapp/domain/interface/cart.dart';
import 'package:rokctapp/domain/interface/categories.dart';
import 'package:rokctapp/domain/interface/currencies.dart';
import 'package:rokctapp/domain/interface/draw.dart';
import 'package:rokctapp/domain/interface/gallery.dart';
import 'package:rokctapp/domain/interface/notification.dart';
import 'package:rokctapp/domain/interface/orders.dart';
import 'package:rokctapp/domain/interface/parcel.dart';
import 'package:rokctapp/domain/interface/payments.dart';
import 'package:rokctapp/domain/interface/products.dart';
import 'package:rokctapp/domain/interface/settings.dart';
import 'package:rokctapp/domain/interface/shops.dart';
import 'package:rokctapp/domain/interface/user.dart';
import 'package:rokctapp/domain/interface/loans.dart';
import 'package:rokctapp/domain/interface/wallet.dart';
import 'package:rokctapp/domain/interface/delivery_points.dart';
import 'package:rokctapp/domain/interface/table.dart';
import 'package:rokctapp/domain/interface/subscriptions.dart';

// Customer Repositories
import 'package:rokctapp/infrastructure/repositories/address_repository.dart';
import 'package:rokctapp/infrastructure/repositories/auth_repository.dart';
import 'package:rokctapp/infrastructure/repositories/banners_repository.dart';
import 'package:rokctapp/infrastructure/repositories/blogs_repository.dart';
import 'package:rokctapp/infrastructure/repositories/brands_repository.dart';
import 'package:rokctapp/infrastructure/repositories/cart_repository.dart';
import 'package:rokctapp/infrastructure/repositories/catalog_repository.dart';
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
import 'package:rokctapp/infrastructure/repositories/loans_repository.dart';
import 'package:rokctapp/infrastructure/repositories/wallet_repository.dart';
import 'package:rokctapp/infrastructure/repositories/table_repository.dart';
import 'package:rokctapp/infrastructure/repositories/subscription_repository.dart';
import 'package:rokctapp/infrastructure/repositories/delivery_points_repository.dart';
import 'package:rokctapp/infrastructure/repositories/mock/mock_repositories.dart'
    as mock;

// Router
import 'package:rokctapp/presentation/routes/app_router.dart';

// Services
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  // core
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerLazySingleton<GooglePlace>(
    () => GooglePlace(AppConstants.googleApiKey),
  );
  getIt.registerLazySingleton<Map>(() => LocalStorage.getTranslations());

  // Hub Module (Unified)
  if (AppConstants.isDemo) {
    getIt.registerSingleton<SettingsFacade>(mock.MockSettingsRepository());
    getIt.registerSingleton<AuthFacade>(mock.MockAuthRepository());
    getIt.registerSingleton<ShopsFacade>(mock.MockShopsRepository());
    getIt.registerSingleton<ProductsFacade>(mock.MockProductsRepository());
    getIt.registerSingleton<CategoriesFacade>(mock.MockCategoriesRepository());
    getIt.registerSingleton<BannersFacade>(mock.MockBannersRepository());
    getIt.registerSingleton<CartFacade>(mock.MockCartRepository());
    getIt.registerSingleton<OrdersFacade>(mock.MockOrdersRepository());
    getIt.registerSingleton<AddressFacade>(mock.MockAddressRepository());
    getIt.registerSingleton<BrandsFacade>(mock.MockBrandsRepository());
  } else {
    getIt.registerSingleton<SettingsFacade>(SettingsRepository());
    getIt.registerSingleton<AuthFacade>(AuthRepository());
    getIt.registerSingleton<ShopsFacade>(ShopsRepository());
    getIt.registerSingleton<ProductsFacade>(ProductsRepository());
    getIt.registerSingleton<CategoriesFacade>(
      CatalogRepository(),
    ); // Unified Catalog
    getIt.registerSingleton<CatalogInterface>(
      CatalogRepository(),
    ); // Manager Catalog
    getIt.registerSingleton<BannersFacade>(BannersRepository());
    getIt.registerSingleton<CartFacade>(CartRepository());
    getIt.registerSingleton<OrdersFacade>(OrdersRepository());
    getIt.registerSingleton<AddressFacade>(AddressRepository());
    getIt.registerSingleton<BrandsFacade>(BrandsRepository());
  }

  getIt.registerSingleton<GalleryFacade>(GalleryRepository());
  getIt.registerSingleton<CurrenciesFacade>(CurrenciesRepository());
  getIt.registerSingleton<PaymentsFacade>(PaymentsRepository());
  getIt.registerSingleton<UserFacade>(UserRepository());
  getIt.registerSingleton<BlogsFacade>(BlogsRepository());
  getIt.registerSingleton<DrawFacade>(DrawRepository());
  getIt.registerSingleton<ParcelFacade>(ParcelRepository());
  getIt.registerSingleton<NotificationFacade>(NotificationRepositoryImpl());
  getIt.registerSingleton<WalletFacade>(WalletRepository());
  getIt.registerSingleton<LoansFacade>(LoansRepository());
  getIt.registerSingleton<DeliveryPointsFacade>(DeliveryPointsRepository());

  // Manager/Driver Specific (Pointing to Unified Hub)
  getIt.registerSingleton<TableInterface>(TableRepository());
  getIt.registerSingleton<SubscriptionsFacade>(SubscriptionsRepository());

  getIt.registerSingleton<AppRouter>(AppRouter());
}

// Global accessor shortcuts (for legacy code/migration)
final dioHttp = getIt.get<HttpService>();
final translation = getIt.get<Map>();
final googlePlace = getIt.get<GooglePlace>();

// Customer accessors
final notificationRepo = getIt.get<NotificationFacade>();
final drawRepository = getIt.get<DrawFacade>();
final settingsRepository = getIt.get<SettingsFacade>();
final authRepository = getIt.get<AuthFacade>();
final productsRepository = getIt.get<ProductsFacade>();
final shopsRepository = getIt.get<ShopsFacade>();
final brandsRepository = getIt.get<BrandsFacade>();
final galleryRepository = getIt.get<GalleryFacade>();
final categoriesRepository = getIt.get<CategoriesFacade>();
final currenciesRepository = getIt.get<CurrenciesFacade>();
final addressesRepository = getIt.get<AddressFacade>();
final bannersRepository = getIt.get<BannersFacade>();
final paymentsRepository = getIt.get<PaymentsFacade>();
final ordersRepository = getIt.get<OrdersFacade>();
final userRepository = getIt.get<UserFacade>();
final blogsRepository = getIt.get<BlogsFacade>();
final cartRepository = getIt.get<CartFacade>();
final parcelRepository = getIt.get<ParcelFacade>();
final walletRepository = getIt.get<WalletFacade>();
final loansRepository = getIt.get<LoansFacade>();
final deliveryPointsRepository = getIt.get<DeliveryPointsFacade>();

// Driver accessors
final driverSettingsRepo = getIt.get<SettingsFacade>();
final driverAuthRepo = getIt.get<AuthFacade>();
final driverUserRepo = getIt.get<UserFacade>();

// Manager accessors
final managerAuthRepo = getIt.get<AuthFacade>();
final managerUsersRepo = getIt.get<UserFacade>();
final router = getIt.get<AppRouter>();
