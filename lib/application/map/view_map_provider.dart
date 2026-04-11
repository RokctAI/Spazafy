import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/map/view_map_notifier.dart';
import 'package:rokctapp/application/map/view_map_state.dart';

final viewMapProvider = StateNotifierProvider<ViewMapNotifier, ViewMapState>(
  (ref) => ViewMapNotifier(shopsRepository, userRepository),
);
