import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/product/product_notifier.dart';
import 'package:rokctapp/application/product/product_state.dart';

final productProvider =
    StateNotifierProvider.autoDispose<ProductNotifier, ProductState>(
      (ref) => ProductNotifier(cartRepository, productsRepository),
    );
