import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/app_constants.dart';
import 'main_state.dart';

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier() : super(const MainState());

  void selectIndex(int index) {
    state = state.copyWith(selectIndex: index);
  }

  void resetToInitialPage() {
    state = state.copyWith(selectIndex: 0);
  }

  bool checkGuest() {
    return LocalStorage.getToken().isEmpty;
  }

  void changeScrolling(bool isScrolling) {
    if (!AppConstants.fixed) {
      state = state.copyWith(isScrolling: isScrolling);
    } else {
      state = state.copyWith(isScrolling: false);
    }
  }
}
