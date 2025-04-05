import 'dart:async';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/game/reversi_logic.dart';

part 'cpu_game_view_model.freezed.dart';

final cpuGameProvider =
    NotifierProvider<CpuGameViewModel, CpuGameState>(CpuGameViewModel.new);

enum PlayerChoice { black, white, random }

enum DifficultyLevel { easy, medium, difficult }

@freezed
class CpuGameState with _$CpuGameState {
  const factory CpuGameState({
    required List<List<int>> board,
    required int currentPlayer,
    required int winner,
    required List<List<int>> validMoves,
    @Default(false) bool showSkipMessage,
    @Default(1) int playerPiece, // 1 for black, -1 for white
    @Default(PlayerChoice.black) PlayerChoice playerChoice,
    @Default(DifficultyLevel.medium) DifficultyLevel difficulty,
  }) = _CpuGameState;

  const CpuGameState._();
  int get blackScore {
    var score = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell == 1) score++;
      }
    }
    return score;
  }

  int get whiteScore {
    var score = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell == -1) score++;
      }
    }
    return score;
  }
}

class CpuGameViewModel extends Notifier<CpuGameState> {
  late ReversiLogic _logic;
  final Random _random = Random();

  @override
  CpuGameState build() {
    _logic = ReversiLogic();
    return CpuGameState(
      board: _logic.board,
      currentPlayer: 1,
      winner: 0,
      validMoves: _logic.getValidMoves(1),
    );
  }

  /// 対戦開始時にプレイヤーが使用する駒と難易度を選択する
  void startGameWithChoice(PlayerChoice choice, DifficultyLevel difficulty) {
    int chosenPiece;
    if (choice == PlayerChoice.black) {
      chosenPiece = 1;
    } else if (choice == PlayerChoice.white) {
      chosenPiece = -1;
    } else {
      chosenPiece = _random.nextBool() ? 1 : -1;
    }
    _logic = ReversiLogic();
    state = state.copyWith(
      board: _logic.board,
      currentPlayer: 1,
      winner: 0,
      validMoves: _logic.getValidMoves(1),
      playerChoice: choice,
      playerPiece: chosenPiece,
      difficulty: difficulty,
    );
    // CPUが黒の場合にCPUのターンを開始
    if (state.currentPlayer != state.playerPiece && state.winner == 0) {
      _triggerCpuMove();
    }
  }

  void skipTurn() {
    final nextPlayer = _logic.currentPlayer == 1 ? -1 : 1;
    state = state.copyWith(
      currentPlayer: nextPlayer,
      validMoves: _logic.getValidMoves(nextPlayer),
      showSkipMessage: true,
    );
  }

  void hideSkipMessage() {
    state = state.copyWith(showSkipMessage: false);
  }

  void resetGame() {
    _logic = ReversiLogic();
    state = CpuGameState(
      board: _logic.board,
      currentPlayer: 1,
      winner: 0,
      validMoves: _logic.getValidMoves(1),
      playerChoice: state.playerChoice,
      playerPiece: state.playerPiece,
      difficulty: state.difficulty,
    );
    if (state.currentPlayer != state.playerPiece && state.winner == 0) {
      _triggerCpuMove();
    }
  }

  /// 人間がセルをタップしたときの処理
  void applyMove(int row, int col) {
    if (state.currentPlayer == state.playerPiece) {
      if (_logic.applyMove(row, col, state.currentPlayer)) {
        final winner = _logic.getWinner();
        state = state.copyWith(
          board: _logic.board,
          currentPlayer: _logic.currentPlayer,
          winner: winner,
          validMoves: _logic.getValidMoves(_logic.currentPlayer),
        );
      }
      if (state.winner != 0) return;
      if (state.currentPlayer != state.playerPiece) {
        _triggerCpuMove();
      }
    }
  }

  void _triggerCpuMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (state.validMoves.isNotEmpty) {
        final move = state.validMoves[_random.nextInt(state.validMoves.length)];
        if (_logic.applyMove(move[0], move[1], state.currentPlayer)) {
          final winner = _logic.getWinner();
          state = state.copyWith(
            board: _logic.board,
            currentPlayer: _logic.currentPlayer,
            winner: winner,
            validMoves: _logic.getValidMoves(_logic.currentPlayer),
          );
        }
        if (state.winner == 0 &&
            state.currentPlayer != state.playerPiece &&
            state.validMoves.every((row) => row.every((cell) => cell == 0))) {
          skipTurn();
          _triggerCpuMove();
        }
      }
    });
  }
}
