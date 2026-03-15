import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';

// Handlers
import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

// Customer Interfaces
import 'package:venderfoodyman/domain/interface/customer/address.dart';
import 'package:venderfoodyman/domain/interface/auth.dart';
import 'package:venderfoodyman/domain/interface/banners.dart';
import 'package:venderfoodyman/domain/interface/customer/blogs.dart';
import 'package:venderfoodyman/domain/interface/brands.dart';
import 'package:venderfoodyman/domain/interface/cart.dart';
import 'package:venderfoodyman/domain/interface/categories.dart';
import 'package:venderfoodyman/domain/interface/customer/currencies.dart';
import 'package:venderfoodyman/domain/interface/customer/draw.dart';
import 'package:venderfoodyman/domain/interface/customer/gallery.dart';
import 'package:venderfoodyman/domain/interface/customer/notification.dart';
import 'package:venderfoodyman/domain/interface/orders.dart';
import 'package:venderfoodyman/domain/interface/customer/parcel.dart';
import 'package:venderfoodyman/domain/interface/payments.dart';
import 'package:venderfoodyman/domain/interface/products.dart';
import 'package:venderfoodyman/domain/interface/customer/settings.dart';
import 'package:venderfoodyman/domain/interface/shops.dart';
import 'package:venderfoodyman/domain/interface/user.dart';
import 'package:venderfoodyman/domain/interface/customer/loans.dart';
import 'package:venderfoodyman/domain/interface/customer/wallet.dart';
import 'package:venderfoodyman/domain/interface/customer/delivery_points.dart';
import 'package:venderfoodyman/domain/interface/customer/table.dart';
import 'package:venderfoodyman/domain/interface/customer/subscriptions.dart';

// Customer Repositories
import 'package:venderfoodyman/infrastructure/repositories/customer/address_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/auth_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/banners_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/blogs_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/brands_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/cart_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/catalog_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/currencies_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/draw_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/gallery_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/notification_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/orders_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/parcel_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/payments_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/products_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/settings_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/shops_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/user_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/loans_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/wallet_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/table_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/subscription_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/delivery_points_repository.dart';
import 'package:venderfoodyman/infrastructure/repositories/customer/mock/mock_repositories.dart'
    as mock;

// Router
import 'package:venderfoodyman/presentation/routes/app_router.dart';

// Services
import 'package:venderfoodyman/customer/app_constants.dart';
import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart';

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
