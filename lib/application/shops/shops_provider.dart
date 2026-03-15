import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/dependency_manager.dart';
import 'shops_notifier.dart';
import 'shops_state.dart';

final shopsProvider = StateNotifierProvider<ShopsNotifier, ShopsState>(
  (ref) => ShopsNotifier(shopsRepository),
);
