import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'foods_notifier.dart';
import 'foods_state.dart';

final foodsProvider = StateNotifierProvider<FoodsNotifier, FoodsState>(
  (ref) => FoodsNotifier(productsRepository),
);
