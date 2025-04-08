import 'package:reversi_app/data/constants.dart';

/// リバーシのコアロジック
class ReversiLogic {
  ReversiLogic() {
    board = List.generate(boardSize, (i) => List.filled(boardSize, 0));
    currentPlayer = 1; // Black starts
    initializeBoard();
  }
  static const int boardSize = Constants.boardSize;
  late List<List<int>> board;
  late int currentPlayer;

  void initializeBoard() {
    const mid = boardSize ~/ 2;
    board[mid - 1][mid - 1] = -1;
    board[mid][mid] = -1;
    board[mid - 1][mid] = 1;
    board[mid][mid - 1] = 1;
  }

  bool isValidMove(int row, int col, int player) {
    if (board[row][col] != 0) return false;
    const directions = Constants.dxdy;
    for (final d in directions) {
      var r = row + d[0];
      var c = col + d[1];
      var hasOpponent = false;
      while (r >= 0 && r < boardSize && c >= 0 && c < boardSize) {
        if (board[r][c] == -player) {
          hasOpponent = true;
        } else if (board[r][c] == player) {
          if (hasOpponent) return true;
          break;
        } else {
          break;
        }
        r += d[0];
        c += d[1];
      }
    }
    return false;
  }

  List<List<int>> getValidMoves(int player) {
    final moves = <List<int>>[];
    for (var i = 0; i < boardSize; i++) {
      for (var j = 0; j < boardSize; j++) {
        if (isValidMove(i, j, player)) {
          moves.add([i, j]);
        }
      }
    }
    return moves;
  }

  bool applyMove(int row, int col, int player) {
    if (!isValidMove(row, col, player)) {
      return false;
    }
    board[row][col] = player;
    flipStones(row, col, player);
    currentPlayer = -player;
    return true;
  }

  void flipStones(int row, int col, int player) {
    const directions = Constants.dxdy;
    for (final d in directions) {
      final potentialFlips = <List<int>>[];
      var r = row + d[0];
      var c = col + d[1];
      while (r >= 0 && r < boardSize && c >= 0 && c < boardSize) {
        if (board[r][c] == -player) {
          potentialFlips.add([r, c]);
        } else if (board[r][c] == player) {
          for (final pos in potentialFlips) {
            board[pos[0]][pos[1]] = player;
          }
          break;
        } else {
          break;
        }
        r += d[0];
        c += d[1];
      }
    }
  }

  /// ゲームの勝者を判定します。
  /// 黒の駒が0の場合は-1を返し、白の駒が0の場合は1を返します。
  /// それ以外ですべての駒が置かれていない場合は0を返します。
  /// 全ての駒が置かれている場合は、黒の駒が多い場合は1を返し、白の駒が多い場合は-1を返します。
  int getWinner() {
    var blackCount = 0;
    var whiteCount = 0;

    for (final row in board) {
      for (final cell in row) {
        if (cell == 1) blackCount++;
        if (cell == -1) whiteCount++;
      }
    }

    if (blackCount == 0) return -1; // White wins
    if (whiteCount == 0) return 1; // Black wins
    final canContinue = getValidMoves(currentPlayer).isNotEmpty ||
        getValidMoves(-currentPlayer).isNotEmpty;
    if (blackCount + whiteCount == boardSize * boardSize || !canContinue) {
      return blackCount > whiteCount ? 1 : -1; // Compare counts
    }

    return 0; // Game is still ongoing
  }
}
