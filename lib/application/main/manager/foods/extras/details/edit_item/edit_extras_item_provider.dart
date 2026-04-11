import 'package:rokctapp/infrastructure/models/data/extras.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/edit_item/edit_extras_item_notifier.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/edit_item/edit_extras_item_state.dart';

final editExtrasItemProvider =
    StateNotifierProvider<EditExtrasItemNotifier, EditExtrasItemState>(
      (ref) => EditExtrasItemNotifier(managerProductRepository),
    );
