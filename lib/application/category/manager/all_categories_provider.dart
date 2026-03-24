import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'all_categories_notifier.dart';
import 'all_categories_state.dart';

import 'package:rokctapp/domain/di/dependency_manager.dart';

final allCategoriesProvider =
    StateNotifierProvider<AllCategoriesNotifier, AllCategoriesState>(
      (ref) => AllCategoriesNotifier(managerCatalogRepository),
    );
