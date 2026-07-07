/// Status conditions a Pokémon can have during a battle.
///
/// Business rules (Pokémon TCG, per app spec):
/// - [confused], [paralyzed] and [asleep] are the "special" conditions: only one
///   of them can be active at a time. Applying a new one replaces the current.
/// - [burned] and [poisoned] stack with the special condition and with each
///   other, but never with themselves (no double burn / triple poison).
enum StatusCondition {
  asleep,
  burned,
  confused,
  paralyzed,
  poisoned;

  /// The mutually-exclusive "special" conditions.
  bool get isSpecial =>
      this == confused || this == paralyzed || this == asleep;
}

/// Applies [incoming] to an existing [current] set following the stacking rules.
Set<StatusCondition> applyStatus(
  Set<StatusCondition> current,
  StatusCondition incoming,
) {
  final next = {...current};
  if (incoming.isSpecial) {
    // Remove any other special condition first; specials don't accumulate.
    next.removeWhere((s) => s.isSpecial);
  }
  next.add(incoming); // Set semantics prevent doubling the same condition.
  return next;
}

enum EnergyType {
  fire, water, grass, lightning, psychic,
  fighting, darkness, metal, fairy, dragon,
  colorless
}
