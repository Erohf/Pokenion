import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

enum CardType { pokemon, trainer, energy }

/// Evolution stage of a Pokémon card. Drives battle rules:
/// only [basic] and [ex] Pokémon may enter play as the active/bench Pokémon;
/// the others must be reached through [PokemonCard.evolvesToIds].
enum PokemonStage {
  basic,
  stage1,
  stage2,
  ex,
  mega,
  vAstro;

  /// Whether a card at this stage can be played directly (start of battle / bench).
  bool get canStartInPlay => this == basic || this == ex;

  String get label {
    switch (this) {
      case PokemonStage.basic:
        return 'Básico';
      case PokemonStage.stage1:
        return '1ª Fase';
      case PokemonStage.stage2:
        return '2ª Fase';
      case PokemonStage.ex:
        return 'EX';
      case PokemonStage.mega:
        return 'Mega';
      case PokemonStage.vAstro:
        return 'V Astro';
    }
  }
}

@freezed
class PokemonCard with _$PokemonCard {
  const factory PokemonCard({
    required String id,
    required String name,
    required CardType type,
    int? dexNumber,
    PokemonStage? stage,
    // Canonical HP used as the default LIFE suggestion when adding to a deck.
    int? baseHp,
    List<String>? types,
    String? imageUrl,
    String? imageLargeUrl,
    // Ids of cards this Pokémon can evolve into (next stages / mega).
    @Default([]) List<String> evolvesToIds,
    // Optional descriptor for variants (e.g. "Mega", "EX", "V Astro").
    String? variant,
    // Legacy / TCG-import fields (kept for compatibility).
    String? set,
    String? number,
    String? supertype,
    List<String>? subtypes,
    int? hp,
    String? rarity,
  }) = _PokemonCard;

  factory PokemonCard.fromJson(Map<String, dynamic> json) =>
      _$PokemonCardFromJson(json);
}
