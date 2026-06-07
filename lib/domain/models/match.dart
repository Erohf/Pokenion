import 'package:freezed_annotation/freezed_annotation.dart';

part 'match.freezed.dart';
part 'match.g.dart';

enum MatchResult { win, loss, draw }

enum ActionType {
  draw, play, attack, evolve, retreat,
  attachEnergy, useAbility, useTrainer,
  applyStatus, removeStatus, takePrize,
  mulligan, setupBench, endTurn
}

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String deckId,
    required DateTime startTime,
    DateTime? endTime,
    MatchResult? result,
    required List<MatchAction> actions,
    String? opponentDeckName,
    String? notes,
    // Note: MatchLocation is omitted for now as it's not strictly defined
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
class MatchAction with _$MatchAction {
  const factory MatchAction({
    required String id,
    required DateTime timestamp,
    required ActionType type,
    required int turn,
    String? cardId,
    String? description,
    Map<String, dynamic>? metadata,
  }) = _MatchAction;

  factory MatchAction.fromJson(Map<String, dynamic> json) => _$MatchActionFromJson(json);
}
