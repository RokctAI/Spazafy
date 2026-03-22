import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_food_kitchens_state.dart';
import 'create_food_kitchens_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';


final createFoodKitchensProvider =
    StateNotifierProvider<CreateFoodKitchensNotifier, CreateFoodKitchensState>(
  (ref) => CreateFoodKitchensNotifier(catalogRepository),
);
