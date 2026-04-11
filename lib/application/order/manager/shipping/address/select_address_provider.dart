import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/shipping/address/select_address_state.dart';
import 'package:rokctapp/application/order/manager/shipping/address/select_address_notifier.dart';

final selectAddressProvider =
    StateNotifierProvider<SelectAddressNotifier, SelectAddressState>(
      (ref) => SelectAddressNotifier(),
    );
