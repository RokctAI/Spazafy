import '../data/language_data.dart';

enum AiTranslationModel {
  product('products'),
  category('categories'),
  shop('shops'),
  brand('brands'),
  extraGroup('extra_groups'),
  extraValue('extra_values');

  final String type;
  const AiTranslationModel(this.type);
}

class AiTranslationRequest {
  final AiTranslationModel model;
  final String? modelId;
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
    };
  }
}
