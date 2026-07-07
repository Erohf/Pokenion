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
    // Multiple simultaneous conditions (see status rules in [applyStatus]).
    @Default(<StatusCondition>{}) Set<StatusCondition> statuses,
    // Cards this Pokémon evolved from, oldest first (bottom of the stack).
    @Default([]) List<PokemonCard> evolutionStack,
    @Default(false) bool hasTurboToken,
  }) = _ActivePokemon;

  const ActivePokemon._();

  factory ActivePokemon.fromJson(Map<String, dynamic> json) =>
      _$ActivePokemonFromJson(json);

  /// HP gained (+) or lost (-) relative to this Pokémon's own max HP.
  int get hpDelta => currentHp - maxHp;
}
