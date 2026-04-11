import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/home/driver/home_notifier.dart';
import 'package:rokctapp/application/home/driver/home_state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
