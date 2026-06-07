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
  String get set => throw _privateConstructorUsedError;
  String get number => throw _privateConstructorUsedError;
  CardType get type => throw _privateConstructorUsedError;
  String? get supertype => throw _privateConstructorUsedError;
  List<String>? get subtypes => throw _privateConstructorUsedError;
  int? get hp => throw _privateConstructorUsedError;
  List<String>? get types => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get imageLargeUrl => throw _privateConstructorUsedError;
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
      String set,
      String number,
      CardType type,
      String? supertype,
      List<String>? subtypes,
      int? hp,
      List<String>? types,
      String? imageUrl,
      String? imageLargeUrl,
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
    Object? set = null,
    Object? number = null,
    Object? type = null,
    Object? supertype = freezed,
    Object? subtypes = freezed,
    Object? hp = freezed,
    Object? types = freezed,
    Object? imageUrl = freezed,
    Object? imageLargeUrl = freezed,
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
      set: null == set
          ? _value.set
          : set // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CardType,
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
      String set,
      String number,
      CardType type,
      String? supertype,
      List<String>? subtypes,
      int? hp,
      List<String>? types,
      String? imageUrl,
      String? imageLargeUrl,
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
    Object? set = null,
    Object? number = null,
    Object? type = null,
    Object? supertype = freezed,
    Object? subtypes = freezed,
    Object? hp = freezed,
    Object? types = freezed,
    Object? imageUrl = freezed,
    Object? imageLargeUrl = freezed,
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
      set: null == set
          ? _value.set
          : set // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CardType,
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
      required this.set,
      required this.number,
      required this.type,
      this.supertype,
      final List<String>? subtypes,
      this.hp,
      final List<String>? types,
      this.imageUrl,
      this.imageLargeUrl,
      this.rarity})
      : _subtypes = subtypes,
        _types = types;

  factory _$PokemonCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PokemonCardImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String set;
  @override
  final String number;
  @override
  final CardType type;
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
  @override
  final String? rarity;

  @override
  String toString() {
    return 'PokemonCard(id: $id, name: $name, set: $set, number: $number, type: $type, supertype: $supertype, subtypes: $subtypes, hp: $hp, types: $types, imageUrl: $imageUrl, imageLargeUrl: $imageLargeUrl, rarity: $rarity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PokemonCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.set, set) || other.set == set) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.supertype, supertype) ||
                other.supertype == supertype) &&
            const DeepCollectionEquality().equals(other._subtypes, _subtypes) &&
            (identical(other.hp, hp) || other.hp == hp) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.imageLargeUrl, imageLargeUrl) ||
                other.imageLargeUrl == imageLargeUrl) &&
            (identical(other.rarity, rarity) || other.rarity == rarity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      set,
      number,
      type,
      supertype,
      const DeepCollectionEquality().hash(_subtypes),
      hp,
      const DeepCollectionEquality().hash(_types),
      imageUrl,
      imageLargeUrl,
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
      required final String set,
      required final String number,
      required final CardType type,
      final String? supertype,
      final List<String>? subtypes,
      final int? hp,
      final List<String>? types,
      final String? imageUrl,
      final String? imageLargeUrl,
      final String? rarity}) = _$PokemonCardImpl;

  factory _PokemonCard.fromJson(Map<String, dynamic> json) =
      _$PokemonCardImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get set;
  @override
  String get number;
  @override
  CardType get type;
  @override
  String? get supertype;
  @override
  List<String>? get subtypes;
  @override
  int? get hp;
  @override
  List<String>? get types;
  @override
  String? get imageUrl;
  @override
  String? get imageLargeUrl;
  @override
  String? get rarity;

  /// Create a copy of PokemonCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PokemonCardImplCopyWith<_$PokemonCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
