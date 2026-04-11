import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/shop_order/shop_order_notifier.dart';
import 'package:rokctapp/application/shop_order/shop_order_state.dart';

final shopOrderProvider =
    StateNotifierProvider<ShopOrderNotifier, ShopOrderState>(
      (ref) => ShopOrderNotifier(cartRepository),
    );
