import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/like/like_notifier.dart';
import 'package:rokctapp/application/like/like_state.dart';

final likeProvider = StateNotifierProvider<LikeNotifier, LikeState>(
  (ref) => LikeNotifier(shopsRepository),
);
