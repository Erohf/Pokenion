// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PokemonCard _$PokemonCardFromJson(Map<String, dynamic> json) {
  return _PokemonCard.fromJson(json);
}

/// @nodoc
mixin _$PokemonCard {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CardType get type => throw _privateConstructorUsedError;
  int? get dexNumber => throw _privateConstructorUsedError;
  PokemonStage? get stage =>
      throw _privateConstructorUsedError; // Canonical HP used as the default LIFE suggestion when adding to a deck.
  int? get baseHp => throw _privateConstructorUsedError;
  List<String>? get types => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get imageLargeUrl =>
      throw _privateConstructorUsedError; // Ids of cards this Pokémon can evolve into (next stages / mega).
  List<String> get evolvesToIds =>
      throw _privateConstructorUsedError; // Optional descriptor for variants (e.g. "Mega", "EX", "V Astro").
  String? get variant =>
      throw _privateConstructorUsedError; // Legacy / TCG-import fields (kept for compatibility).
  String? get set => throw _privateConstructorUsedError;
  String? get number => throw _privateConstructorUsedError;
  String? get supertype => throw _privateConstructorUsedError;
  List<String>? get subtypes => throw _privateConstructorUsedError;
  int? get hp => throw _privateConstructorUsedError;
  String? get rarity => throw _privateConstructorUsedError;

  /// Serializes this PokemonCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PokemonCardCopyWith<PokemonCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PokemonCardCopyWith<$Res> {
  factory $PokemonCardCopyWith(
          PokemonCard value, $Res Function(PokemonCard) then) =
      _$PokemonCardCopyWithImpl<$Res, PokemonCard>;
  @useResult
  $Res call(
      {String id,
      String name,
      CardType type,
      int? dexNumber,
      PokemonStage? stage,
      int? baseHp,
      List<String>? types,
      String? imageUrl,
      String? imageLargeUrl,
      List<String> evolvesToIds,
      String? variant,
      String? set,
      String? number,
      String? supertype,
      List<String>? subtypes,
      int? hp,
      String? rarity});
}

/// @nodoc
class _$PokemonCardCopyWithImpl<$Res, $Val extends PokemonCard>
    implements $PokemonCardCopyWith<$Res> {
  _$PokemonCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? dexNumber = freezed,
    Object? stage = freezed,
    Object? baseHp = freezed,
    Object? types = freezed,
    Object? imageUrl = freezed,
    Object? imageLargeUrl = freezed,
    Object? evolvesToIds = null,
    Object? variant = freezed,
    Object? set = freezed,
    Object? number = freezed,
    Object? supertype = freezed,
    Object? subtypes = freezed,
    Object? hp = freezed,
    Object? rarity = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CardType,
      dexNumber: freezed == dexNumber
          ? _value.dexNumber
          : dexNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      stage: freezed == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PokemonStage?,
      baseHp: freezed == baseHp
          ? _value.baseHp
          : baseHp // ignore: cast_nullable_to_non_nullable
              as int?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageLargeUrl: freezed == imageLargeUrl
          ? _value.imageLargeUrl
          : imageLargeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      evolvesToIds: null == evolvesToIds
          ? _value.evolvesToIds
          : evolvesToIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as String?,
      set: freezed == set
          ? _value.set
          : set // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      supertype: freezed == supertype
          ? _value.supertype
          : supertype // ignore: cast_nullable_to_non_nullable
              as String?,
      subtypes: freezed == subtypes
          ? _value.subtypes
          : subtypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hp: freezed == hp
          ? _value.hp
          : hp // ignore: cast_nullable_to_non_nullable
              as int?,
      rarity: freezed == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PokemonCardImplCopyWith<$Res>
    implements $PokemonCardCopyWith<$Res> {
  factory _$$PokemonCardImplCopyWith(
          _$PokemonCardImpl value, $Res Function(_$PokemonCardImpl) then) =
      __$$PokemonCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      CardType type,
      int? dexNumber,
      PokemonStage? stage,
      int? baseHp,
      List<String>? types,
      String? imageUrl,
      String? imageLargeUrl,
      List<String> evolvesToIds,
      String? variant,
      String? set,
      String? number,
      String? supertype,
      List<String>? subtypes,
      int? hp,
      String? rarity});
}

/// @nodoc
class __$$PokemonCardImplCopyWithImpl<$Res>
    extends _$PokemonCardCopyWithImpl<$Res, _$PokemonCardImpl>
    implements _$$PokemonCardImplCopyWith<$Res> {
  __$$PokemonCardImplCopyWithImpl(
      _$PokemonCardImpl _value, $Res Function(_$PokemonCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? dexNumber = freezed,
    Object? stage = freezed,
    Object? baseHp = freezed,
    Object? types = freezed,
    Object? imageUrl = freezed,
    Object? imageLargeUrl = freezed,
    Object? evolvesToIds = null,
    Object? variant = freezed,
    Object? set = freezed,
    Object? number = freezed,
    Object? supertype = freezed,
    Object? subtypes = freezed,
    Object? hp = freezed,
    Object? rarity = freezed,
  }) {
    return _then(_$PokemonCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CardType,
      dexNumber: freezed == dexNumber
          ? _value.dexNumber
          : dexNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      stage: freezed == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as PokemonStage?,
      baseHp: freezed == baseHp
          ? _value.baseHp
          : baseHp // ignore: cast_nullable_to_non_nullable
              as int?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageLargeUrl: freezed == imageLargeUrl
          ? _value.imageLargeUrl
          : imageLargeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      evolvesToIds: null == evolvesToIds
          ? _value._evolvesToIds
          : evolvesToIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      variant: freezed == variant
          ? _value.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as String?,
      set: freezed == set
          ? _value.set
          : set // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      supertype: freezed == supertype
          ? _value.supertype
          : supertype // ignore: cast_nullable_to_non_nullable
              as String?,
      subtypes: freezed == subtypes
          ? _value._subtypes
          : subtypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hp: freezed == hp
          ? _value.hp
          : hp // ignore: cast_nullable_to_non_nullable
              as int?,
      rarity: freezed == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PokemonCardImpl implements _PokemonCard {
  const _$PokemonCardImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.dexNumber,
      this.stage,
      this.baseHp,
      final List<String>? types,
      this.imageUrl,
      this.imageLargeUrl,
      final List<String> evolvesToIds = const [],
      this.variant,
      this.set,
      this.number,
      this.supertype,
      final List<String>? subtypes,
      this.hp,
      this.rarity})
      : _types = types,
        _evolvesToIds = evolvesToIds,
        _subtypes = subtypes;

  factory _$PokemonCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PokemonCardImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final CardType type;
  @override
  final int? dexNumber;
  @override
  final PokemonStage? stage;
// Canonical HP used as the default LIFE suggestion when adding to a deck.
  @override
  final int? baseHp;
  final List<String>? _types;
  @override
  List<String>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? imageUrl;
  @override
  final String? imageLargeUrl;
// Ids of cards this Pokémon can evolve into (next stages / mega).
  final List<String> _evolvesToIds;
// Ids of cards this Pokémon can evolve into (next stages / mega).
  @override
  @JsonKey()
  List<String> get evolvesToIds {
    if (_evolvesToIds is EqualUnmodifiableListView) return _evolvesToIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evolvesToIds);
  }

// Optional descriptor for variants (e.g. "Mega", "EX", "V Astro").
  @override
  final String? variant;
// Legacy / TCG-import fields (kept for compatibility).
  @override
  final String? set;
  @override
  final String? number;
  @override
  final String? supertype;
  final List<String>? _subtypes;
  @override
  List<String>? get subtypes {
    final value = _subtypes;
    if (value == null) return null;
    if (_subtypes is EqualUnmodifiableListView) return _subtypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? hp;
  @override
  final String? rarity;

  @override
  String toString() {
    return 'PokemonCard(id: $id, name: $name, type: $type, dexNumber: $dexNumber, stage: $stage, baseHp: $baseHp, types: $types, imageUrl: $imageUrl, imageLargeUrl: $imageLargeUrl, evolvesToIds: $evolvesToIds, variant: $variant, set: $set, number: $number, supertype: $supertype, subtypes: $subtypes, hp: $hp, rarity: $rarity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PokemonCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.dexNumber, dexNumber) ||
                other.dexNumber == dexNumber) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.baseHp, baseHp) || other.baseHp == baseHp) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.imageLargeUrl, imageLargeUrl) ||
                other.imageLargeUrl == imageLargeUrl) &&
            const DeepCollectionEquality()
                .equals(other._evolvesToIds, _evolvesToIds) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.set, set) || other.set == set) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.supertype, supertype) ||
                other.supertype == supertype) &&
            const DeepCollectionEquality().equals(other._subtypes, _subtypes) &&
            (identical(other.hp, hp) || other.hp == hp) &&
            (identical(other.rarity, rarity) || other.rarity == rarity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      dexNumber,
      stage,
      baseHp,
      const DeepCollectionEquality().hash(_types),
      imageUrl,
      imageLargeUrl,
      const DeepCollectionEquality().hash(_evolvesToIds),
      variant,
      set,
      number,
      supertype,
      const DeepCollectionEquality().hash(_subtypes),
      hp,
      rarity);

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PokemonCardImplCopyWith<_$PokemonCardImpl> get copyWith =>
      __$$PokemonCardImplCopyWithImpl<_$PokemonCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PokemonCardImplToJson(
      this,
    );
  }
}

abstract class _PokemonCard implements PokemonCard {
  const factory _PokemonCard(
      {required final String id,
      required final String name,
      required final CardType type,
      final int? dexNumber,
      final PokemonStage? stage,
      final int? baseHp,
      final List<String>? types,
      final String? imageUrl,
      final String? imageLargeUrl,
      final List<String> evolvesToIds,
      final String? variant,
      final String? set,
      final String? number,
      final String? supertype,
      final List<String>? subtypes,
      final int? hp,
      final String? rarity}) = _$PokemonCardImpl;

  factory _PokemonCard.fromJson(Map<String, dynamic> json) =
      _$PokemonCardImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  CardType get type;
  @override
  int? get dexNumber;
  @override
  PokemonStage?
      get stage; // Canonical HP used as the default LIFE suggestion when adding to a deck.
  @override
  int? get baseHp;
  @override
  List<String>? get types;
  @override
  String? get imageUrl;
  @override
  String?
      get imageLargeUrl; // Ids of cards this Pokémon can evolve into (next stages / mega).
  @override
  List<String>
      get evolvesToIds; // Optional descriptor for variants (e.g. "Mega", "EX", "V Astro").
  @override
  String? get variant; // Legacy / TCG-import fields (kept for compatibility).
  @override
  String? get set;
  @override
  String? get number;
  @override
  String? get supertype;
  @override
  List<String>? get subtypes;
  @override
  int? get hp;
  @override
  String? get rarity;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PokemonCardImplCopyWith<_$PokemonCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
