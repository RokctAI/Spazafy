import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'accepted_orders_state.dart';
import 'accepted_orders_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final acceptedOrdersProvider =
    StateNotifierProvider<AcceptedOrdersNotifier, AcceptedOrdersState>(
      (ref) => AcceptedOrdersNotifier(ordersRepository),
    );
