import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/story/driver/story_notifier.dart';
import 'package:rokctapp/application/story/driver/story_state.dart';

final storyProvider =
    StateNotifierProvider.autoDispose<StoryNotifier, StoryState>(
      (ref) => StoryNotifier(),
    );
