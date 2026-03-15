import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:venderfoodyman/domain/di/customer/dependency_manager.dart';

import 'search_notifier.dart';
import 'search_state.dart';

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(shopsRepository, productsRepository),
);



