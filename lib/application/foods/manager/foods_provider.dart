import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/foods/manager/foods_state.dart';
import 'package:rokctapp/application/foods/manager/foods_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final foodsProvider = StateNotifierProvider<FoodsNotifier, FoodsState>(
  (ref) => FoodsNotifier(managerProductRepository),
);
