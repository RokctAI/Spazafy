import 'package:go_router/go_router.dart';
import 'package:billing_app/presentation/pages/home_page.dart';
import 'package:billing_app/presentation/pages/product_list_page.dart';
import 'package:billing_app/presentation/pages/add_product_page.dart';
import 'package:billing_app/presentation/pages/edit_product_page.dart';
import 'package:billing_app/presentation/pages/shop_details_page.dart';
import 'package:billing_app/presentation/pages/settings_page.dart';
import 'package:billing_app/presentation/pages/scanner_page.dart';
import 'package:billing_app/presentation/pages/checkout_page.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'scanner',
          builder: (context, state) => const ScannerPage(),
        ),
        GoRoute(
          path: 'checkout',
          builder: (context, state) => const CheckoutPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) {
            final barcode = state.extra as String?;
            return AddProductPage(initialBarcode: barcode);
          },
        ),
        GoRoute(
          path: 'edit/:id',
          builder: (context, state) {
            final product = state.extra as Product?;
            if (product == null) {
              // If we land here without extra (e.g. deep link), go back to products for now.
              return const ProductListPage();
            }
            return EditProductPage(product: product);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopDetailsPage(),
    ),
  ],
);
