import 'package:rokctapp/infrastructure/models/data/language_data.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/interface/settings.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

import 'language_state.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart'
    hide LanguageData;

class LanguageNotifier extends StateNotifier<LanguageState> {
  final SettingsRepositoryFacade _settingsRepository;

  LanguageNotifier(this._settingsRepository) : super(const LanguageState());

  void change(int index) {
    state = state.copyWith(index: index);
    LocalStorage.setLanguageData(state.list[index]);
  }

  Future<void> getLanguages(
    BuildContext context, {
    bool autoSelectIfSingle = false,
  }) async {
    state = state.copyWith(isLoading: true, isSuccess: false);
    final response = await _settingsRepository.getLanguages();
    response.when(
      success: (data) {
        final List<LanguageData> languages = data.data ?? [];
        final lang = LocalStorage.getLanguage();
        int index = 0;

        // If there's only one language and autoSelectIfSingle is true,
        // automatically select it and skip language selection
        if (languages.length == 1 && autoSelectIfSingle) {
          LocalStorage.setLanguageSelected(true);
          LocalStorage.setLanguageData(languages[0]);
          LocalStorage.setLangLtr(languages[0].backward);
          getTranslations(context);
          state = state.copyWith(
            isLoading: false,
            list: languages,
            index: 0,
            isSuccess: true,
            autoSelected: true,
          );
          return;
        }

        // Otherwise, find the index of the current language
        for (int i = 0; i < languages.length; i++) {
          if (languages[i].id == lang?.id) {
            index = i;
            break;
          }
        }

        state = state.copyWith(isLoading: false, list: languages, index: index);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  Future<void> makeSelectedLang(
    BuildContext context, {
    Function(LanguageData)? afterUpdate,
  }) async {
    LocalStorage.setLanguageSelected(true);
    final selectedLang = state.list[state.index];
    LocalStorage.setLanguageData(selectedLang);
    LocalStorage.setLangLtr(selectedLang.backward);
    await getTranslations(context);
    if (afterUpdate != null) {
      afterUpdate(selectedLang);
    }
  }

  Future<void> getTranslations(BuildContext context) async {
    state = state.copyWith(isLoading: true, isSuccess: false);
    final response = await _settingsRepository.getMobileTranslations();
    response.when(
      success: (data) {
        LocalStorage.setTranslations(data.data);
        state = state.copyWith(isLoading: false, isSuccess: true);
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }
}
