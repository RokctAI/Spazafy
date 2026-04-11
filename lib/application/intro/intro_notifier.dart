import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/intro/intro_state.dart';

class IntroNotifier extends StateNotifier<IntroState> {
  IntroNotifier() : super(const IntroState());

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
