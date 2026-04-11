import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/select/select_state.dart';

class SelectNotifier extends StateNotifier<SelectState> {
  SelectNotifier() : super(const SelectState());

  void selectIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
