import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/models/data/driver/language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'app_state.dart';


class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(const AppState()) {
    fetchThemeAndLocale();
  }

  void fetchThemeAndLocale() {
    final lang = LocalStorage.getLanguage();
    state = state.copyWith(activeLanguage: lang);
  }

  void changeLanguage(LanguageData? language) {
    state = state.copyWith(activeLanguage: language);
  }
}
