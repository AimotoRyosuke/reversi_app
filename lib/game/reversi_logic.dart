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

  int getWinner() {
    int count = 0;
    for (var row in board) {
      for (var cell in row) {
        count += cell;
      }
    }
    if (count > 0) return 1;
    if (count < 0) return -1;
    return 0;
  }
}
