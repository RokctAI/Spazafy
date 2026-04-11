import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/floating_button/floating_notifier.dart';
import 'package:rokctapp/application/floating_button/floating_state.dart';

final floatingProvider = StateNotifierProvider<FloatingNotifier, FloatingState>(
  (ref) => FloatingNotifier(),
);
