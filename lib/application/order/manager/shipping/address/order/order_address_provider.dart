import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/shipping/address/order/order_address_state.dart';
import 'package:rokctapp/application/order/manager/shipping/address/order/order_address_notifier.dart';

final orderAddressProvider =
    StateNotifierProvider<OrderAddressNotifier, OrderAddressState>(
      (ref) => OrderAddressNotifier(),
    );
