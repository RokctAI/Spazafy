import 'package:rokctapp/infrastructure/models/data/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/new_item/create_new_group_item_notifier.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/new_item/create_new_group_item_state.dart';

final createNewGroupItemProvider =
    StateNotifierProvider<CreateNewGroupItemNotifier, CreateNewGroupItemState>(
      (ref) => CreateNewGroupItemNotifier(managerProductRepository),
    );
