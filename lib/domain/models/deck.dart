import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';

part 'deck.freezed.dart';
part 'deck.g.dart';

@freezed
class Deck with _$Deck {
  const factory Deck({
    required String id,
    required String name,
    @Default('') String description,
    @Default([]) List<DeckCard> cards,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default('Standard') String format,
    // Card id used as the deck cover on the Decks screen.
    String? coverCardId,
    @Default(0) int totalMatches,
    @Default(0) int wins,
    @Default(0) int losses,
  }) = _Deck;

  const Deck._();

  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

  List<DeckCard> get pokemonCards =>
      cards.where((c) => c.card.type == CardType.pokemon).toList();

  /// A deck is battle-ready when it has at least one Basic or EX Pokémon.
  bool get isBattleReady => pokemonCards.any((c) => c.card.stage?.canStartInPlay ?? false);
}

@freezed
class DeckCard with _$DeckCard {
  const factory DeckCard({
    required PokemonCard card,
    @Default(1) int quantity,
    // The LIFE chosen by the user for this card when added to the deck.
    int? hp,
  }) = _DeckCard;

  const DeckCard._();

  factory DeckCard.fromJson(Map<String, dynamic> json) =>
      _$DeckCardFromJson(json);

  /// Effective HP: user-chosen value, falling back to the card's base HP.
  int get effectiveHp => hp ?? card.baseHp ?? card.hp ?? 60;
}
