import 'package:rokctapp/infrastructure/models/data/extras.dart';
import 'package:rokctapp/infrastructure/models/data/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/extras_group_details_state.dart';
import 'package:rokctapp/application/main/manager/foods/extras/details/extras_group_details_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final extrasGroupDetailsProvider =
    StateNotifierProvider<ExtrasGroupDetailsNotifier, ExtrasGroupDetailsState>(
      (ref) => ExtrasGroupDetailsNotifier(managerProductRepository),
    );
