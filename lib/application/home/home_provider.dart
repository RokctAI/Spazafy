import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/home/home_notifier.dart';
import 'package:rokctapp/application/home/home_state.dart';

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(
    categoriesRepository,
    bannersRepository,
    shopsRepository,
    productsRepository,
    brandsRepository,
  ),
);
