import 'package:rokctapp/infrastructure/models/data/extras.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/extras/extras_state.dart';
import 'package:rokctapp/application/main/manager/foods/extras/extras_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final extrasProvider = StateNotifierProvider<ExtrasNotifier, ExtrasState>(
  (ref) => ExtrasNotifier(managerProductRepository),
);
