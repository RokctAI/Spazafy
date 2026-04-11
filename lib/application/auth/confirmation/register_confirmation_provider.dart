import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/auth/confirmation/register_confirmation_notifier.dart';
import 'package:rokctapp/application/auth/confirmation/register_confirmation_state.dart';

final registerConfirmationProvider =
    StateNotifierProvider.autoDispose<
      RegisterConfirmationNotifier,
      RegisterConfirmationState
    >((ref) => RegisterConfirmationNotifier(authRepository, userRepository));
