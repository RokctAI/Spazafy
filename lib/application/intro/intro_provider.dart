import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/intro/intro_notifier.dart';
import 'package:rokctapp/application/intro/intro_state.dart';

final introProvider =
    StateNotifierProvider.autoDispose<IntroNotifier, IntroState>(
      (ref) => IntroNotifier(),
    );
