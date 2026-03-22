import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_card_notifier.dart';
import 'add_card_state.dart';

final addCardProvider = StateNotifierProvider<AddCardNotifier, AddCardState>(
  (ref) => AddCardNotifier(),
);
