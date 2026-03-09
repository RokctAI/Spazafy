import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_app/presentation/routes/app_routes.dart';
import 'package:billing_app/infrastructure/services/hive_database.dart';
import 'package:billing_app/infrastructure/services/service_locator.dart' as di;
import 'package:billing_app/presentation/theme/app_theme.dart';
import 'package:billing_app/application/billing/billing_bloc.dart';
import 'package:billing_app/application/product/product_bloc.dart';
import 'package:billing_app/application/shop/shop_bloc.dart';
import 'package:billing_app/application/settings/printer_bloc.dart';
import 'package:billing_app/application/settings/printer_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.init();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => di.sl<ProductBloc>()..add(LoadProducts()),
        ),
        BlocProvider<ShopBloc>(
          create: (context) => di.sl<ShopBloc>()..add(LoadShopEvent()),
        ),
        BlocProvider<BillingBloc>(
          create: (context) => BillingBloc(getProductByBarcodeUseCase: di.sl()),
        ),
        BlocProvider<PrinterBloc>(
          create: (context) => di.sl<PrinterBloc>()..add(InitPrinterEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Billing App',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
