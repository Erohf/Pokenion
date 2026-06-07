import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/player_state.dart';
import '../../domain/models/active_pokemon.dart';
import '../../domain/models/card.dart';
import '../../domain/models/status_condition.dart';

part 'battle_provider.g.dart';

@riverpod
class Battle extends _$Battle {
  @override
  PlayerState build() {
    const dummyCard = PokemonCard(
      id: 'dummy',
      name: 'Charizard ex',
      set: 'Obsidian Flames',
      number: '125',
      type: CardType.pokemon,
      hp: 330,
    );

    return PlayerState(
      playerId: 'player',
      activePokemon: ActivePokemon(
        card: dummyCard,
        currentHp: 330,
        maxHp: 330,
        attachedEnergies: [EnergyType.fire, EnergyType.fire],
      ),
      bench: [],
      handCount: 7,
      deckCount: 47,
      prizeCardsCount: 6,
    );
  }

  void updateHp(int newHp) {
    if (state.activePokemon == null) return;
    state = state.copyWith(
      activePokemon: state.activePokemon!.copyWith(currentHp: newHp),
    );
  }

  void toggleStatus(StatusCondition condition) {
    if (state.activePokemon == null) return;
    final current = state.activePokemon!.statusCondition;
    state = state.copyWith(
      activePokemon: state.activePokemon!.copyWith(
        statusCondition: current == condition ? null : condition,
      ),
    );
  }

  void addEnergy(EnergyType type) {
    if (state.activePokemon == null) return;
    final current = List<EnergyType>.from(state.activePokemon!.attachedEnergies);
    current.add(type);
    state = state.copyWith(
      activePokemon: state.activePokemon!.copyWith(attachedEnergies: current),
    );
  }

  void removeEnergy(EnergyType type) {
    if (state.activePokemon == null) return;
    final current = List<EnergyType>.from(state.activePokemon!.attachedEnergies);
    current.remove(type);
    state = state.copyWith(
      activePokemon: state.activePokemon!.copyWith(attachedEnergies: current),
    );
  }

  void setActivePokemon(PokemonCard card) {
    state = state.copyWith(
      activePokemon: ActivePokemon(
        card: card,
        currentHp: card.hp ?? 0,
        maxHp: card.hp ?? 0,
      ),
    );
  }

  void addToBench(PokemonCard card) {
    if (state.bench.length >= 5) return;
    final newBench = List<ActivePokemon>.from(state.bench);
    newBench.add(ActivePokemon(
      card: card,
      currentHp: card.hp ?? 0,
      maxHp: card.hp ?? 0,
    ));
    state = state.copyWith(bench: newBench);
  }
}
