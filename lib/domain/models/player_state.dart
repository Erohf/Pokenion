import 'package:freezed_annotation/freezed_annotation.dart';
import 'active_pokemon.dart';
import 'status_condition.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
class PlayerState with _$PlayerState {
  const factory PlayerState({
    required String playerId,
    @Default([]) List<ActivePokemon> bench,
    ActivePokemon? activePokemon,
    @Default(0) int handCount,
    @Default(60) int deckCount,
    @Default(0) int discardCount,
    @Default(6) int prizeCardsCount,
    @Default([]) List<EnergyType> attachedEnergies,
    @Default(0) int lostZoneCount,
  }) = _PlayerState;

  factory PlayerState.fromJson(Map<String, dynamic> json) => _$PlayerStateFromJson(json);
}
