import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/ai_translation/manager/ai_translation_notifier.dart';
import 'package:rokctapp/application/ai_translation/manager/ai_translation_state.dart';

final aiTranslationProvider =
    StateNotifierProvider.autoDispose<
      AiTranslationNotifier,
      AiTranslationState
    >((ref) => AiTranslationNotifier());
