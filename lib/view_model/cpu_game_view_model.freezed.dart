// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cpu_game_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CpuGameState {
  List<List<int>> get board => throw _privateConstructorUsedError;
  int get currentPlayer => throw _privateConstructorUsedError;
  int get winner => throw _privateConstructorUsedError;
  List<List<int>> get validMoves => throw _privateConstructorUsedError;
  bool get showSkipMessage => throw _privateConstructorUsedError;
  int get playerPiece =>
      throw _privateConstructorUsedError; // 1 for black, -1 for white
  PlayerChoice get playerChoice => throw _privateConstructorUsedError;
  DifficultyLevel get difficulty => throw _privateConstructorUsedError;

  /// Create a copy of CpuGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CpuGameStateCopyWith<CpuGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CpuGameStateCopyWith<$Res> {
  factory $CpuGameStateCopyWith(
          CpuGameState value, $Res Function(CpuGameState) then) =
      _$CpuGameStateCopyWithImpl<$Res, CpuGameState>;
  @useResult
  $Res call(
      {List<List<int>> board,
      int currentPlayer,
      int winner,
      List<List<int>> validMoves,
      bool showSkipMessage,
      int playerPiece,
      PlayerChoice playerChoice,
      DifficultyLevel difficulty});
}

/// @nodoc
class _$CpuGameStateCopyWithImpl<$Res, $Val extends CpuGameState>
    implements $CpuGameStateCopyWith<$Res> {
  _$CpuGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CpuGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? winner = null,
    Object? validMoves = null,
    Object? showSkipMessage = null,
    Object? playerPiece = null,
    Object? playerChoice = null,
    Object? difficulty = null,
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
      playerPiece: null == playerPiece
          ? _value.playerPiece
          : playerPiece // ignore: cast_nullable_to_non_nullable
              as int,
      playerChoice: null == playerChoice
          ? _value.playerChoice
          : playerChoice // ignore: cast_nullable_to_non_nullable
              as PlayerChoice,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CpuGameStateImplCopyWith<$Res>
    implements $CpuGameStateCopyWith<$Res> {
  factory _$$CpuGameStateImplCopyWith(
          _$CpuGameStateImpl value, $Res Function(_$CpuGameStateImpl) then) =
      __$$CpuGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<List<int>> board,
      int currentPlayer,
      int winner,
      List<List<int>> validMoves,
      bool showSkipMessage,
      int playerPiece,
      PlayerChoice playerChoice,
      DifficultyLevel difficulty});
}

/// @nodoc
class __$$CpuGameStateImplCopyWithImpl<$Res>
    extends _$CpuGameStateCopyWithImpl<$Res, _$CpuGameStateImpl>
    implements _$$CpuGameStateImplCopyWith<$Res> {
  __$$CpuGameStateImplCopyWithImpl(
      _$CpuGameStateImpl _value, $Res Function(_$CpuGameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CpuGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? winner = null,
    Object? validMoves = null,
    Object? showSkipMessage = null,
    Object? playerPiece = null,
    Object? playerChoice = null,
    Object? difficulty = null,
  }) {
    return _then(_$CpuGameStateImpl(
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
      playerPiece: null == playerPiece
          ? _value.playerPiece
          : playerPiece // ignore: cast_nullable_to_non_nullable
              as int,
      playerChoice: null == playerChoice
          ? _value.playerChoice
          : playerChoice // ignore: cast_nullable_to_non_nullable
              as PlayerChoice,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as DifficultyLevel,
    ));
  }
}

/// @nodoc

class _$CpuGameStateImpl extends _CpuGameState {
  const _$CpuGameStateImpl(
      {required final List<List<int>> board,
      required this.currentPlayer,
      required this.winner,
      required final List<List<int>> validMoves,
      this.showSkipMessage = false,
      this.playerPiece = 1,
      this.playerChoice = PlayerChoice.black,
      this.difficulty = DifficultyLevel.medium})
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
  @JsonKey()
  final int playerPiece;
// 1 for black, -1 for white
  @override
  @JsonKey()
  final PlayerChoice playerChoice;
  @override
  @JsonKey()
  final DifficultyLevel difficulty;

  @override
  String toString() {
    return 'CpuGameState(board: $board, currentPlayer: $currentPlayer, winner: $winner, validMoves: $validMoves, showSkipMessage: $showSkipMessage, playerPiece: $playerPiece, playerChoice: $playerChoice, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CpuGameStateImpl &&
            const DeepCollectionEquality().equals(other._board, _board) &&
            (identical(other.currentPlayer, currentPlayer) ||
                other.currentPlayer == currentPlayer) &&
            (identical(other.winner, winner) || other.winner == winner) &&
            const DeepCollectionEquality()
                .equals(other._validMoves, _validMoves) &&
            (identical(other.showSkipMessage, showSkipMessage) ||
                other.showSkipMessage == showSkipMessage) &&
            (identical(other.playerPiece, playerPiece) ||
                other.playerPiece == playerPiece) &&
            (identical(other.playerChoice, playerChoice) ||
                other.playerChoice == playerChoice) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_board),
      currentPlayer,
      winner,
      const DeepCollectionEquality().hash(_validMoves),
      showSkipMessage,
      playerPiece,
      playerChoice,
      difficulty);

  /// Create a copy of CpuGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CpuGameStateImplCopyWith<_$CpuGameStateImpl> get copyWith =>
      __$$CpuGameStateImplCopyWithImpl<_$CpuGameStateImpl>(this, _$identity);
}

abstract class _CpuGameState extends CpuGameState {
  const factory _CpuGameState(
      {required final List<List<int>> board,
      required final int currentPlayer,
      required final int winner,
      required final List<List<int>> validMoves,
      final bool showSkipMessage,
      final int playerPiece,
      final PlayerChoice playerChoice,
      final DifficultyLevel difficulty}) = _$CpuGameStateImpl;
  const _CpuGameState._() : super._();

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
  @override
  int get playerPiece; // 1 for black, -1 for white
  @override
  PlayerChoice get playerChoice;
  @override
  DifficultyLevel get difficulty;

  /// Create a copy of CpuGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CpuGameStateImplCopyWith<_$CpuGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
