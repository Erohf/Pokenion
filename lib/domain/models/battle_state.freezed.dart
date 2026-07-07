// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battle_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BattleState {
  String? get deckId => throw _privateConstructorUsedError;
  bool get inProgress =>
      throw _privateConstructorUsedError; // Null while the player is choosing their starting active Pokémon.
  ActivePokemon? get active => throw _privateConstructorUsedError;
  List<ActivePokemon> get bench => throw _privateConstructorUsedError;

  /// Create a copy of BattleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BattleStateCopyWith<BattleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BattleStateCopyWith<$Res> {
  factory $BattleStateCopyWith(
          BattleState value, $Res Function(BattleState) then) =
      _$BattleStateCopyWithImpl<$Res, BattleState>;
  @useResult
  $Res call(
      {String? deckId,
      bool inProgress,
      ActivePokemon? active,
      List<ActivePokemon> bench});

  $ActivePokemonCopyWith<$Res>? get active;
}

/// @nodoc
class _$BattleStateCopyWithImpl<$Res, $Val extends BattleState>
    implements $BattleStateCopyWith<$Res> {
  _$BattleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BattleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deckId = freezed,
    Object? inProgress = null,
    Object? active = freezed,
    Object? bench = null,
  }) {
    return _then(_value.copyWith(
      deckId: freezed == deckId
          ? _value.deckId
          : deckId // ignore: cast_nullable_to_non_nullable
              as String?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as ActivePokemon?,
      bench: null == bench
          ? _value.bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<ActivePokemon>,
    ) as $Val);
  }

  /// Create a copy of BattleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivePokemonCopyWith<$Res>? get active {
    if (_value.active == null) {
      return null;
    }

    return $ActivePokemonCopyWith<$Res>(_value.active!, (value) {
      return _then(_value.copyWith(active: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BattleStateImplCopyWith<$Res>
    implements $BattleStateCopyWith<$Res> {
  factory _$$BattleStateImplCopyWith(
          _$BattleStateImpl value, $Res Function(_$BattleStateImpl) then) =
      __$$BattleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? deckId,
      bool inProgress,
      ActivePokemon? active,
      List<ActivePokemon> bench});

  @override
  $ActivePokemonCopyWith<$Res>? get active;
}

/// @nodoc
class __$$BattleStateImplCopyWithImpl<$Res>
    extends _$BattleStateCopyWithImpl<$Res, _$BattleStateImpl>
    implements _$$BattleStateImplCopyWith<$Res> {
  __$$BattleStateImplCopyWithImpl(
      _$BattleStateImpl _value, $Res Function(_$BattleStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BattleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deckId = freezed,
    Object? inProgress = null,
    Object? active = freezed,
    Object? bench = null,
  }) {
    return _then(_$BattleStateImpl(
      deckId: freezed == deckId
          ? _value.deckId
          : deckId // ignore: cast_nullable_to_non_nullable
              as String?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as ActivePokemon?,
      bench: null == bench
          ? _value._bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<ActivePokemon>,
    ));
  }
}

/// @nodoc

class _$BattleStateImpl extends _BattleState {
  const _$BattleStateImpl(
      {this.deckId,
      this.inProgress = false,
      this.active,
      final List<ActivePokemon> bench = const <ActivePokemon>[]})
      : _bench = bench,
        super._();

  @override
  final String? deckId;
  @override
  @JsonKey()
  final bool inProgress;
// Null while the player is choosing their starting active Pokémon.
  @override
  final ActivePokemon? active;
  final List<ActivePokemon> _bench;
  @override
  @JsonKey()
  List<ActivePokemon> get bench {
    if (_bench is EqualUnmodifiableListView) return _bench;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bench);
  }

  @override
  String toString() {
    return 'BattleState(deckId: $deckId, inProgress: $inProgress, active: $active, bench: $bench)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattleStateImpl &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress) &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality().equals(other._bench, _bench));
  }

  @override
  int get hashCode => Object.hash(runtimeType, deckId, inProgress, active,
      const DeepCollectionEquality().hash(_bench));

  /// Create a copy of BattleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattleStateImplCopyWith<_$BattleStateImpl> get copyWith =>
      __$$BattleStateImplCopyWithImpl<_$BattleStateImpl>(this, _$identity);
}

abstract class _BattleState extends BattleState {
  const factory _BattleState(
      {final String? deckId,
      final bool inProgress,
      final ActivePokemon? active,
      final List<ActivePokemon> bench}) = _$BattleStateImpl;
  const _BattleState._() : super._();

  @override
  String? get deckId;
  @override
  bool
      get inProgress; // Null while the player is choosing their starting active Pokémon.
  @override
  ActivePokemon? get active;
  @override
  List<ActivePokemon> get bench;

  /// Create a copy of BattleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattleStateImplCopyWith<_$BattleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
