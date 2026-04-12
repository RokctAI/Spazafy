import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/main_state.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier() : super(const MainState());

  void selectIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void changeScrolling(bool isScrolling) {
    state = state.copyWith(isScrolling: isScrolling);
  }

  bool checkGuest() {
    return LocalStorage.getToken().isEmpty;
  }
}
