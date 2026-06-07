import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/deck.dart';

part 'deck_provider.g.dart';

@riverpod
class DeckNotifier extends _$DeckNotifier {
  @override
  FutureOr<List<Deck>> build() async {
    // Initializing with empty list or loading from local storage/db
    // For now, returning some mock data if empty to test UI
    return [
      Deck(
        id: '1',
        name: 'Charizard ex Turbo',
        description: 'Meta deck focus on high damage and speed.',
        cards: [],
        createdAt: DateTime.now(),
        format: 'Standard',
        wins: 15,
        losses: 3,
      ),
      Deck(
        id: '2',
        name: 'Gardevoir ex Psychic',
        description: 'Energy acceleration and control.',
        cards: [],
        createdAt: DateTime.now(),
        format: 'Standard',
        wins: 8,
        losses: 7,
      ),
    ];
  }

  Future<void> addDeck(Deck deck) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentDecks = state.value ?? [];
      return [...currentDecks, deck];
    });
  }

  Future<void> removeDeck(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentDecks = state.value ?? [];
      return currentDecks.where((d) => d.id != id).toList();
    });
  }
}
