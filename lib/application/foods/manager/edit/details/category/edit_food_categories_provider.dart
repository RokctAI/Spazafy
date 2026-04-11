import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/foods/manager/edit/details/category/edit_food_categories_state.dart';
import 'package:rokctapp/application/foods/manager/edit/details/category/edit_food_categories_notifier.dart';

final editFoodCategoriesProvider =
    StateNotifierProvider<EditFoodCategoriesNotifier, EditFoodCategoriesState>(
      (ref) => EditFoodCategoriesNotifier(),
    );
