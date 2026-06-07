// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_pokemon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivePokemon _$ActivePokemonFromJson(Map<String, dynamic> json) {
  return _ActivePokemon.fromJson(json);
}

/// @nodoc
mixin _$ActivePokemon {
  PokemonCard get card => throw _privateConstructorUsedError;
  int get currentHp => throw _privateConstructorUsedError;
  int get maxHp => throw _privateConstructorUsedError;
  List<EnergyType> get attachedEnergies => throw _privateConstructorUsedError;
  StatusCondition? get statusCondition => throw _privateConstructorUsedError;
  List<PokemonCard> get evolutionStack => throw _privateConstructorUsedError;
  bool get hasTurboToken => throw _privateConstructorUsedError;

  /// Serializes this ActivePokemon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivePokemon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivePokemonCopyWith<ActivePokemon> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivePokemonCopyWith<$Res> {
  factory $ActivePokemonCopyWith(
          ActivePokemon value, $Res Function(ActivePokemon) then) =
      _$ActivePokemonCopyWithImpl<$Res, ActivePokemon>;
  @useResult
  $Res call(
      {PokemonCard card,
      int currentHp,
      int maxHp,
      List<EnergyType> attachedEnergies,
      StatusCondition? statusCondition,
      List<PokemonCard> evolutionStack,
      bool hasTurboToken});

  $PokemonCardCopyWith<$Res> get card;
}

/// @nodoc
class _$ActivePokemonCopyWithImpl<$Res, $Val extends ActivePokemon>
    implements $ActivePokemonCopyWith<$Res> {
  _$ActivePokemonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivePokemon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? card = null,
    Object? currentHp = null,
    Object? maxHp = null,
    Object? attachedEnergies = null,
    Object? statusCondition = freezed,
    Object? evolutionStack = null,
    Object? hasTurboToken = null,
  }) {
    return _then(_value.copyWith(
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as PokemonCard,
      currentHp: null == currentHp
          ? _value.currentHp
          : currentHp // ignore: cast_nullable_to_non_nullable
              as int,
      maxHp: null == maxHp
          ? _value.maxHp
          : maxHp // ignore: cast_nullable_to_non_nullable
              as int,
      attachedEnergies: null == attachedEnergies
          ? _value.attachedEnergies
          : attachedEnergies // ignore: cast_nullable_to_non_nullable
              as List<EnergyType>,
      statusCondition: freezed == statusCondition
          ? _value.statusCondition
          : statusCondition // ignore: cast_nullable_to_non_nullable
              as StatusCondition?,
      evolutionStack: null == evolutionStack
          ? _value.evolutionStack
          : evolutionStack // ignore: cast_nullable_to_non_nullable
              as List<PokemonCard>,
      hasTurboToken: null == hasTurboToken
          ? _value.hasTurboToken
          : hasTurboToken // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ActivePokemon
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
abstract class _$$ActivePokemonImplCopyWith<$Res>
    implements $ActivePokemonCopyWith<$Res> {
  factory _$$ActivePokemonImplCopyWith(
          _$ActivePokemonImpl value, $Res Function(_$ActivePokemonImpl) then) =
      __$$ActivePokemonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PokemonCard card,
      int currentHp,
      int maxHp,
      List<EnergyType> attachedEnergies,
      StatusCondition? statusCondition,
      List<PokemonCard> evolutionStack,
      bool hasTurboToken});

  @override
  $PokemonCardCopyWith<$Res> get card;
}

/// @nodoc
class __$$ActivePokemonImplCopyWithImpl<$Res>
    extends _$ActivePokemonCopyWithImpl<$Res, _$ActivePokemonImpl>
    implements _$$ActivePokemonImplCopyWith<$Res> {
  __$$ActivePokemonImplCopyWithImpl(
      _$ActivePokemonImpl _value, $Res Function(_$ActivePokemonImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivePokemon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? card = null,
    Object? currentHp = null,
    Object? maxHp = null,
    Object? attachedEnergies = null,
    Object? statusCondition = freezed,
    Object? evolutionStack = null,
    Object? hasTurboToken = null,
  }) {
    return _then(_$ActivePokemonImpl(
      card: null == card
          ? _value.card
          : card // ignore: cast_nullable_to_non_nullable
              as PokemonCard,
      currentHp: null == currentHp
          ? _value.currentHp
          : currentHp // ignore: cast_nullable_to_non_nullable
              as int,
      maxHp: null == maxHp
          ? _value.maxHp
          : maxHp // ignore: cast_nullable_to_non_nullable
              as int,
      attachedEnergies: null == attachedEnergies
          ? _value._attachedEnergies
          : attachedEnergies // ignore: cast_nullable_to_non_nullable
              as List<EnergyType>,
      statusCondition: freezed == statusCondition
          ? _value.statusCondition
          : statusCondition // ignore: cast_nullable_to_non_nullable
              as StatusCondition?,
      evolutionStack: null == evolutionStack
          ? _value._evolutionStack
          : evolutionStack // ignore: cast_nullable_to_non_nullable
              as List<PokemonCard>,
      hasTurboToken: null == hasTurboToken
          ? _value.hasTurboToken
          : hasTurboToken // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivePokemonImpl implements _ActivePokemon {
  const _$ActivePokemonImpl(
      {required this.card,
      required this.currentHp,
      required this.maxHp,
      final List<EnergyType> attachedEnergies = const [],
      this.statusCondition,
      final List<PokemonCard> evolutionStack = const [],
      this.hasTurboToken = false})
      : _attachedEnergies = attachedEnergies,
        _evolutionStack = evolutionStack;

  factory _$ActivePokemonImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivePokemonImplFromJson(json);

  @override
  final PokemonCard card;
  @override
  final int currentHp;
  @override
  final int maxHp;
  final List<EnergyType> _attachedEnergies;
  @override
  @JsonKey()
  List<EnergyType> get attachedEnergies {
    if (_attachedEnergies is EqualUnmodifiableListView)
      return _attachedEnergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachedEnergies);
  }

  @override
  final StatusCondition? statusCondition;
  final List<PokemonCard> _evolutionStack;
  @override
  @JsonKey()
  List<PokemonCard> get evolutionStack {
    if (_evolutionStack is EqualUnmodifiableListView) return _evolutionStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evolutionStack);
  }

  @override
  @JsonKey()
  final bool hasTurboToken;

  @override
  String toString() {
    return 'ActivePokemon(card: $card, currentHp: $currentHp, maxHp: $maxHp, attachedEnergies: $attachedEnergies, statusCondition: $statusCondition, evolutionStack: $evolutionStack, hasTurboToken: $hasTurboToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivePokemonImpl &&
            (identical(other.card, card) || other.card == card) &&
            (identical(other.currentHp, currentHp) ||
                other.currentHp == currentHp) &&
            (identical(other.maxHp, maxHp) || other.maxHp == maxHp) &&
            const DeepCollectionEquality()
                .equals(other._attachedEnergies, _attachedEnergies) &&
            (identical(other.statusCondition, statusCondition) ||
                other.statusCondition == statusCondition) &&
            const DeepCollectionEquality()
                .equals(other._evolutionStack, _evolutionStack) &&
            (identical(other.hasTurboToken, hasTurboToken) ||
                other.hasTurboToken == hasTurboToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      card,
      currentHp,
      maxHp,
      const DeepCollectionEquality().hash(_attachedEnergies),
      statusCondition,
      const DeepCollectionEquality().hash(_evolutionStack),
      hasTurboToken);

  /// Create a copy of ActivePokemon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivePokemonImplCopyWith<_$ActivePokemonImpl> get copyWith =>
      __$$ActivePokemonImplCopyWithImpl<_$ActivePokemonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivePokemonImplToJson(
      this,
    );
  }
}

abstract class _ActivePokemon implements ActivePokemon {
  const factory _ActivePokemon(
      {required final PokemonCard card,
      required final int currentHp,
      required final int maxHp,
      final List<EnergyType> attachedEnergies,
      final StatusCondition? statusCondition,
      final List<PokemonCard> evolutionStack,
      final bool hasTurboToken}) = _$ActivePokemonImpl;

  factory _ActivePokemon.fromJson(Map<String, dynamic> json) =
      _$ActivePokemonImpl.fromJson;

  @override
  PokemonCard get card;
  @override
  int get currentHp;
  @override
  int get maxHp;
  @override
  List<EnergyType> get attachedEnergies;
  @override
  StatusCondition? get statusCondition;
  @override
  List<PokemonCard> get evolutionStack;
  @override
  bool get hasTurboToken;

  /// Create a copy of ActivePokemon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivePokemonImplCopyWith<_$ActivePokemonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
