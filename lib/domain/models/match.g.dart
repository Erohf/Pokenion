// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      result: $enumDecodeNullable(_$MatchResultEnumMap, json['result']),
      actions: (json['actions'] as List<dynamic>)
          .map((e) => MatchAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      opponentDeckName: json['opponentDeckName'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deckId': instance.deckId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'result': _$MatchResultEnumMap[instance.result],
      'actions': instance.actions,
      'opponentDeckName': instance.opponentDeckName,
      'notes': instance.notes,
    };

const _$MatchResultEnumMap = {
  MatchResult.win: 'win',
  MatchResult.loss: 'loss',
  MatchResult.draw: 'draw',
};

_$MatchActionImpl _$$MatchActionImplFromJson(Map<String, dynamic> json) =>
    _$MatchActionImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActionTypeEnumMap, json['type']),
      turn: (json['turn'] as num).toInt(),
      cardId: json['cardId'] as String?,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MatchActionImplToJson(_$MatchActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActionTypeEnumMap[instance.type]!,
      'turn': instance.turn,
      'cardId': instance.cardId,
      'description': instance.description,
      'metadata': instance.metadata,
    };

const _$ActionTypeEnumMap = {
  ActionType.draw: 'draw',
  ActionType.play: 'play',
  ActionType.attack: 'attack',
  ActionType.evolve: 'evolve',
  ActionType.retreat: 'retreat',
  ActionType.attachEnergy: 'attachEnergy',
  ActionType.useAbility: 'useAbility',
  ActionType.useTrainer: 'useTrainer',
  ActionType.applyStatus: 'applyStatus',
  ActionType.removeStatus: 'removeStatus',
  ActionType.takePrize: 'takePrize',
  ActionType.mulligan: 'mulligan',
  ActionType.setupBench: 'setupBench',
  ActionType.endTurn: 'endTurn',
};
