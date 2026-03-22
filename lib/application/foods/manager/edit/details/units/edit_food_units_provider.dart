import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_food_units_state.dart';
import 'edit_food_units_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';


final editFoodUnitsProvider =
    StateNotifierProvider<EditFoodUnitsNotifier, EditFoodUnitsState>(
  (ref) => EditFoodUnitsNotifier(catalogRepository),
);
