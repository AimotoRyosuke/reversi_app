import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../game/reversi_logic.dart';

part 'game_view_model.freezed.dart';

final gameProvider =
    NotifierProvider<GameViewModel, GameState>(GameViewModel.new);

@freezed
class GameState with _$GameState {
  const factory GameState({
    required List<List<int>> board,
    required int currentPlayer,
    required int winner,
    required List<List<int>> validMoves,
  }) = _GameState;

  const GameState._();

  int get blackScore => _calculateScore(board, 1);
  int get whiteScore => _calculateScore(board, -1);

  int _calculateScore(List<List<int>> board, int player) {
    int score = 0;
    for (var row in board) {
      for (var cell in row) {
        if (cell == player) score++;
      }
    }
    return score;
  }
}

class GameViewModel extends Notifier<GameState> {
  late ReversiLogic _logic;

  @override
  GameState build() {
    _logic = ReversiLogic();
    return GameState(
      board: _logic.board,
      currentPlayer: _logic.currentPlayer,
      winner: 0,
      validMoves: _logic.getValidMoves(_logic.currentPlayer),
    );
  }

  void skipTurn() {
    final nextPlayer = _logic.currentPlayer == 1 ? -1 : 1;
    state = state.copyWith(
      currentPlayer: nextPlayer,
      validMoves: _logic.getValidMoves(nextPlayer),
    );
  }

  void resetGame() {
    _logic = ReversiLogic();
    state = GameState(
      board: _logic.board,
      currentPlayer: _logic.currentPlayer,
      winner: 0,
      validMoves: _logic.getValidMoves(_logic.currentPlayer),
    );
  }

  void applyMove(int row, int col) {
    if (_logic.applyMove(row, col, state.currentPlayer)) {
      int winner = _logic.getWinner();
      state = GameState(
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
  }
}
