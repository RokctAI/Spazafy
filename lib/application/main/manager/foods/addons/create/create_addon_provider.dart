import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/addons/create/create_addon_state.dart';
import 'package:rokctapp/application/main/manager/foods/addons/create/create_addon_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final createAddonProvider =
    StateNotifierProvider.autoDispose<CreateAddonNotifier, CreateAddonState>(
      (ref) => CreateAddonNotifier(managerProductRepository),
    );
