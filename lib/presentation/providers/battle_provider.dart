import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/battle_state.dart';
import '../../domain/models/active_pokemon.dart';
import '../../domain/models/card.dart';
import '../../domain/models/status_condition.dart';
import '../../domain/models/deck.dart';

part 'battle_provider.g.dart';

/// Holds the current battle session. `keepAlive` so it survives navigation to
/// other tabs; only [endGame]/[startBattle] reset it.
@Riverpod(keepAlive: true)
class Battle extends _$Battle {
  @override
  BattleState build() => const BattleState();

  ActivePokemon _fromDeckCard(DeckCard dc) => ActivePokemon(
        card: dc.card,
        currentHp: dc.effectiveHp,
        maxHp: dc.effectiveHp,
      );

  /// Begin a new battle for [deck]. The player must then pick a starting active.
  void startBattle(Deck deck) {
    state = BattleState(deckId: deck.id, inProgress: true);
  }

  void chooseActive(DeckCard dc) {
    state = state.copyWith(active: _fromDeckCard(dc));
  }

  // ── HP ─────────────────────────────────────────────────────────────────
  void updateHp(int newHp) {
    final a = state.active;
    if (a == null) return;
    state = state.copyWith(active: a.copyWith(currentHp: newHp.clamp(0, 99999)));
  }

  void addHp(int delta) => updateHp((state.active?.currentHp ?? 0) + delta);

  // ── Status ───────────────────────────────────────────────────────────────
  void toggleStatus(StatusCondition condition) {
    final a = state.active;
    if (a == null) return;
    final next = a.statuses.contains(condition)
        ? (a.statuses.toSet()..remove(condition))
        : applyStatus(a.statuses, condition);
    state = state.copyWith(active: a.copyWith(statuses: next));
  }

  void clearStatus() {
    final a = state.active;
    if (a == null) return;
    state = state.copyWith(active: a.copyWith(statuses: const {}));
  }

  // ── Bench ────────────────────────────────────────────────────────────────
  void addToBench(DeckCard dc) {
    if (state.benchIsFull) return;
    state = state.copyWith(bench: [...state.bench, _fromDeckCard(dc)]);
  }

  /// Replace the bench slot at [index] with a different deck card.
  void replaceBench(int index, DeckCard dc) {
    if (index < 0 || index >= state.bench.length) return;
    final bench = [...state.bench];
    bench[index] = _fromDeckCard(dc);
    state = state.copyWith(bench: bench);
  }

  /// Swap the active Pokémon with the bench Pokémon at [index] (retreat).
  void swapWithBench(int index) {
    final a = state.active;
    if (a == null || index < 0 || index >= state.bench.length) return;
    final bench = [...state.bench];
    final incoming = bench[index];
    bench[index] = a;
    state = state.copyWith(active: incoming, bench: bench);
  }

  // ── Evolve ───────────────────────────────────────────────────────────────
  /// Evolve the active Pokémon to [evolution]. HP balance carries over,
  /// statuses are cleared (per spec).
  void evolve(PokemonCard evolution, int evolutionMaxHp) {
    final a = state.active;
    if (a == null) return;
    final newCurrent = (evolutionMaxHp + a.hpDelta).clamp(0, evolutionMaxHp);
    state = state.copyWith(
      active: a.copyWith(
        card: evolution,
        maxHp: evolutionMaxHp,
        currentHp: newCurrent,
        statuses: const {},
        evolutionStack: [...a.evolutionStack, a.card],
      ),
    );
  }

  /// Evolve the bench Pokémon at [index]. Same rules as [evolve].
  void evolveBench(int index, PokemonCard evolution, int evolutionMaxHp) {
    if (index < 0 || index >= state.bench.length) return;
    final bench = [...state.bench];
    final b = bench[index];
    final newCurrent = (evolutionMaxHp + b.hpDelta).clamp(0, evolutionMaxHp);
    bench[index] = b.copyWith(
      card: evolution,
      maxHp: evolutionMaxHp,
      currentHp: newCurrent,
      statuses: const {},
      evolutionStack: [...b.evolutionStack, b.card],
    );
    state = state.copyWith(bench: bench);
  }

  // ── Defeat ───────────────────────────────────────────────────────────────
  /// Mark the active as defeated and promote bench[index] to active.
  /// The defeated Pokémon is NOT sent to the bench automatically.
  void markDefeated(int benchIndex) {
    if (benchIndex < 0 || benchIndex >= state.bench.length) return;
    final bench = [...state.bench];
    final incoming = bench.removeAt(benchIndex);
    state = state.copyWith(active: incoming, bench: bench);
  }

  // ── Session ──────────────────────────────────────────────────────────────
  void endGame() => state = const BattleState();
}
