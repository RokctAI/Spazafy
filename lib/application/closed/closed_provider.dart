import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/closed/closed_notifier.dart';
import 'package:rokctapp/application/closed/closed_state.dart';

final closedProvider =
    StateNotifierProvider.autoDispose<ClosedNotifier, ClosedState>(
      (ref) => ClosedNotifier(),
    );
