import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_notifier.dart';
import 'home_state.dart';


final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);
