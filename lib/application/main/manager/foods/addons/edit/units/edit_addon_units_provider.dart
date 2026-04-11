import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/main/manager/foods/addons/edit/units/edit_addon_units_notifier.dart';
import 'package:rokctapp/application/main/manager/foods/addons/edit/units/edit_addon_units_state.dart';

final editAddonUnitsProvider =
    StateNotifierProvider<EditAddonUnitsNotifier, EditAddonUnitsState>(
      (ref) => EditAddonUnitsNotifier(managerCatalogRepository),
    );
