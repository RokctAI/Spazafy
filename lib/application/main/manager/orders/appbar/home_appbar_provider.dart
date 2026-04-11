import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/main/manager/orders/appbar/home_appbar_state.dart';
import 'package:rokctapp/application/main/manager/orders/appbar/home_appbar_notifier.dart';

final homeAppbarProvider =
    StateNotifierProvider<HomeAppbarNotifier, HomeAppbarState>(
      (ref) => HomeAppbarNotifier(),
    );
