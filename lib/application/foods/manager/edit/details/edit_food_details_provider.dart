import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/foods/manager/edit/details/edit_food_details_state.dart';
import 'package:rokctapp/application/foods/manager/edit/details/edit_food_details_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final editFoodDetailsProvider =
    StateNotifierProvider<EditFoodDetailsNotifier, EditFoodDetailsState>(
      (ref) => EditFoodDetailsNotifier(
        managerProductRepository,
        managerSettingsRepository,
      ),
    );
