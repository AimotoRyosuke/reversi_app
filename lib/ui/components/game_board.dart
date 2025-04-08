import 'package:flutter/material.dart';
import 'package:reversi_app/data/constants.dart';
import 'package:reversi_app/game/reversi_ai.dart';
import 'package:reversi_app/models/hint_settings.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
    required this.board,
    required this.validMoves,
    required this.onCellTap,
    required this.player,
    this.hintSettings, // ヒント表示設定を追加
    this.hintEvaluations, // 評価値情報を追加
    super.key,
  });
  final List<List<int>> board;
  final List<List<int>> validMoves;
  final void Function(int, int) onCellTap;
  final int player;
  final HintSettings? hintSettings; // ヒント表示設定
  final List<HintEvaluation>? hintEvaluations; // 手の評価値情報

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Constants.boardSize,
          ),
          itemCount: Constants.boardSize * Constants.boardSize,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final row = index ~/ Constants.boardSize;
            final col = index % Constants.boardSize;
            final isValidMove = validMoves.any(
              (move) => move[0] == row && move[1] == col,
            );

            // ヒント評価値を検索
            HintEvaluation? hintEval;
            if (hintSettings != null &&
                hintSettings!.displayMode != HintDisplayMode.none &&
                hintEvaluations != null &&
                isValidMove) {
              hintEval = hintEvaluations!.firstWhere(
                (hint) => hint.move[0] == row && hint.move[1] == col,
                orElse: () => HintEvaluation(move: [row, col], score: 0),
              );
            }

            return GestureDetector(
              onTap: () {
                if (isValidMove) {
                  onCellTap(row, col);
                }
              },
              child: _CellWidget(
                cellType: board[row][col],
                isValidMove: isValidMove,
                hintEvaluation: hintEval,
                hintDisplayMode:
                    hintSettings?.displayMode ?? HintDisplayMode.none,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CellWidget extends StatelessWidget {
  const _CellWidget({
    required this.cellType,
    required this.isValidMove,
    this.hintEvaluation,
    this.hintDisplayMode = HintDisplayMode.none,
  });
  final int cellType;
  final bool isValidMove;
  final HintEvaluation? hintEvaluation;
  final HintDisplayMode hintDisplayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 0.5),
      ),
      child: Stack(
        children: [
          // ボードのセル
          Container(
            color: Colors.green.shade800,
            alignment: Alignment.center,
            child: cellType != 0
                ? Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cellType == 1 ? Colors.black : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  )
                : isValidMove
                    ? Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black
                              .withAlpha(51), // withOpacityの代わりにwithAlphaを使用
                        ),
                      )
                    : null,
          ),

          // ヒント表示（評価値または色）
          if (isValidMove &&
              hintEvaluation != null &&
              hintDisplayMode != HintDisplayMode.none)
            Positioned(
              top: 2,
              left: 2,
              child: _buildHintIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildHintIndicator() {
    // ヒントが有効かつ評価値がある場合のみ表示
    if (hintEvaluation == null || hintDisplayMode == HintDisplayMode.none) {
      return const SizedBox.shrink();
    }

    // 色のみの表示モード
    if (hintDisplayMode == HintDisplayMode.colorOnly) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hintEvaluation!.color,
          border: Border.all(color: Colors.white, width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
      );
    }

    // 数値表示モード
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hintEvaluation!.color,
        border: Border.all(color: Colors.white, width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '${hintEvaluation!.normalizedScore}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
