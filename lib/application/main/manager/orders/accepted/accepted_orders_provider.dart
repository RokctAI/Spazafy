import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/orders/accepted/accepted_orders_state.dart';
import 'package:rokctapp/application/main/manager/orders/accepted/accepted_orders_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final acceptedOrdersProvider =
    StateNotifierProvider<AcceptedOrdersNotifier, AcceptedOrdersState>(
      (ref) => AcceptedOrdersNotifier(managerOrdersRepository),
    );
