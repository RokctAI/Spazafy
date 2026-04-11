import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/tabs/food_tabs_state.dart';
import 'package:rokctapp/application/main/manager/foods/tabs/food_tabs_notifier.dart';

final foodTabsProvider = StateNotifierProvider<FoodTabsNotifier, FoodTabsState>(
  (ref) => FoodTabsNotifier(),
);
