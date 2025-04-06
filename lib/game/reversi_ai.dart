import 'dart:math';

import 'package:reversi_app/constants.dart';

/// CPUが配置するマスを決めるロジックを持つクラス
class ReversiAi {
  static const _dangerZones = [
    [0, 1],
    [1, 0],
    [1, 1],
    [0, 6],
    [1, 6],
    [1, 7],
    [6, 0],
    [6, 1],
    [7, 1],
    [6, 6],
    [6, 7],
    [7, 6],
  ];

  // 戦略的に重要なマスの評価値
  static const Map<String, int> _positionWeights = {
    '0,0': 100, '0,7': 100, '7,0': 100, '7,7': 100, // 角
    '0,1': -20, '1,0': -20, '1,1': -25, // 角の隣（危険）
    '0,6': -20, '1,7': -20, '1,6': -25,
    '6,0': -20, '7,1': -20, '6,1': -25,
    '6,7': -20, '7,6': -20, '6,6': -25,
    '2,2': 10, '2,5': 10, '5,2': 10, '5,5': 10, // 内側の安定領域
    '0,2': 5, '0,3': 5, '0,4': 5, '0,5': 5, // 辺
    '7,2': 5, '7,3': 5, '7,4': 5, '7,5': 5,
    '2,0': 5, '3,0': 5, '4,0': 5, '5,0': 5,
    '2,7': 5, '3,7': 5, '4,7': 5, '5,7': 5,
  };

  /// Easyの選択ロジック
  /// 角は優先的に選ぶ
  /// 角がなければランダムに選ぶ
  static List<int> selectMoveEasy(List<List<int>> validMoves) {
    final random = Random();
    for (final corner in [...Constants.corners]..shuffle()) {
      for (final move in validMoves) {
        if (move[0] == corner[0] && move[1] == corner[1]) {
          return move;
        }
      }
    }
    // ランダムに選ぶ
    return validMoves[random.nextInt(validMoves.length)];
  }

  /// Mediumの選択ロジック
  /// 角を優先し、辺を優先し、危険ゾーンを避ける
  /// それでも選べなければランダムに選ぶ
  static List<int> selectMoveMedium(
    List<List<int>> validMoves,
    List<List<int>> board,
    int player,
  ) {
    // 角を優先
    for (final corner in [...Constants.corners]..shuffle()) {
      for (final move in validMoves) {
        if (move[0] == corner[0] && move[1] == corner[1]) {
          return move;
        }
      }
    }

    // 辺を優先
    for (final edge in [...Constants.edges]..shuffle()) {
      for (final move in validMoves) {
        if (move[0] == edge[0] && move[1] == edge[1]) {
          return move;
        }
      }
    }

    // 危険ゾーンを避ける
    final safeMoves = validMoves
        .where(
          (move) => !_dangerZones
              .any((danger) => danger[0] == move[0] && danger[1] == move[1]),
        )
        .toList();
    if (safeMoves.isNotEmpty) {
      // 相手の駒を多く取れる手を選択
      return bestScoreMove(safeMoves, board, player);
    }

    // ランダム選択
    return validMoves[Random().nextInt(validMoves.length)];
  }

  /// Hardの選択ロジック
  /// 戦略的なポジションの評価値に基づいて選択
  /// 角と盤面の安定性を重視し、より長期的な視点で手を選ぶ
  static List<int> selectMoveHard(
    List<List<int>> validMoves,
    List<List<int>> board,
    int player,
  ) {
    // 角を最優先
    for (final corner in Constants.corners) {
      for (final move in validMoves) {
        if (move[0] == corner[0] && move[1] == corner[1]) {
          return move;
        }
      }
    }

    // 盤面の駒数をカウント（ゲームの進行度を判断するため）
    var totalPieces = 0;
    for (final row in board) {
      for (final cell in row) {
        if (cell != 0) totalPieces++;
      }
    }

    // ゲームステージ（序盤/中盤/終盤）に応じた評価の重み調整
    final isEarlyGame = totalPieces < 20;
    final isEndGame = totalPieces > 50;

    var bestMove = validMoves[0];
    var bestValue = double.negativeInfinity;

    for (final move in validMoves) {
      // 駒が取れる数の評価
      final flipCount = _calculateScore(board, move, player);

      // 戦略的位置の評価
      final positionValue = _getPositionValue(move);

      // 安定した駒の数の評価
      final stableDiscs = _countStableDiscs(board, player);

      // モビリティ（可能な手の数）の評価
      final mobility = _evaluateMobility(board, move, player);

      // 相手の危険な手を防ぐ評価
      final opponentDanger = _evaluateOpponentDanger(board, move, player);

      // 角への配置が可能にする手を避ける
      final cornerRisk = _evaluateCornerRisk(board, move, player);

      // 盤面支配の評価
      final boardControl = _evaluateBoardControl(board, move, player);

      // ゲームステージによって評価の重みを調整
      double totalValue;

      if (isEarlyGame) {
        // 序盤：モビリティと戦略的位置を重視
        totalValue = flipCount * 1.0 +
            positionValue * 5.0 +
            stableDiscs * 2.0 +
            mobility * 3.5 -
            opponentDanger * 5.0 -
            cornerRisk * 8.0 +
            boardControl * 2.0;
      } else if (isEndGame) {
        // 終盤：取れる駒数と安定した駒を重視
        totalValue = flipCount * 3.0 +
            positionValue * 3.0 +
            stableDiscs * 5.0 +
            mobility * 1.0 -
            opponentDanger * 4.0 -
            cornerRisk * 3.0 +
            boardControl * 4.0;
      } else {
        // 中盤：バランスの取れた評価
        totalValue = flipCount * 2.0 +
            positionValue * 4.0 +
            stableDiscs * 3.5 +
            mobility * 2.5 -
            opponentDanger * 4.5 -
            cornerRisk * 5.0 +
            boardControl * 3.0;
      }

      if (totalValue > bestValue) {
        bestValue = totalValue;
        bestMove = move;
      }
    }

    return bestMove;
  }

  /// 相手の危険な手を防ぐ評価
  static double _evaluateOpponentDanger(
    List<List<int>> board,
    List<int> move,
    int player,
  ) {
    // 仮に手を適用した場合の盤面を作成
    final newBoard = _applyMoveToBoard(board, move, player);

    // 相手の有効手を取得
    final opponentMoves = _getValidMoves(newBoard, -player);

    // 相手が角を取れる手があるかチェック
    for (final opponentMove in opponentMoves) {
      if (Constants.corners.any(
        (corner) =>
            corner[0] == opponentMove[0] && corner[1] == opponentMove[1],
      )) {
        return 1; // 危険度を高く設定
      }
    }

    return 0; // 危険な手がない場合
  }

  /// 相手に角を取られるリスクを評価
  static double _evaluateCornerRisk(
    List<List<int>> board,
    List<int> move,
    int player,
  ) {
    // 仮に手を適用した場合の盤面を作成
    final newBoard = _applyMoveToBoard(board, move, player);

    // 相手の有効手を取得
    final opponentMoves = _getValidMoves(newBoard, -player);

    // 角のリスク
    var risk = 0.0;

    // 相手が角を取れるようになる場合、高リスク
    for (final corner in Constants.corners) {
      if (board[corner[0]][corner[1]] == 0) {
        // 角が空いている場合
        var cornerWasAvailable = false;
        for (final prevMove in _getValidMoves(board, -player)) {
          if (prevMove[0] == corner[0] && prevMove[1] == corner[1]) {
            cornerWasAvailable = true;
            break;
          }
        }

        var cornerIsAvailable = false;
        for (final newMove in opponentMoves) {
          if (newMove[0] == corner[0] && newMove[1] == corner[1]) {
            cornerIsAvailable = true;
            break;
          }
        }

        // 以前は取れなかったが、今回の手で取れるようになった角がある
        if (!cornerWasAvailable && cornerIsAvailable) {
          risk += 2.0;
        }
      }
    }

    return risk;
  }

  /// 盤面の支配率を評価（支配地域と呼ばれる概念）
  static double _evaluateBoardControl(
    List<List<int>> board,
    List<int> move,
    int player,
  ) {
    // 仮に手を適用した場合の盤面を作成
    final newBoard = _applyMoveToBoard(board, move, player);

    // 盤面の各領域の支配度を評価
    var controlValue = 0.0;

    // 四隅の領域に分けて評価
    final regions = [
      [
        [0, 0],
        [3, 3],
      ], // 左上領域
      [
        [0, 4],
        [3, 7],
      ], // 右上領域
      [
        [4, 0],
        [7, 3],
      ], // 左下領域
      [
        [4, 4],
        [7, 7],
      ], // 右下領域
    ];

    for (final region in regions) {
      var playerCount = 0;
      var opponentCount = 0;

      // 領域内の駒をカウント
      for (var i = region[0][0]; i <= region[1][0]; i++) {
        for (var j = region[0][1]; j <= region[1][1]; j++) {
          if (newBoard[i][j] == player) {
            playerCount++;
          } else if (newBoard[i][j] == -player) {
            opponentCount++;
          }
        }
      }

      // 領域の支配率を評価（自分の駒が多いほど高評価）
      if (playerCount + opponentCount > 0) {
        var regionControl =
            (playerCount - opponentCount) / (playerCount + opponentCount);

        // 角を含む領域は重要度が高い
        if ((region[0][0] == 0 && region[0][1] == 0) ||
            (region[0][0] == 0 && region[1][1] == 7) ||
            (region[1][0] == 7 && region[0][1] == 0) ||
            (region[1][0] == 7 && region[1][1] == 7)) {
          regionControl *= 1.5;
        }

        controlValue += regionControl;
      }
    }

    return controlValue;
  }

  /// Very Hardの選択ロジック
  /// ミニマックスアルゴリズムを使用した先読み
  /// 数手先までシミュレーションして最適な手を選ぶ
  static List<int> selectMoveVeryHard(
    List<List<int>> validMoves,
    List<List<int>> board,
    int player,
  ) {
    if (validMoves.isEmpty) return [];

    // 角があれば即取る（基本戦略）
    for (final corner in Constants.corners) {
      for (final move in validMoves) {
        if (move[0] == corner[0] && move[1] == corner[1]) {
          return move;
        }
      }
    }

    var bestMove = validMoves[0];
    var bestScore = double.negativeInfinity;
    const depth = 4; // 先読みの深さ

    // すべての可能な手に対してミニマックス評価
    for (final move in validMoves) {
      // 盤面をコピーして手を適用
      final newBoard = _applyMoveToBoard(board, move, player);

      // ミニマックスで評価
      final score = _minimax(
        newBoard,
        depth - 1,
        -player,
        double.negativeInfinity,
        double.infinity,
        false,
      );

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  /// ミニマックスアルゴリズム
  static double _minimax(
    List<List<int>> board,
    int depth,
    int player,
    double alpha,
    double beta,
    bool isMaximizing,
  ) {
    var evalAlpha = alpha;
    var evalBeta = beta;
    // 終了条件
    if (depth == 0) {
      return _evaluateBoard(board, player);
    }

    // 有効な手を取得
    final validMoves = _getValidMoves(board, player);
    if (validMoves.isEmpty) {
      // パスの場合
      return _minimax(board, depth - 1, -player, alpha, beta, !isMaximizing);
    }

    if (isMaximizing) {
      var maxEval = double.negativeInfinity;
      for (final move in validMoves) {
        final newBoard = _applyMoveToBoard(board, move, player);
        final eval = _minimax(newBoard, depth - 1, -player, alpha, beta, false);
        maxEval = max(maxEval, eval);
        evalAlpha = max(alpha, eval);
        if (beta <= evalAlpha) break; // アルファベータ枝刈り
      }
      return maxEval;
    } else {
      var minEval = double.infinity;
      for (final move in validMoves) {
        final newBoard = _applyMoveToBoard(board, move, player);
        final eval = _minimax(newBoard, depth - 1, -player, alpha, beta, true);
        minEval = min(minEval, eval);
        evalBeta = min(beta, eval);
        if (evalBeta <= evalAlpha) break; // アルファベータ枝刈り
      }
      return minEval;
    }
  }

  /// 盤面の評価関数
  static double _evaluateBoard(List<List<int>> board, int player) {
    // 駒数の差
    var discDiff = 0;
    // 位置評価の合計
    double positionValue = 0;
    // 安定した駒の数
    final stableDiscs = _countStableDiscs(board, player);

    // 盤面全体を評価
    for (var i = 0; i < Constants.boardSize; i++) {
      for (var j = 0; j < Constants.boardSize; j++) {
        if (board[i][j] == player) {
          discDiff++;
          positionValue += _getPositionValue([i, j]);
        } else if (board[i][j] == -player) {
          discDiff--;
          positionValue -= _getPositionValue([i, j]);
        }
      }
    }

    // 総合評価（各要素に重み付け）
    return discDiff * 1.0 + positionValue * 3.0 + stableDiscs * 2.5;
  }

  /// 盤面上の位置の価値を取得
  static double _getPositionValue(List<int> position) {
    final key = '${position[0]},${position[1]}';
    return _positionWeights.containsKey(key)
        ? _positionWeights[key]!.toDouble()
        : 0.0;
  }

  /// 安定した駒の数（取られない駒）をカウント
  static int _countStableDiscs(List<List<int>> board, int player) {
    var count = 0;

    // 角は常に安定
    final corners = [
      [0, 0],
      [0, 7],
      [7, 0],
      [7, 7],
    ];

    for (final corner in corners) {
      if (board[corner[0]][corner[1]] == player) {
        count++;
        // 角から伸びる辺も安定かチェック
        count += _countStableEdgesFromCorner(board, corner, player);
      }
    }

    return count;
  }

  /// 角から伸びる安定した辺の駒をカウント
  static int _countStableEdgesFromCorner(
    List<List<int>> board,
    List<int> corner,
    int player,
  ) {
    var count = 0;
    final directions = [
      if (corner[0] == 0) [1, 0] else [-1, 0], // 垂直方向
      if (corner[1] == 0) [0, 1] else [0, -1], // 水平方向
    ];

    for (final dir in directions) {
      var r = corner[0];
      var c = corner[1];

      while (true) {
        r += dir[0];
        c += dir[1];
        if (r < 0 ||
            r >= Constants.boardSize ||
            c < 0 ||
            c >= Constants.boardSize) {
          break;
        }
        if (board[r][c] == player) {
          count++;
        } else {
          break;
        }
      }
    }

    return count;
  }

  /// モビリティ（可能な手の数）の評価
  static double _evaluateMobility(
    List<List<int>> board,
    List<int> move,
    int player,
  ) {
    // 仮に手を適用した場合の盤面を作成
    final newBoard = _applyMoveToBoard(board, move, player);

    // 相手の有効手の数
    final opponentMoves = _getValidMoves(newBoard, -player);

    // 自分の次の手の数
    final myNextMoves = _getValidMoves(newBoard, player);

    // モビリティ差を返す（相手の手が少なく、自分の手が多いほど良い）
    return myNextMoves.length.toDouble() - opponentMoves.length.toDouble();
  }

  /// 有効な手を取得（簡易版）
  static List<List<int>> _getValidMoves(List<List<int>> board, int player) {
    final validMoves = <List<int>>[];

    for (var i = 0; i < Constants.boardSize; i++) {
      for (var j = 0; j < Constants.boardSize; j++) {
        if (board[i][j] == 0 && _isValidMove(board, [i, j], player)) {
          validMoves.add([i, j]);
        }
      }
    }

    return validMoves;
  }

  /// 有効な手かチェック
  static bool _isValidMove(List<List<int>> board, List<int> move, int player) {
    if (board[move[0]][move[1]] != 0) return false;

    for (final direction in Constants.dxdy) {
      var r = move[0];
      var c = move[1];
      var foundOpponent = false;

      while (true) {
        r += direction[0];
        c += direction[1];

        if (r < 0 ||
            r >= Constants.boardSize ||
            c < 0 ||
            c >= Constants.boardSize) {
          break;
        }

        if (board[r][c] == -player) {
          foundOpponent = true;
        } else if (board[r][c] == player && foundOpponent) {
          return true;
        } else {
          break;
        }
      }
    }

    return false;
  }

  /// 手を適用した新しい盤面を作成
  static List<List<int>> _applyMoveToBoard(
    List<List<int>> board,
    List<int> move,
    int player,
  ) {
    // 盤面のディープコピー
    final newBoard = List<List<int>>.generate(
      Constants.boardSize,
      (i) => List.generate(Constants.boardSize, (j) => board[i][j]),
    );

    newBoard[move[0]][move[1]] = player;

    for (final direction in Constants.dxdy) {
      var r = move[0];
      var c = move[1];
      final flippablePieces = <List<int>>[];

      while (true) {
        r += direction[0];
        c += direction[1];

        if (r < 0 ||
            r >= Constants.boardSize ||
            c < 0 ||
            c >= Constants.boardSize) {
          break;
        }

        if (newBoard[r][c] == -player) {
          flippablePieces.add([r, c]);
        } else if (newBoard[r][c] == player && flippablePieces.isNotEmpty) {
          // ひっくり返す
          for (final piece in flippablePieces) {
            newBoard[piece[0]][piece[1]] = player;
          }
          break;
        } else {
          break;
        }
      }
    }

    return newBoard;
  }

  // 相手の駒をどれだけ取れるか計算する
  static int _calculateScore(
    List<List<int>> board,
    List<int> move,
    int piece,
  ) {
    var score = 0;
    for (final direction in Constants.dxdy) {
      var row = move[0];
      var col = move[1];
      var count = 0;
      while (true) {
        row += direction[0];
        col += direction[1];
        if (row < 0 ||
            row >= Constants.boardSize ||
            col < 0 ||
            col >= Constants.boardSize) {
          break;
        }
        if (board[row][col] == piece) {
          score += count;
          break;
        } else if (board[row][col] == 0) {
          break;
        }
        count++;
      }
    }

    return score;
  }

  static List<int> bestScoreMove(
    List<List<int>> validMoves,
    List<List<int>> board,
    int piece,
  ) {
    var bestMove = validMoves[0];
    var bestScore = -1;

    for (final move in validMoves) {
      final score = _calculateScore(board, move, piece);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }
}
