class ReversiLogic {
  static const int boardSize = 8;
  late List<List<int>> board;
  late int currentPlayer; // 1 for black, -1 for white

  ReversiLogic() {
    board = List.generate(boardSize, (i) => List.filled(boardSize, 0));
    currentPlayer = 1; // Black starts
    initializeBoard();
  }

  void initializeBoard() {
    int mid = boardSize ~/ 2;
    board[mid - 1][mid - 1] = -1;
    board[mid][mid] = -1;
    board[mid - 1][mid] = 1;
    board[mid][mid - 1] = 1;
  }

  bool isValidMove(int row, int col, int player) {
    if (board[row][col] != 0) return false;
    List<List<int>> directions = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ];
    for (var d in directions) {
      int r = row + d[0], c = col + d[1];
      bool hasOpponent = false;
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
    List<List<int>> moves = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
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
    List<List<int>> directions = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ];
    for (var d in directions) {
      List<List<int>> potentialFlips = [];
      int r = row + d[0], c = col + d[1];
      while (r >= 0 && r < boardSize && c >= 0 && c < boardSize) {
        if (board[r][c] == -player) {
          potentialFlips.add([r, c]);
        } else if (board[r][c] == player) {
          for (var pos in potentialFlips) {
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
    int blackCount = 0;
    int whiteCount = 0;

    for (var row in board) {
      for (var cell in row) {
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
