import 'package:rokctapp/infrastructure/models/data/extras.dart';
import 'package:rokctapp/infrastructure/models/data/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/extras/update/update_extras_group_state.dart';
import 'package:rokctapp/application/main/manager/foods/extras/update/update_extras_group_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final updateExtrasGroupProvider =
    StateNotifierProvider<UpdateExtrasGroupNotifier, UpdateExtrasGroupState>(
      (ref) => UpdateExtrasGroupNotifier(managerProductRepository),
    );
