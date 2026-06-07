import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';

part 'deck.freezed.dart';
part 'deck.g.dart';

@freezed
class Deck with _$Deck {
  const factory Deck({
    required String id,
    required String name,
    required String description,
    required List<DeckCard> cards,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? format,
    String? coverCardId,
    @Default(0) int totalMatches,
    @Default(0) int wins,
    @Default(0) int losses,
  }) = _Deck;

  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);
}

@freezed
class DeckCard with _$DeckCard {
  const factory DeckCard({
    required PokemonCard card,
    required int quantity,
  }) = _DeckCard;

  factory DeckCard.fromJson(Map<String, dynamic> json) => _$DeckCardFromJson(json);
}
