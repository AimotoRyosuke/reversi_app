import 'dart:math';
import 'package:reversi_app/game/reversi_logic.dart';

/// A simple AI for the Reversi game.
class ReversiAI {
  final Random _random = Random();

  /// Makes a move for the computer player.
  /// Assumes the computer plays as -1.
  bool makeMove(ReversiLogic logic) {
    final validMoves = logic.getValidMoves(-1);
    if (validMoves.isEmpty) return false;
    final move = validMoves[_random.nextInt(validMoves.length)];
    return logic.applyMove(move[0], move[1], -1);
  }
}
