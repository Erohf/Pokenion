import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

enum CardType { pokemon, trainer, energy }

@freezed
class PokemonCard with _$PokemonCard {
  const factory PokemonCard({
    required String id,
    required String name,
    required String set,
    required String number,
    required CardType type,
    String? supertype,
    List<String>? subtypes,
    int? hp,
    List<String>? types,
    String? imageUrl,
    String? imageLargeUrl,
    String? rarity,
  }) = _PokemonCard;

  factory PokemonCard.fromJson(Map<String, dynamic> json) => _$PokemonCardFromJson(json);
}
