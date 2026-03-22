import 'package:rokctapp/dummy_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'saved_card_notifier.dart';
import 'saved_cards_state.dart';
// saved_cards_provider.dart

// Provider for saved cards
final savedCardsProvider =
    StateNotifierProvider<SavedCardsNotifier, SavedCardsState>((ref) {
      return SavedCardsNotifier();
    });
