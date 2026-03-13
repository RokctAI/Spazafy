import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pin_auth_notifier.dart';
import 'pin_auth_state.dart';

final pinAuthProvider = StateNotifierProvider<PinAuthNotifier, PinAuthState>(
  (ref) => PinAuthNotifier(),
);
