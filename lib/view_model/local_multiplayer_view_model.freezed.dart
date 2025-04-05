// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_multiplayer_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalMultiplayerState {
  List<List<int>> get board => throw _privateConstructorUsedError;
  int get currentPlayer => throw _privateConstructorUsedError;
  int get winner => throw _privateConstructorUsedError;
  List<List<int>> get validMoves => throw _privateConstructorUsedError;
  bool get showSkipMessage => throw _privateConstructorUsedError;

  /// Create a copy of LocalMultiplayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalMultiplayerStateCopyWith<LocalMultiplayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalMultiplayerStateCopyWith<$Res> {
  factory $LocalMultiplayerStateCopyWith(LocalMultiplayerState value,
          $Res Function(LocalMultiplayerState) then) =
      _$LocalMultiplayerStateCopyWithImpl<$Res, LocalMultiplayerState>;
  @useResult
  $Res call(
      {List<List<int>> board,
      int currentPlayer,
      int winner,
      List<List<int>> validMoves,
      bool showSkipMessage});
}

/// @nodoc
class _$LocalMultiplayerStateCopyWithImpl<$Res,
        $Val extends LocalMultiplayerState>
    implements $LocalMultiplayerStateCopyWith<$Res> {
  _$LocalMultiplayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalMultiplayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? winner = null,
    Object? validMoves = null,
    Object? showSkipMessage = null,
  }) {
    return _then(_value.copyWith(
      board: null == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      currentPlayer: null == currentPlayer
          ? _value.currentPlayer
          : currentPlayer // ignore: cast_nullable_to_non_nullable
              as int,
      winner: null == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as int,
      validMoves: null == validMoves
          ? _value.validMoves
          : validMoves // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      showSkipMessage: null == showSkipMessage
          ? _value.showSkipMessage
          : showSkipMessage // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalMultiplayerStateImplCopyWith<$Res>
    implements $LocalMultiplayerStateCopyWith<$Res> {
  factory _$$LocalMultiplayerStateImplCopyWith(
          _$LocalMultiplayerStateImpl value,
          $Res Function(_$LocalMultiplayerStateImpl) then) =
      __$$LocalMultiplayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<List<int>> board,
      int currentPlayer,
      int winner,
      List<List<int>> validMoves,
      bool showSkipMessage});
}

/// @nodoc
class __$$LocalMultiplayerStateImplCopyWithImpl<$Res>
    extends _$LocalMultiplayerStateCopyWithImpl<$Res,
        _$LocalMultiplayerStateImpl>
    implements _$$LocalMultiplayerStateImplCopyWith<$Res> {
  __$$LocalMultiplayerStateImplCopyWithImpl(_$LocalMultiplayerStateImpl _value,
      $Res Function(_$LocalMultiplayerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalMultiplayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? winner = null,
    Object? validMoves = null,
    Object? showSkipMessage = null,
  }) {
    return _then(_$LocalMultiplayerStateImpl(
      board: null == board
          ? _value._board
          : board // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      currentPlayer: null == currentPlayer
          ? _value.currentPlayer
          : currentPlayer // ignore: cast_nullable_to_non_nullable
              as int,
      winner: null == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as int,
      validMoves: null == validMoves
          ? _value._validMoves
          : validMoves // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      showSkipMessage: null == showSkipMessage
          ? _value.showSkipMessage
          : showSkipMessage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LocalMultiplayerStateImpl extends _LocalMultiplayerState {
  const _$LocalMultiplayerStateImpl(
      {required final List<List<int>> board,
      required this.currentPlayer,
      required this.winner,
      required final List<List<int>> validMoves,
      this.showSkipMessage = false})
      : _board = board,
        _validMoves = validMoves,
        super._();

  final List<List<int>> _board;
  @override
  List<List<int>> get board {
    if (_board is EqualUnmodifiableListView) return _board;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_board);
  }

  @override
  final int currentPlayer;
  @override
  final int winner;
  final List<List<int>> _validMoves;
  @override
  List<List<int>> get validMoves {
    if (_validMoves is EqualUnmodifiableListView) return _validMoves;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_validMoves);
  }

  @override
  @JsonKey()
  final bool showSkipMessage;

  @override
  String toString() {
    return 'LocalMultiplayerState(board: $board, currentPlayer: $currentPlayer, winner: $winner, validMoves: $validMoves, showSkipMessage: $showSkipMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalMultiplayerStateImpl &&
            const DeepCollectionEquality().equals(other._board, _board) &&
            (identical(other.currentPlayer, currentPlayer) ||
                other.currentPlayer == currentPlayer) &&
            (identical(other.winner, winner) || other.winner == winner) &&
            const DeepCollectionEquality()
                .equals(other._validMoves, _validMoves) &&
            (identical(other.showSkipMessage, showSkipMessage) ||
                other.showSkipMessage == showSkipMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_board),
      currentPlayer,
      winner,
      const DeepCollectionEquality().hash(_validMoves),
      showSkipMessage);

  /// Create a copy of LocalMultiplayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalMultiplayerStateImplCopyWith<_$LocalMultiplayerStateImpl>
      get copyWith => __$$LocalMultiplayerStateImplCopyWithImpl<
          _$LocalMultiplayerStateImpl>(this, _$identity);
}

abstract class _LocalMultiplayerState extends LocalMultiplayerState {
  const factory _LocalMultiplayerState(
      {required final List<List<int>> board,
      required final int currentPlayer,
      required final int winner,
      required final List<List<int>> validMoves,
      final bool showSkipMessage}) = _$LocalMultiplayerStateImpl;
  const _LocalMultiplayerState._() : super._();

  @override
  List<List<int>> get board;
  @override
  int get currentPlayer;
  @override
  int get winner;
  @override
  List<List<int>> get validMoves;
  @override
  bool get showSkipMessage;

  /// Create a copy of LocalMultiplayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalMultiplayerStateImplCopyWith<_$LocalMultiplayerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
