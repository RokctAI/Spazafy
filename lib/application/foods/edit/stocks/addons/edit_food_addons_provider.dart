import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_food_addons_state.dart';
import 'edit_food_addons_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final editFoodAddonsProvider =
    StateNotifierProvider<EditFoodAddonsNotifier, EditFoodAddonsState>(
      (ref) => EditFoodAddonsNotifier(productRepository),
    );
