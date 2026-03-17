import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';
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
import 'package:rokctapp/domain/interface/loans.dart';
import 'package:rokctapp/domain/interface/wallet.dart';
import 'package:rokctapp/domain/interface/delivery_points.dart';
import 'package:rokctapp/infrastructure/repositories/delivery_points_repository.dart';

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

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<HttpService>(() => HttpService());

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
