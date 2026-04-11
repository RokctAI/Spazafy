import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/app/driver/app_notifier.dart';
import 'package:rokctapp/application/app/driver/app_state.dart';

final appProvider = StateNotifierProvider<AppNotifier, AppState>(
  (ref) => AppNotifier(),
);
