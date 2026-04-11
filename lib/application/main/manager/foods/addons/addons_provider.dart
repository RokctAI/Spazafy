import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/main/manager/foods/addons/addons_notifier.dart';
import 'package:rokctapp/application/main/manager/foods/addons/addons_state.dart';

final addonsProvider = StateNotifierProvider<AddonsNotifier, AddonsState>(
  (ref) => AddonsNotifier(managerProductRepository),
);
