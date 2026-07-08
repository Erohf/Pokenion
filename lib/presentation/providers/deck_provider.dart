import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/local_store.dart';
import '../../data/repositories/sync_repository.dart';
import '../../domain/models/deck.dart';
import '../../domain/models/card.dart';
import 'auth_provider.dart';

part 'deck_provider.g.dart';

const _uuid = Uuid();

/// Result of attempting a deck operation that may be blocked by plan limits.
enum DeckOpResult { ok, limitReached }

@Riverpod(keepAlive: true)
class DeckNotifier extends _$DeckNotifier {
  @override
  List<Deck> build() => LocalStore.instance.readDecks();

  Future<void> _save() async {
    await LocalStore.instance.saveAllDecks(state);
    final auth = ref.read(authProvider);
    if (auth.status == AuthStatus.google) {
      await ref.read(syncRepositoryProvider).uploadDecks(state);
    }
  }

  Deck? byId(String id) {
    for (final d in state) {
      if (d.id == id) return d;
    }
    return null;
  }

  /// Create a new empty deck, respecting [maxDecks]. Returns its id, or null
  /// if the plan limit was reached.
  Future<String?> createDeck(String name, {required int maxDecks}) async {
    if (state.length >= maxDecks) return null;
    final deck = Deck(
      id: _uuid.v4(),
      name: name.trim().isEmpty ? 'Novo Deck' : name.trim(),
      createdAt: DateTime.now(),
    );
    state = [...state, deck];
    await _save();
    return deck.id;
  }

  Future<void> renameDeck(String id, String newName) async {
    state = [
      for (final d in state)
        d.id == id ? d.copyWith(name: newName.trim(), updatedAt: DateTime.now()) : d,
    ];
    await _save();
  }

  Future<void> removeDeck(String id) async {
    state = state.where((d) => d.id != id).toList();
    await _save();
    final auth = ref.read(authProvider);
    if (auth.status == AuthStatus.google) {
      await ref.read(syncRepositoryProvider).deleteDeck(id);
    }
  }

  Future<void> updateDeck(Deck deck) async {
    state = [
      for (final d in state) d.id == deck.id ? deck.copyWith(updatedAt: DateTime.now()) : d,
    ];
    await _save();
  }

  // ── Card operations (used by the deck editor) ──────────────────────────

  /// Add [card] with the chosen [hp]. Enforces the 60-card cap.
  Future<void> addCard(String deckId, PokemonCard card, {int? hp}) async {
    final deck = byId(deckId);
    if (deck == null) return;
    final total = deck.cards.fold<int>(0, (s, c) => s + c.quantity);
    if (total >= 60) return;
    final idx = deck.cards.indexWhere((dc) => dc.card.id == card.id);
    List<DeckCard> cards;
    if (idx >= 0) {
      cards = [...deck.cards];
      cards[idx] = cards[idx].copyWith(quantity: cards[idx].quantity + 1);
    } else {
      cards = [...deck.cards, DeckCard(card: card, quantity: 1, hp: hp)];
    }
    await updateDeck(deck.copyWith(cards: cards));
  }

  Future<void> removeCard(String deckId, String cardId) async {
    final deck = byId(deckId);
    if (deck == null) return;
    final cards = deck.cards.where((dc) => dc.card.id != cardId).toList();
    final cover = deck.coverCardId == cardId ? null : deck.coverCardId;
    await updateDeck(deck.copyWith(cards: cards, coverCardId: cover));
  }

  Future<void> setCover(String deckId, String cardId) async {
    final deck = byId(deckId);
    if (deck == null) return;
    await updateDeck(deck.copyWith(coverCardId: cardId));
  }

  void setDecks(List<Deck> decks) {
    state = decks;
  }

  Future<void> clearDecks() async {
    state = [];
    await LocalStore.instance.saveAllDecks([]);
  }
}
