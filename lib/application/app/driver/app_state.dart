import 'package:rokctapp/infrastructure/models/data/driver/language.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
part 'app_state.freezed.dart';



@freezed
abstract class AppState with _$AppState {
  const factory AppState({LanguageData? activeLanguage}) = _AppState;

  const AppState._();
}
