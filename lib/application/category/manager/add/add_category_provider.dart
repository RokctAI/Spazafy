import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/category/manager/add/add_category_state.dart';
import 'package:rokctapp/application/category/manager/add/add_category_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final addCategoryProvider =
    StateNotifierProvider.autoDispose<AddCategoryNotifier, AddCategoryState>(
      (ref) => AddCategoryNotifier(managerCatalogRepository),
    );
