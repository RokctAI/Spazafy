import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:rokctapp/infrastructure/models/data/manager/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'create_extras_group_notifier.dart';
import 'create_extras_group_state.dart';

final createExtrasGroupProvider =
    StateNotifierProvider<CreateExtrasGroupNotifier, CreateExtrasGroupState>(
      (ref) => CreateExtrasGroupNotifier(managerProductRepository),
    );
