import 'package:freezed_annotation/freezed_annotation.dart';
import 'active_pokemon.dart';

part 'battle_state.freezed.dart';

/// State of an in-progress battle session. Kept alive while navigating away
/// (to Decks/Profile) so the player never loses progress until they explicitly
/// start a New Game or End Game.
@freezed
class BattleState with _$BattleState {
  const factory BattleState({
    String? deckId,
    @Default(false) bool inProgress,
    // Null while the player is choosing their starting active Pokémon.
    ActivePokemon? active,
    @Default(<ActivePokemon>[]) List<ActivePokemon> bench,
  }) = _BattleState;

  const BattleState._();

  bool get needsActiveSelection => inProgress && active == null;
  bool get benchIsFull => bench.length >= 5;
}
