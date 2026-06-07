// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deck.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Deck _$DeckFromJson(Map<String, dynamic> json) {
  return _Deck.fromJson(json);
}

/// @nodoc
mixin _$Deck {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<DeckCard> get cards => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get format => throw _privateConstructorUsedError;
  String? get coverCardId => throw _privateConstructorUsedError;
  int get totalMatches => throw _privateConstructorUsedError;
  int get wins => throw _privateConstructorUsedError;
  int get losses => throw _privateConstructorUsedError;

  /// Serializes this Deck to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Deck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeckCopyWith<Deck> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeckCopyWith<$Res> {
  factory $DeckCopyWith(Deck value, $Res Function(Deck) then) =
      _$DeckCopyWithImpl<$Res, Deck>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      List<DeckCard> cards,
      DateTime createdAt,
      DateTime? updatedAt,
      String? format,
      String? coverCardId,
      int totalMatches,
      int wins,
      int losses});
}

/// @nodoc
class _$DeckCopyWithImpl<$Res, $Val extends Deck>
    implements $DeckCopyWith<$Res> {
  _$DeckCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Deck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? cards = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? format = freezed,
    Object? coverCardId = freezed,
    Object? totalMatches = null,
    Object? wins = null,
    Object? losses = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<DeckCard>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      coverCardId: freezed == coverCardId
          ? _value.coverCardId
          : coverCardId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalMatches: null == totalMatches
          ? _value.totalMatches
          : totalMatches // ignore: cast_nullable_to_non_nullable
              as int,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeckImplCopyWith<$Res> implements $DeckCopyWith<$Res> {
  factory _$$DeckImplCopyWith(
          _$DeckImpl value, $Res Function(_$DeckImpl) then) =
      __$$DeckImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      List<DeckCard> cards,
      DateTime createdAt,
      DateTime? updatedAt,
      String? format,
      String? coverCardId,
      int totalMatches,
      int wins,
      int losses});
}

/// @nodoc
class __$$DeckImplCopyWithImpl<$Res>
    extends _$DeckCopyWithImpl<$Res, _$DeckImpl>
    implements _$$DeckImplCopyWith<$Res> {
  __$$DeckImplCopyWithImpl(_$DeckImpl _value, $Res Function(_$DeckImpl) _then)
      : super(_value, _then);

  /// Create a copy of Deck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? cards = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? format = freezed,
    Object? coverCardId = freezed,
    Object? totalMatches = null,
    Object? wins = null,
    Object? losses = null,
  }) {
    return _then(_$DeckImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      cards: null == cards
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<DeckCard>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      coverCardId: freezed == coverCardId
          ? _value.coverCardId
          : coverCardId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalMatches: null == totalMatches
          ? _value.totalMatches
          : totalMatches // ignore: cast_nullable_to_non_nullable
              as int,
      wins: null == wins
          ? _value.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      losses: null == losses
          ? _value.losses
          : losses // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeckImpl implements _Deck {
  const _$DeckImpl(
      {required this.id,
      required this.name,
      required this.description,
      required final List<DeckCard> cards,
      required this.createdAt,
      this.updatedAt,
      this.format,
      this.coverCardId,
      this.totalMatches = 0,
      this.wins = 0,
      this.losses = 0})
      : _cards = cards;

  factory _$DeckImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeckImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<DeckCard> _cards;
  @override
  List<DeckCard> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? format;
  @override
  final String? coverCardId;
  @override
  @JsonKey()
  final int totalMatches;
  @override
  @JsonKey()
  final int wins;
  @override
  @JsonKey()
  final int losses;

  @override
  String toString() {
    return 'Deck(id: $id, name: $name, description: $description, cards: $cards, createdAt: $createdAt, updatedAt: $updatedAt, format: $format, coverCardId: $coverCardId, totalMatches: $totalMatches, wins: $wins, losses: $losses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeckImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._cards, _cards) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.coverCardId, coverCardId) ||
                other.coverCardId == coverCardId) &&
            (identical(other.totalMatches, totalMatches) ||
                other.totalMatches == totalMatches) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.losses, losses) || other.losses == losses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_cards),
      createdAt,
      updatedAt,
      format,
      coverCardId,
      totalMatches,
      wins,
      losses);

  /// Create a copy of Deck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeckImplCopyWith<_$DeckImpl> get copyWith =>
      __$$DeckImplCopyWithImpl<_$DeckImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeckImplToJson(
      this,
    );
  }
}

abstract class _Deck implements Deck {
  const factory _Deck(
      {required final String id,
      required final String name,
      required final String description,
      required final List<DeckCard> cards,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final String? format,
      final String? coverCardId,
      final int totalMatches,
      final int wins,
      final int losses}) = _$DeckImpl;

  factory _Deck.fromJson(Map<String, dynamic> json) = _$DeckImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<DeckCard> get cards;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get format;
  @override
  String? get coverCardId;
  @override
  int get totalMatches;
  @override
  int get wins;
  @override
  int get losses;

  /// Create a copy of Deck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeckImplCopyWith<_$DeckImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeckCard _$DeckCardFromJson(Map<String, dynamic> json) {
  return _DeckCard.fromJson(json);
}

/// @nodoc
mixin _$DeckCard {
  PokemonCard get card => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this DeckCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeckCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeckCardCopyWith<DeckCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeckCardCopyWith<$Res> {
  factory $DeckCardCopyWith(DeckCard value, $Res Function(DeckCard) then) =
      _$DeckCardCopyWithImpl<$Res, DeckCard>;
  @useResult
  $Res call({PokemonCard card, int quantity});

  $PokemonCardCopyWith<$Res> get card;
}

/// @nodoc
class _$DeckCardCopyWithImpl<$Res, $Val extends DeckCard>
    implements $DeckCardCopyWith<$Res> {
  _$DeckCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeckCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? card = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as PokemonCard,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of DeckCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PokemonCardCopyWith<$Res> get card {
    return $PokemonCardCopyWith<$Res>(_value.card, (value) {
      return _then(_value.copyWith(card: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeckCardImplCopyWith<$Res>
    implements $DeckCardCopyWith<$Res> {
  factory _$$DeckCardImplCopyWith(
          _$DeckCardImpl value, $Res Function(_$DeckCardImpl) then) =
      __$$DeckCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PokemonCard card, int quantity});

  @override
  $PokemonCardCopyWith<$Res> get card;
}

/// @nodoc
class __$$DeckCardImplCopyWithImpl<$Res>
    extends _$DeckCardCopyWithImpl<$Res, _$DeckCardImpl>
    implements _$$DeckCardImplCopyWith<$Res> {
  __$$DeckCardImplCopyWithImpl(
      _$DeckCardImpl _value, $Res Function(_$DeckCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeckCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? card = null,
    Object? quantity = null,
  }) {
    return _then(_$DeckCardImpl(
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as PokemonCard,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeckCardImpl implements _DeckCard {
  const _$DeckCardImpl({required this.card, required this.quantity});

  factory _$DeckCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeckCardImplFromJson(json);

  @override
  final PokemonCard card;
  @override
  final int quantity;

  @override
  String toString() {
    return 'DeckCard(card: $card, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeckCardImpl &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, card, quantity);

  /// Create a copy of DeckCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeckCardImplCopyWith<_$DeckCardImpl> get copyWith =>
      __$$DeckCardImplCopyWithImpl<_$DeckCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeckCardImplToJson(
      this,
    );
  }
}

abstract class _DeckCard implements DeckCard {
  const factory _DeckCard(
      {required final PokemonCard card,
      required final int quantity}) = _$DeckCardImpl;

  factory _DeckCard.fromJson(Map<String, dynamic> json) =
      _$DeckCardImpl.fromJson;

  @override
  PokemonCard get card;
  @override
  int get quantity;

  /// Create a copy of DeckCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeckCardImplCopyWith<_$DeckCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
