import 'package:get_it/get_it.dart';
import 'package:billing_app/infrastructure/repository/impl/product_repository_impl.dart';
import 'package:billing_app/infrastructure/repository/product_repository.dart';
import 'package:billing_app/infrastructure/models/usecases/product_usecases.dart';
import 'package:billing_app/application/product/product_bloc.dart';
import 'package:billing_app/infrastructure/repository/impl/shop_repository_impl.dart';
import 'package:billing_app/infrastructure/repository/shop_repository.dart';
import 'package:billing_app/infrastructure/models/usecases/shop_usecases.dart';
import 'package:billing_app/application/shop/shop_bloc.dart';
import 'package:billing_app/infrastructure/repository/impl/printer_repository_impl.dart';
import 'package:billing_app/infrastructure/repository/printer_repository.dart';
import 'package:billing_app/application/settings/printer_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Product
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getProductsUseCase: sl(),
      addProductUseCase: sl(),
      updateProductUseCase: sl(),
      deleteProductUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ShopBloc(
      getShopUseCase: sl(),
      updateShopUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PrinterBloc(
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByBarcodeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(),
  );

  // Features - Shop
  // Use cases
  sl.registerLazySingleton(() => GetShopUseCase(sl()));
  sl.registerLazySingleton(() => UpdateShopUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(),
  );

  // Features - Settings / Printer
  sl.registerLazySingleton<PrinterRepository>(
    () => PrinterRepositoryImpl(),
  );
}
