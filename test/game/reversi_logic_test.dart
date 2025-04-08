import 'package:flutter_test/flutter_test.dart';
import 'package:reversi_app/services/game/reversi_logic.dart';

void main() {
  group('ReversiLogic', () {
    late ReversiLogic logic;

    setUp(() {
      logic = ReversiLogic();
    });

    group('初期化テスト', () {
      test('盤面が正しく初期化されること', () {
        expect(logic.board.length, ReversiLogic.boardSize);
        expect(logic.board[0].length, ReversiLogic.boardSize);

        const mid = ReversiLogic.boardSize ~/ 2;
        expect(logic.board[mid - 1][mid - 1], -1);
        expect(logic.board[mid][mid], -1);
        expect(logic.board[mid - 1][mid], 1);
        expect(logic.board[mid][mid - 1], 1);

        expect(logic.currentPlayer, 1);
      });
    });

    group('isValidMove テスト', () {
      test('既に駒がある場所には置けないこと', () {
        const mid = ReversiLogic.boardSize ~/ 2;
        expect(logic.isValidMove(mid - 1, mid - 1, 1), false);
      });

      test('相手の駒を挟めない場合は無効な手であること', () {
        expect(logic.isValidMove(0, 0, 1), false);
      });

      test('相手の駒を挟める場合は有効な手であること', () {
        const mid = ReversiLogic.boardSize ~/ 2;
        expect(logic.isValidMove(mid - 1, mid - 2, 1), true);
      });
    });

    group('getValidMoves テスト', () {
      test('初期盤面での有効な手が正しいこと', () {
        final validMoves = logic.getValidMoves(1);
        expect(
          validMoves,
          containsAll([
            [2, 3],
            [3, 2],
            [4, 5],
            [5, 4],
          ]),
        );
      });

      test('有効な手がない場合は空リストが返されること', () {
        logic.board = List.generate(
          ReversiLogic.boardSize,
          (_) => List.filled(ReversiLogic.boardSize, 1),
        );
        final validMoves = logic.getValidMoves(-1);
        expect(validMoves, isEmpty);
      });
    });

    group('applyMove テスト', () {
      test('有効な手の適用で盤面が正しく更新されること', () {
        const mid = ReversiLogic.boardSize ~/ 2;
        final result = logic.applyMove(mid - 1, mid - 2, 1);
        expect(result, true);
        expect(logic.board[mid - 1][mid - 2], 1);
        expect(logic.board[mid - 1][mid - 1], 1);
      });

      test('無効な手の適用で盤面が変更されないこと', () {
        const mid = ReversiLogic.boardSize ~/ 2;
        final result = logic.applyMove(mid - 1, mid - 1, 1);
        expect(result, false);
      });
    });

    group('flipStones テスト', () {
      test('単一方向の反転が正しく行われること', () {
        const mid = ReversiLogic.boardSize ~/ 2;
        logic.applyMove(mid - 1, mid - 2, 1);
        expect(logic.board[mid - 1][mid - 1], 1);
      });
    });

    group('getWinner テスト', () {
      test('ゲーム進行中は0を返す', () {
        expect(logic.getWinner(), 0);
      });

      test('黒が全滅した場合は-1を返す', () {
        logic.board = List.generate(
          ReversiLogic.boardSize,
          (_) => List.filled(ReversiLogic.boardSize, -1),
        );
        expect(logic.getWinner(), -1);
      });

      test('白が全滅した場合は1を返す', () {
        logic.board = List.generate(
          ReversiLogic.boardSize,
          (_) => List.filled(ReversiLogic.boardSize, 1),
        );
        expect(logic.getWinner(), 1);
      });
      test('全てのマスが埋まり黒が多い場合は1を返す', () {
        logic.board = List.generate(
          ReversiLogic.boardSize,
          (_) => List.filled(ReversiLogic.boardSize, 1),
        );
        logic.board[0][0] = -1;
        logic.board[0][1] = -1;
        expect(logic.getWinner(), 1);
      });
      test('全てのマスが埋まり白が多い場合は-1を返す', () {
        logic.board = List.generate(
          ReversiLogic.boardSize,
          (_) => List.filled(ReversiLogic.boardSize, -1),
        );
        logic.board[0][0] = 1;
        logic.board[0][1] = 1;
        expect(logic.getWinner(), -1);
      });
    });
  });
}
