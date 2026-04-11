import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/food/driver/food_notifier.dart';
import 'package:rokctapp/application/food/driver/food_state.dart';

final foodProvider = StateNotifierProvider<FoodNotifier, FoodState>(
  (ref) => FoodNotifier(),
);
