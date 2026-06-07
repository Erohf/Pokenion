import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';
import 'status_condition.dart';

part 'active_pokemon.freezed.dart';
part 'active_pokemon.g.dart';

@freezed
class ActivePokemon with _$ActivePokemon {
  const factory ActivePokemon({
    required PokemonCard card,
    required int currentHp,
    required int maxHp,
    @Default([]) List<EnergyType> attachedEnergies,
    StatusCondition? statusCondition,
    @Default([]) List<PokemonCard> evolutionStack,
    @Default(false) bool hasTurboToken,
  }) = _ActivePokemon;

  factory ActivePokemon.fromJson(Map<String, dynamic> json) => _$ActivePokemonFromJson(json);
}
