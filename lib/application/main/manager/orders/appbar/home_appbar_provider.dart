import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_appbar_state.dart';
import 'home_appbar_notifier.dart';


final homeAppbarProvider =
    StateNotifierProvider<HomeAppbarNotifier, HomeAppbarState>(
  (ref) => HomeAppbarNotifier(),
);
