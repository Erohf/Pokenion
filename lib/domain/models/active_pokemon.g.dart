// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivePokemonImpl _$$ActivePokemonImplFromJson(Map<String, dynamic> json) =>
    _$ActivePokemonImpl(
      card: PokemonCard.fromJson(json['card'] as Map<String, dynamic>),
      currentHp: (json['currentHp'] as num).toInt(),
      maxHp: (json['maxHp'] as num).toInt(),
      attachedEnergies: (json['attachedEnergies'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$EnergyTypeEnumMap, e))
              .toList() ??
          const [],
      statuses: (json['statuses'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StatusConditionEnumMap, e))
              .toSet() ??
          const <StatusCondition>{},
      evolutionStack: (json['evolutionStack'] as List<dynamic>?)
              ?.map((e) => PokemonCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasTurboToken: json['hasTurboToken'] as bool? ?? false,
    );

Map<String, dynamic> _$$ActivePokemonImplToJson(_$ActivePokemonImpl instance) =>
    <String, dynamic>{
      'card': instance.card.toJson(),
      'currentHp': instance.currentHp,
      'maxHp': instance.maxHp,
      'attachedEnergies': instance.attachedEnergies
          .map((e) => _$EnergyTypeEnumMap[e]!)
          .toList(),
      'statuses':
          instance.statuses.map((e) => _$StatusConditionEnumMap[e]!).toList(),
      'evolutionStack': instance.evolutionStack.map((e) => e.toJson()).toList(),
      'hasTurboToken': instance.hasTurboToken,
    };

const _$EnergyTypeEnumMap = {
  EnergyType.fire: 'fire',
  EnergyType.water: 'water',
  EnergyType.grass: 'grass',
  EnergyType.lightning: 'lightning',
  EnergyType.psychic: 'psychic',
  EnergyType.fighting: 'fighting',
  EnergyType.darkness: 'darkness',
  EnergyType.metal: 'metal',
  EnergyType.fairy: 'fairy',
  EnergyType.dragon: 'dragon',
  EnergyType.colorless: 'colorless',
};

const _$StatusConditionEnumMap = {
  StatusCondition.asleep: 'asleep',
  StatusCondition.burned: 'burned',
  StatusCondition.confused: 'confused',
  StatusCondition.paralyzed: 'paralyzed',
  StatusCondition.poisoned: 'poisoned',
};
