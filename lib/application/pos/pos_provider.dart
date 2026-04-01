import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order_cart/manager/order_cart_provider.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

import 'package:rokctapp/infrastructure/services/utils/app_database.dart';
import 'package:rokctapp/infrastructure/services/utils/background_sync_service.dart';
import 'package:uuid/uuid.dart';
import 'package:rokctapp/infrastructure/models/data/refund_data.dart';

class PosNotifier extends StateNotifier<bool> {
  final Ref ref;

  PosNotifier(this.ref) : super(false);

  Future<void> finishSale({
    required String paymentType,
    required double amountPaid,
    String? customerId,
    String? customerName,
  }) async {
    state = true;
    try {
      final cartState = ref.read(orderCartProvider);
      if (cartState.stocks.isEmpty) return;

      final orderId = const Uuid().v4();
      final now = DateTime.now();

      // 1. Prepare Order Body for Sync
      final List<Map<String, dynamic>> details = cartState.stocks.map((stock) {
        return {
          'stock_id': stock.id,
          'product_id': stock.product?.id,
          'quantity': stock.cartCount,
          'price': stock.totalPrice,
          'cost_price': stock.price, // Assuming price is cost for now
        };
      }).toList();

      final orderBody = {
        'id': orderId,
        'payment_type': paymentType,
        'total_price': cartState.totalPrice,
        'details': details,
        'created_at': now.toIso8601String(),
        if (customerId != null) 'customer_id': customerId,
      };

      // 2. Enqueue for Background Sync
      await backgroundSyncService.enqueueRequest(
        '/api/v1/method/paas.api.order.order.create_order',
        'POST',
        orderBody,
      );

      // 3. Manually insert into Local Drift DB for immediate visibility
      await appDatabase.upsertOrder(orderBody);

      // 4. Clear Cart
      ref.read(orderCartProvider.notifier).clearAll();

      debugPrint('==> POS Sale Finished: $orderId');
    } catch (e) {
      debugPrint('==> POS Sale Error: $e');
    } finally {
      state = false;
    }
  }
}

final posProvider = StateNotifierProvider<PosNotifier, bool>((ref) {
  return PosNotifier(ref);
});
