// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PokemonCardImpl _$$PokemonCardImplFromJson(Map<String, dynamic> json) =>
    _$PokemonCardImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$CardTypeEnumMap, json['type']),
      dexNumber: (json['dexNumber'] as num?)?.toInt(),
      stage: $enumDecodeNullable(_$PokemonStageEnumMap, json['stage']),
      baseHp: (json['baseHp'] as num?)?.toInt(),
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String?,
      imageLargeUrl: json['imageLargeUrl'] as String?,
      evolvesToIds: (json['evolvesToIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      variant: json['variant'] as String?,
      set: json['set'] as String?,
      number: json['number'] as String?,
      supertype: json['supertype'] as String?,
      subtypes: (json['subtypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hp: (json['hp'] as num?)?.toInt(),
      rarity: json['rarity'] as String?,
    );

Map<String, dynamic> _$$PokemonCardImplToJson(_$PokemonCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$CardTypeEnumMap[instance.type]!,
      'dexNumber': instance.dexNumber,
      'stage': _$PokemonStageEnumMap[instance.stage],
      'baseHp': instance.baseHp,
      'types': instance.types,
      'imageUrl': instance.imageUrl,
      'imageLargeUrl': instance.imageLargeUrl,
      'evolvesToIds': instance.evolvesToIds,
      'variant': instance.variant,
      'set': instance.set,
      'number': instance.number,
      'supertype': instance.supertype,
      'subtypes': instance.subtypes,
      'hp': instance.hp,
      'rarity': instance.rarity,
    };

const _$CardTypeEnumMap = {
  CardType.pokemon: 'pokemon',
  CardType.trainer: 'trainer',
  CardType.energy: 'energy',
};

const _$PokemonStageEnumMap = {
  PokemonStage.basic: 'basic',
  PokemonStage.stage1: 'stage1',
  PokemonStage.stage2: 'stage2',
  PokemonStage.ex: 'ex',
  PokemonStage.mega: 'mega',
  PokemonStage.vAstro: 'vAstro',
};
