// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) {
  return _PlayerState.fromJson(json);
}

/// @nodoc
mixin _$PlayerState {
  String get playerId => throw _privateConstructorUsedError;
  List<ActivePokemon> get bench => throw _privateConstructorUsedError;
  ActivePokemon? get activePokemon => throw _privateConstructorUsedError;
  int get handCount => throw _privateConstructorUsedError;
  int get deckCount => throw _privateConstructorUsedError;
  int get discardCount => throw _privateConstructorUsedError;
  int get prizeCardsCount => throw _privateConstructorUsedError;
  List<EnergyType> get attachedEnergies => throw _privateConstructorUsedError;
  int get lostZoneCount => throw _privateConstructorUsedError;

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStateCopyWith<PlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
          PlayerState value, $Res Function(PlayerState) then) =
      _$PlayerStateCopyWithImpl<$Res, PlayerState>;
  @useResult
  $Res call(
      {String playerId,
      List<ActivePokemon> bench,
      ActivePokemon? activePokemon,
      int handCount,
      int deckCount,
      int discardCount,
      int prizeCardsCount,
      List<EnergyType> attachedEnergies,
      int lostZoneCount});

  $ActivePokemonCopyWith<$Res>? get activePokemon;
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res, $Val extends PlayerState>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? bench = null,
    Object? activePokemon = freezed,
    Object? handCount = null,
    Object? deckCount = null,
    Object? discardCount = null,
    Object? prizeCardsCount = null,
    Object? attachedEnergies = null,
    Object? lostZoneCount = null,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      bench: null == bench
          ? _value.bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<ActivePokemon>,
      activePokemon: freezed == activePokemon
          ? _value.activePokemon
          : activePokemon // ignore: cast_nullable_to_non_nullable
              as ActivePokemon?,
      handCount: null == handCount
          ? _value.handCount
          : handCount // ignore: cast_nullable_to_non_nullable
              as int,
      deckCount: null == deckCount
          ? _value.deckCount
          : deckCount // ignore: cast_nullable_to_non_nullable
              as int,
      discardCount: null == discardCount
          ? _value.discardCount
          : discardCount // ignore: cast_nullable_to_non_nullable
              as int,
      prizeCardsCount: null == prizeCardsCount
          ? _value.prizeCardsCount
          : prizeCardsCount // ignore: cast_nullable_to_non_nullable
              as int,
      attachedEnergies: null == attachedEnergies
          ? _value.attachedEnergies
          : attachedEnergies // ignore: cast_nullable_to_non_nullable
              as List<EnergyType>,
      lostZoneCount: null == lostZoneCount
          ? _value.lostZoneCount
          : lostZoneCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivePokemonCopyWith<$Res>? get activePokemon {
    if (_value.activePokemon == null) {
      return null;
    }

    return $ActivePokemonCopyWith<$Res>(_value.activePokemon!, (value) {
      return _then(_value.copyWith(activePokemon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerStateImplCopyWith<$Res>
    implements $PlayerStateCopyWith<$Res> {
  factory _$$PlayerStateImplCopyWith(
          _$PlayerStateImpl value, $Res Function(_$PlayerStateImpl) then) =
      __$$PlayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String playerId,
      List<ActivePokemon> bench,
      ActivePokemon? activePokemon,
      int handCount,
      int deckCount,
      int discardCount,
      int prizeCardsCount,
      List<EnergyType> attachedEnergies,
      int lostZoneCount});

  @override
  $ActivePokemonCopyWith<$Res>? get activePokemon;
}

/// @nodoc
class __$$PlayerStateImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerStateImpl>
    implements _$$PlayerStateImplCopyWith<$Res> {
  __$$PlayerStateImplCopyWithImpl(
      _$PlayerStateImpl _value, $Res Function(_$PlayerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? bench = null,
    Object? activePokemon = freezed,
    Object? handCount = null,
    Object? deckCount = null,
    Object? discardCount = null,
    Object? prizeCardsCount = null,
    Object? attachedEnergies = null,
    Object? lostZoneCount = null,
  }) {
    return _then(_$PlayerStateImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      bench: null == bench
          ? _value._bench
          : bench // ignore: cast_nullable_to_non_nullable
              as List<ActivePokemon>,
      activePokemon: freezed == activePokemon
          ? _value.activePokemon
          : activePokemon // ignore: cast_nullable_to_non_nullable
              as ActivePokemon?,
      handCount: null == handCount
          ? _value.handCount
          : handCount // ignore: cast_nullable_to_non_nullable
              as int,
      deckCount: null == deckCount
          ? _value.deckCount
          : deckCount // ignore: cast_nullable_to_non_nullable
              as int,
      discardCount: null == discardCount
          ? _value.discardCount
          : discardCount // ignore: cast_nullable_to_non_nullable
              as int,
      prizeCardsCount: null == prizeCardsCount
          ? _value.prizeCardsCount
          : prizeCardsCount // ignore: cast_nullable_to_non_nullable
              as int,
      attachedEnergies: null == attachedEnergies
          ? _value._attachedEnergies
          : attachedEnergies // ignore: cast_nullable_to_non_nullable
              as List<EnergyType>,
      lostZoneCount: null == lostZoneCount
          ? _value.lostZoneCount
          : lostZoneCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStateImpl implements _PlayerState {
  const _$PlayerStateImpl(
      {required this.playerId,
      final List<ActivePokemon> bench = const [],
      this.activePokemon,
      this.handCount = 0,
      this.deckCount = 60,
      this.discardCount = 0,
      this.prizeCardsCount = 6,
      final List<EnergyType> attachedEnergies = const [],
      this.lostZoneCount = 0})
      : _bench = bench,
        _attachedEnergies = attachedEnergies;

  factory _$PlayerStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStateImplFromJson(json);

  @override
  final String playerId;
  final List<ActivePokemon> _bench;
  @override
  @JsonKey()
  List<ActivePokemon> get bench {
    if (_bench is EqualUnmodifiableListView) return _bench;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bench);
  }

  @override
  final ActivePokemon? activePokemon;
  @override
  @JsonKey()
  final int handCount;
  @override
  @JsonKey()
  final int deckCount;
  @override
  @JsonKey()
  final int discardCount;
  @override
  @JsonKey()
  final int prizeCardsCount;
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
  @JsonKey()
  final int lostZoneCount;

  @override
  String toString() {
    return 'PlayerState(playerId: $playerId, bench: $bench, activePokemon: $activePokemon, handCount: $handCount, deckCount: $deckCount, discardCount: $discardCount, prizeCardsCount: $prizeCardsCount, attachedEnergies: $attachedEnergies, lostZoneCount: $lostZoneCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStateImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(other._bench, _bench) &&
            (identical(other.activePokemon, activePokemon) ||
                other.activePokemon == activePokemon) &&
            (identical(other.handCount, handCount) ||
                other.handCount == handCount) &&
            (identical(other.deckCount, deckCount) ||
                other.deckCount == deckCount) &&
            (identical(other.discardCount, discardCount) ||
                other.discardCount == discardCount) &&
            (identical(other.prizeCardsCount, prizeCardsCount) ||
                other.prizeCardsCount == prizeCardsCount) &&
            const DeepCollectionEquality()
                .equals(other._attachedEnergies, _attachedEnergies) &&
            (identical(other.lostZoneCount, lostZoneCount) ||
                other.lostZoneCount == lostZoneCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      playerId,
      const DeepCollectionEquality().hash(_bench),
      activePokemon,
      handCount,
      deckCount,
      discardCount,
      prizeCardsCount,
      const DeepCollectionEquality().hash(_attachedEnergies),
      lostZoneCount);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      __$$PlayerStateImplCopyWithImpl<_$PlayerStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStateImplToJson(
      this,
    );
  }
}

abstract class _PlayerState implements PlayerState {
  const factory _PlayerState(
      {required final String playerId,
      final List<ActivePokemon> bench,
      final ActivePokemon? activePokemon,
      final int handCount,
      final int deckCount,
      final int discardCount,
      final int prizeCardsCount,
      final List<EnergyType> attachedEnergies,
      final int lostZoneCount}) = _$PlayerStateImpl;

  factory _PlayerState.fromJson(Map<String, dynamic> json) =
      _$PlayerStateImpl.fromJson;

  @override
  String get playerId;
  @override
  List<ActivePokemon> get bench;
  @override
  ActivePokemon? get activePokemon;
  @override
  int get handCount;
  @override
  int get deckCount;
  @override
  int get discardCount;
  @override
  int get prizeCardsCount;
  @override
  List<EnergyType> get attachedEnergies;
  @override
  int get lostZoneCount;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
