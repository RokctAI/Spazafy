import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/main/manager/orders/cooking/cooking_orders_notifier.dart';
import 'package:rokctapp/application/main/manager/orders/cooking/cooking_orders_state.dart';

final cookingOrdersProvider =
    StateNotifierProvider<CookingOrdersNotifier, CookingOrdersState>(
      (ref) => CookingOrdersNotifier(managerOrdersRepository),
    );
