import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_category_state.dart';
import 'add_category_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';


final addCategoryProvider =
    StateNotifierProvider.autoDispose<AddCategoryNotifier, AddCategoryState>(
  (ref) => AddCategoryNotifier(catalogRepository),
);
