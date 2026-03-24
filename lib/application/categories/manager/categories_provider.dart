import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'categories_state.dart';
import 'categories_notifier.dart';

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, CategoriesState>(
      (ref) => CategoriesNotifier(managerCatalogRepository),
    );
