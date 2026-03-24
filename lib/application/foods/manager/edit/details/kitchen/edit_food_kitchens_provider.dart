import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_food_kitchens_state.dart';
import 'edit_food_kitchens_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final editFoodKitchensProvider =
    StateNotifierProvider<EditFoodKitchensNotifier, EditFoodKitchensState>(
      (ref) => EditFoodKitchensNotifier(managerCatalogRepository),
    );
