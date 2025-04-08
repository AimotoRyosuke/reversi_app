import 'dart:async';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/game/reversi_ai.dart';
import 'package:reversi_app/models/hint_settings.dart';
import 'package:reversi_app/services/game/reversi_logic.dart';

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
    @Default(HintSettings()) HintSettings hintSettings,
    @Default([]) List<HintEvaluation> hintEvaluations,
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
  void startGameWithChoice(
    PlayerChoice choice,
    CpuDifficulty difficulty, [
    HintSettings? hintSettings,
  ]) {
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
      hintSettings: hintSettings ?? state.hintSettings,
    );

    // ヒント評価値を更新
    _updateHintEvaluations();

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

    // ヒント評価値を更新
    _updateHintEvaluations();
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
      hintSettings: state.hintSettings, // ヒント設定を保持
    );

    // ヒント評価値を更新
    _updateHintEvaluations();

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

      // ヒント評価値を更新
      _updateHintEvaluations();
    }
    if (state.winner != 0) return;
    if (state.validMoves.isEmpty) {
      skipTurn();
    }
    if (state.currentPlayer != state.playerPiece) {
      _triggerCpuMove();
    }
  }

  /// ヒント表示モードを変更する
  void setHintDisplayMode(HintDisplayMode mode) {
    state = state.copyWith(
      hintSettings: state.hintSettings.copyWith(displayMode: mode),
    );

    // 表示モードが「なし」以外に変更された場合だけ評価値を計算
    if (mode != HintDisplayMode.none) {
      _updateHintEvaluations();
    } else {
      // 表示モードが「なし」に変更された場合は評価値をクリア
      state = state.copyWith(hintEvaluations: []);
    }
  }

  /// ミニマックスの深さを変更する
  void setMinimaxDepth(int depth) {
    state = state.copyWith(
      hintSettings: state.hintSettings.copyWith(minimaxDepth: depth),
    );

    // 深さを変更した場合は評価値を再計算
    if (state.hintSettings.displayMode != HintDisplayMode.none) {
      _updateHintEvaluations();
    }
  }

  /// ヒント評価値を更新する（非同期処理）
  void _updateHintEvaluations() {
    // ヒント表示がオフの場合は何もしない
    if (state.hintSettings.displayMode == HintDisplayMode.none) {
      return;
    }

    // プレイヤーのターンのみヒントを表示
    if (state.currentPlayer != state.playerPiece) {
      state = state.copyWith(hintEvaluations: []);
      return;
    }

    // 有効な手がない場合は評価値をクリア
    if (state.validMoves.isEmpty) {
      state = state.copyWith(hintEvaluations: []);
      return;
    }

    // バックグラウンドで評価値を計算（UIをブロックしないため）
    Future.microtask(() {
      final evaluations = ReversiAi.calculateHintValues(
        state.validMoves,
        state.board,
        state.currentPlayer,
        depth: state.hintSettings.minimaxDepth,
      );

      state = state.copyWith(hintEvaluations: evaluations);
    });
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
