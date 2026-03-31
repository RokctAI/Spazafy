import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'delete_extras_item_notifier.dart';
import 'delete_extras_item_state.dart';

final deleteExtrasItemProvider =
    StateNotifierProvider<DeleteExtrasItemNotifier, DeleteExtrasItemState>(
      (ref) => DeleteExtrasItemNotifier(managerProductRepository),
    );
