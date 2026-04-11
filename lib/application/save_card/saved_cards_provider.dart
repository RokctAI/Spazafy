import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/save_card/saved_card_notifier.dart';
import 'package:rokctapp/application/save_card/saved_cards_state.dart';
// saved_cards_provider.dart

// Provider for saved cards
final savedCardsProvider =
    StateNotifierProvider<SavedCardsNotifier, SavedCardsState>((ref) {
      return SavedCardsNotifier();
    });
