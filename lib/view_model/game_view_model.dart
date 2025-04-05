import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/reversi_logic.dart';

final gameProvider =
    StateNotifierProvider<GameViewModel, GameState>((ref) => GameViewModel());

class GameState {
  final List<List<int>> board;
  final int currentPlayer;
  final int winner;
  final List<List<int>> validMoves;

  GameState({
    required this.board,
    required this.currentPlayer,
    required this.winner,
    required this.validMoves,
  });
}

class GameViewModel extends StateNotifier<GameState> {
  late ReversiLogic _logic;

  GameViewModel()
      : super(GameState(
          board: List.generate(8, (index) => List.filled(8, 0)),
          currentPlayer: 1,
          winner: 0,
          validMoves: [],
        )) {
    _logic = ReversiLogic();
    state = GameState(
      board: _logic.board,
      currentPlayer: _logic.currentPlayer,
      winner: 0,
      validMoves: _logic.getValidMoves(_logic.currentPlayer),
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
    if (_logic.applyMove(row, col, _logic.currentPlayer)) {
      int winner = _logic.getWinner();
      state = GameState(
        board: _logic.board,
        currentPlayer: _logic.currentPlayer,
        winner: winner,
        validMoves: _logic.getValidMoves(_logic.currentPlayer),
      );
    }
  }
}
