import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/foods/manager/edit/details/units/edit_food_units_state.dart';
import 'package:rokctapp/application/foods/manager/edit/details/units/edit_food_units_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final editFoodUnitsProvider =
    StateNotifierProvider<EditFoodUnitsNotifier, EditFoodUnitsState>(
      (ref) => EditFoodUnitsNotifier(managerCatalogRepository),
    );
