// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeckImpl _$$DeckImplFromJson(Map<String, dynamic> json) => _$DeckImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => DeckCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      format: json['format'] as String?,
      coverCardId: json['coverCardId'] as String?,
      totalMatches: (json['totalMatches'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DeckImplToJson(_$DeckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'cards': instance.cards,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'format': instance.format,
      'coverCardId': instance.coverCardId,
      'totalMatches': instance.totalMatches,
      'wins': instance.wins,
      'losses': instance.losses,
    };

_$DeckCardImpl _$$DeckCardImplFromJson(Map<String, dynamic> json) =>
    _$DeckCardImpl(
      card: PokemonCard.fromJson(json['card'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$DeckCardImplToJson(_$DeckCardImpl instance) =>
    <String, dynamic>{
      'card': instance.card,
      'quantity': instance.quantity,
    };
