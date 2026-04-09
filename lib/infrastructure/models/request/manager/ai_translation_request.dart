import 'package:rokctapp/infrastructure/services/constants/manager/enums.dart';
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/infrastructure/models/data/language_data.dart';
import 'package:rokctapp/app_constants.dart';

class AiTranslationRequest {
  final AiTranslationModel model;
  final int? modelId;
  final LanguageData? lang;
  final String? content;

  AiTranslationRequest({
    required this.model,
    required this.modelId,
    required this.lang,
    this.content,
  });

  Map<String, Object?> toJson() {
    return {
      'model_type': model.type,
      if (modelId != null) 'model_id': modelId,
      'content': content,
      'lang': lang?.locale,
      'api_key': AppConstants.groqApiKey,
    };
  }
}
