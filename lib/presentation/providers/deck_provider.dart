import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/deck.dart';
import '../../domain/models/card.dart';

part 'deck_provider.g.dart';

@riverpod
class DeckNotifier extends _$DeckNotifier {
  @override
  FutureOr<List<Deck>> build() async {
    return [
      Deck(
        id: '1',
        name: 'Charizard ex Turbo',
        description: 'Meta deck focus on high damage and speed.',
        cards: [],
        createdAt: DateTime.now(),
        format: 'Standard',
      ),
      Deck(
        id: '2',
        name: 'Gardevoir ex Psychic',
        description: 'Energy acceleration and control.',
        cards: [],
        createdAt: DateTime.now(),
        format: 'Standard',
      ),
    ];
  }

  Future<void> addDeck(String name) async {
    final current = state.value ?? [];
    final newDeck = Deck(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: '',
      cards: [],
      createdAt: DateTime.now(),
      format: 'Standard',
    );
    state = AsyncValue.data([...current, newDeck]);
  }

  Future<void> renameDeck(String id, String newName) async {
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.map((d) => d.id == id ? d.copyWith(name: newName) : d).toList(),
    );
  }

  Future<void> removeDeck(String id) async {
    final current = state.value ?? [];
    state = AsyncValue.data(current.where((d) => d.id != id).toList());
  }

  Future<void> addCardToDeck(String deckId, PokemonCard card) async {
    final current = state.value ?? [];
    state = AsyncValue.data(current.map((d) {
      if (d.id != deckId) return d;
      // Check if already in deck, increment quantity
      final existingIndex = d.cards.indexWhere((dc) => dc.card.id == card.id);
      if (existingIndex >= 0) {
        final updated = List<DeckCard>.from(d.cards);
        updated[existingIndex] = DeckCard(
          card: card,
          quantity: updated[existingIndex].quantity + 1,
        );
        return d.copyWith(cards: updated);
      }
      return d.copyWith(cards: [...d.cards, DeckCard(card: card, quantity: 1)]);
    }).toList());
  }
}
