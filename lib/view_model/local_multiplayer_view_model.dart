import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/game/reversi_logic.dart';

part 'local_multiplayer_view_model.freezed.dart';

final localMultiplayerProvider =
    NotifierProvider<LocalMultiplayerViewModel, LocalMultiplayerState>(
        LocalMultiplayerViewModel.new);

@freezed
class LocalMultiplayerState with _$LocalMultiplayerState {
  const factory LocalMultiplayerState({
    required List<List<int>> board,
    required int currentPlayer,
    required int winner,
    required List<List<int>> validMoves,
    @Default(false) bool showSkipMessage,
  }) = _LocalMultiplayerState;

  const LocalMultiplayerState._();

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

class LocalMultiplayerViewModel extends Notifier<LocalMultiplayerState> {
  late ReversiLogic _logic;

  @override
  LocalMultiplayerState build() {
    _logic = ReversiLogic();
    return LocalMultiplayerState(
      board: _logic.board,
      currentPlayer: _logic.currentPlayer,
      winner: 0,
      validMoves: _logic.getValidMoves(_logic.currentPlayer),
      showSkipMessage: false,
    );
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
    state = LocalMultiplayerState(
      board: _logic.board,
      currentPlayer: _logic.currentPlayer,
      winner: 0,
      validMoves: _logic.getValidMoves(_logic.currentPlayer),
      showSkipMessage: false,
    );
  }

  void applyMove(int row, int col) {
    if (_logic.applyMove(row, col, state.currentPlayer)) {
      final winner = _logic.getWinner();
      state = LocalMultiplayerState(
        board: _logic.board,
        currentPlayer: _logic.currentPlayer,
        winner: winner,
        validMoves: _logic.getValidMoves(_logic.currentPlayer),
        showSkipMessage: false,
      );
    }
    if (state.winner != 0) return;
    if (state.validMoves.isEmpty) {
      skipTurn();
    }
  }
}
