import 'package:rokctapp/infrastructure/models/data/driver/language.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart' hide LanguageData;
import 'package:rokctapp/infrastructure/models/models.dart' hide LanguageData;
part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(false) bool isDarkMode,
    @Default(true) bool isLtr,
    LanguageData? activeLanguage,
  }) = _AppState;

  const AppState._();
}
