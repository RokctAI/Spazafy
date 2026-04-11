import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/main/manager/foods/addons/create/units/create_addon_units_notifier.dart';
import 'package:rokctapp/application/main/manager/foods/addons/create/units/create_addon_units_state.dart';

final createAddonUnitsProvider =
    StateNotifierProvider<CreateAddonUnitsNotifier, CreateAddonUnitsState>(
      (ref) => CreateAddonUnitsNotifier(managerCatalogRepository),
    );
