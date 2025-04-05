import 'dart:math';
import 'reversi_logic.dart';

class ReversiAI {
  final Random _random = Random();

  /// Makes a move for the computer player.
  /// Assumes the computer plays as -1.
  bool makeMove(ReversiLogic logic) {
    List<List<int>> validMoves = logic.getValidMoves(-1);
    if (validMoves.isEmpty) return false;
    var move = validMoves[_random.nextInt(validMoves.length)];
    return logic.applyMove(move[0], move[1], -1);
  }
}
