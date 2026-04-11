import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/foods/manager/create/stocks/addons/create_food_addons_notifier.dart';
import 'package:rokctapp/application/foods/manager/create/stocks/addons/create_food_addons_state.dart';

final createFoodAddonsProvider =
    StateNotifierProvider<CreateFoodAddonsNotifier, CreateFoodAddonsState>(
      (ref) => CreateFoodAddonsNotifier(managerProductRepository),
    );
