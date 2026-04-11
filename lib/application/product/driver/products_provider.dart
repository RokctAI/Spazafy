import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/product/driver/products_notifier.dart';
import 'package:rokctapp/application/product/driver/products_state.dart';

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) => ProductsNotifier(),
);
