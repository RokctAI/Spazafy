import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/foods/manager/create/details/kitchens/create_food_kitchens_state.dart';
import 'package:rokctapp/application/foods/manager/create/details/kitchens/create_food_kitchens_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final createFoodKitchensProvider =
    StateNotifierProvider<CreateFoodKitchensNotifier, CreateFoodKitchensState>(
      (ref) => CreateFoodKitchensNotifier(managerCatalogRepository),
    );
