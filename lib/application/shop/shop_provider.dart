import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/shop/shop_notifier.dart';
import 'package:rokctapp/application/shop/shop_state.dart';

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>(
  (ref) => ShopNotifier(
    shopsRepository,
    productsRepository,
    categoriesRepository,
    drawRepository,
    brandsRepository,
  ),
);
