import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/tabs/food_tabs_state.dart';

class FoodTabsNotifier extends StateNotifier<FoodTabsState> {
  FoodTabsNotifier() : super(const FoodTabsState());

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
