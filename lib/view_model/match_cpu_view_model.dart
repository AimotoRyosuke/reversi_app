import 'dart:async';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/game/reversi_ai.dart';
import 'package:reversi_app/game/reversi_logic.dart';

part 'match_cpu_view_model.freezed.dart';

final matchCpuProvider =
    NotifierProvider<MatchCpuViewModel, MatchCpuState>(MatchCpuViewModel.new);

enum PlayerChoice { black, white, random }

enum CpuDifficulty { easy, medium, hard, veryHard }

@freezed
class MatchCpuState with _$MatchCpuState {
  const factory MatchCpuState({
    required List<List<int>> board,
    required int currentPlayer,
    required int winner,
    required List<List<int>> validMoves,
    @Default(false) bool showSkipMessage,
    @Default(1) int playerPiece, // 1 for black, -1 for white
    @Default(PlayerChoice.black) PlayerChoice playerChoice,
    @Default(CpuDifficulty.medium) CpuDifficulty difficulty,
  }) = _MatchCpuState;

  const MatchCpuState._();
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

class MatchCpuViewModel extends Notifier<MatchCpuState> {
  late ReversiLogic _logic;
  final Random _random = Random();

  @override
  MatchCpuState build() {
    _logic = ReversiLogic();
    return MatchCpuState(
      board: _logic.board,
      currentPlayer: 1,
      winner: 0,
      validMoves: _logic.getValidMoves(1),
    );
  }

  /// 対戦開始時にプレイヤーが使用する駒と難易度を選択する
  void startGameWithChoice(PlayerChoice choice, CpuDifficulty difficulty) {
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
    state = MatchCpuState(
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

  void applyMove(int row, int col) {
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
    if (state.validMoves.isEmpty) {
      skipTurn();
    }
    if (state.currentPlayer != state.playerPiece) {
      _triggerCpuMove();
    }
  }

  void _triggerCpuMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (state.validMoves.isNotEmpty) {
        var move = state.validMoves[0]; // Default initialization
        switch (state.difficulty) {
          case CpuDifficulty.easy:
            move = ReversiAi.selectMoveEasy(state.validMoves);
          case CpuDifficulty.medium:
            move = ReversiAi.selectMoveMedium(
              state.validMoves,
              state.board,
              state.currentPlayer,
            );
          case CpuDifficulty.hard:
            move = ReversiAi.selectMoveHard(
              state.validMoves,
              state.board,
              state.currentPlayer,
            );
          case CpuDifficulty.veryHard:
            move = ReversiAi.selectMoveVeryHard(
              state.validMoves,
              state.board,
              state.currentPlayer,
            );
        }
        applyMove(move[0], move[1]);
      }
    });
  }
}
