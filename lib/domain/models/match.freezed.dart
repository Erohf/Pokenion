// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get deckId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  MatchResult? get result => throw _privateConstructorUsedError;
  List<MatchAction> get actions => throw _privateConstructorUsedError;
  String? get opponentDeckName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String id,
      String deckId,
      DateTime startTime,
      DateTime? endTime,
      MatchResult? result,
      List<MatchAction> actions,
      String? opponentDeckName,
      String? notes});
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? result = freezed,
    Object? actions = null,
    Object? opponentDeckName = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deckId: null == deckId
          ? _value.deckId
          : deckId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult?,
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<MatchAction>,
      opponentDeckName: freezed == opponentDeckName
          ? _value.opponentDeckName
          : opponentDeckName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String deckId,
      DateTime startTime,
      DateTime? endTime,
      MatchResult? result,
      List<MatchAction> actions,
      String? opponentDeckName,
      String? notes});
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deckId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? result = freezed,
    Object? actions = null,
    Object? opponentDeckName = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$MatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      deckId: null == deckId
          ? _value.deckId
          : deckId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as MatchResult?,
      actions: null == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<MatchAction>,
      opponentDeckName: freezed == opponentDeckName
          ? _value.opponentDeckName
          : opponentDeckName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl(
      {required this.id,
      required this.deckId,
      required this.startTime,
      this.endTime,
      this.result,
      required final List<MatchAction> actions,
      this.opponentDeckName,
      this.notes})
      : _actions = actions;

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String deckId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final MatchResult? result;
  final List<MatchAction> _actions;
  @override
  List<MatchAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  final String? opponentDeckName;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Match(id: $id, deckId: $deckId, startTime: $startTime, endTime: $endTime, result: $result, actions: $actions, opponentDeckName: $opponentDeckName, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deckId, deckId) || other.deckId == deckId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.opponentDeckName, opponentDeckName) ||
                other.opponentDeckName == opponentDeckName) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      deckId,
      startTime,
      endTime,
      result,
      const DeepCollectionEquality().hash(_actions),
      opponentDeckName,
      notes);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  const factory _Match(
      {required final String id,
      required final String deckId,
      required final DateTime startTime,
      final DateTime? endTime,
      final MatchResult? result,
      required final List<MatchAction> actions,
      final String? opponentDeckName,
      final String? notes}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get deckId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  MatchResult? get result;
  @override
  List<MatchAction> get actions;
  @override
  String? get opponentDeckName;
  @override
  String? get notes;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchAction _$MatchActionFromJson(Map<String, dynamic> json) {
  return _MatchAction.fromJson(json);
}

/// @nodoc
mixin _$MatchAction {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  ActionType get type => throw _privateConstructorUsedError;
  int get turn => throw _privateConstructorUsedError;
  String? get cardId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this MatchAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchActionCopyWith<MatchAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchActionCopyWith<$Res> {
  factory $MatchActionCopyWith(
          MatchAction value, $Res Function(MatchAction) then) =
      _$MatchActionCopyWithImpl<$Res, MatchAction>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      ActionType type,
      int turn,
      String? cardId,
      String? description,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$MatchActionCopyWithImpl<$Res, $Val extends MatchAction>
    implements $MatchActionCopyWith<$Res> {
  _$MatchActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? type = null,
    Object? turn = null,
    Object? cardId = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActionType,
      turn: null == turn
          ? _value.turn
          : turn // ignore: cast_nullable_to_non_nullable
              as int,
      cardId: freezed == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchActionImplCopyWith<$Res>
    implements $MatchActionCopyWith<$Res> {
  factory _$$MatchActionImplCopyWith(
          _$MatchActionImpl value, $Res Function(_$MatchActionImpl) then) =
      __$$MatchActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      ActionType type,
      int turn,
      String? cardId,
      String? description,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$MatchActionImplCopyWithImpl<$Res>
    extends _$MatchActionCopyWithImpl<$Res, _$MatchActionImpl>
    implements _$$MatchActionImplCopyWith<$Res> {
  __$$MatchActionImplCopyWithImpl(
      _$MatchActionImpl _value, $Res Function(_$MatchActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? type = null,
    Object? turn = null,
    Object? cardId = freezed,
    Object? description = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$MatchActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ActionType,
      turn: null == turn
          ? _value.turn
          : turn // ignore: cast_nullable_to_non_nullable
              as int,
      cardId: freezed == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchActionImpl implements _MatchAction {
  const _$MatchActionImpl(
      {required this.id,
      required this.timestamp,
      required this.type,
      required this.turn,
      this.cardId,
      this.description,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$MatchActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchActionImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final ActionType type;
  @override
  final int turn;
  @override
  final String? cardId;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MatchAction(id: $id, timestamp: $timestamp, type: $type, turn: $turn, cardId: $cardId, description: $description, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.turn, turn) || other.turn == turn) &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, timestamp, type, turn,
      cardId, description, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of MatchAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchActionImplCopyWith<_$MatchActionImpl> get copyWith =>
      __$$MatchActionImplCopyWithImpl<_$MatchActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchActionImplToJson(
      this,
    );
  }
}

abstract class _MatchAction implements MatchAction {
  const factory _MatchAction(
      {required final String id,
      required final DateTime timestamp,
      required final ActionType type,
      required final int turn,
      final String? cardId,
      final String? description,
      final Map<String, dynamic>? metadata}) = _$MatchActionImpl;

  factory _MatchAction.fromJson(Map<String, dynamic> json) =
      _$MatchActionImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  ActionType get type;
  @override
  int get turn;
  @override
  String? get cardId;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of MatchAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchActionImplCopyWith<_$MatchActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
