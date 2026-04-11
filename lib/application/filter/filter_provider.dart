import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/filter/filter_notifier.dart';
import 'package:rokctapp/application/filter/filter_state.dart';

final filterProvider =
    StateNotifierProvider.autoDispose<FilterNotifier, FilterState>(
      (ref) => FilterNotifier(shopsRepository),
    );
