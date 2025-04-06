import 'package:flutter/material.dart';
import 'package:reversi_app/constants.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({
    required this.board,
    required this.validMoves,
    required this.onCellTap,
    required this.player,
    super.key,
  });
  final List<List<int>> board;
  final List<List<int>> validMoves;
  final void Function(int, int) onCellTap;
  final int player;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(),
        color: Colors.green,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Constants.boardSize,
            ),
            itemCount: Constants.boardSize * Constants.boardSize,
            itemBuilder: (context, index) {
              final row = index ~/ 8;
              final col = index % 8;
              final cell = board[row][col];
              Widget piece = const SizedBox.shrink();
              if (cell == 1) {
                piece = Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                );
              } else if (cell == -1) {
                piece = Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                );
              }
              // 空セルで有効な着手位置ならマーカーを表示
              final isValid =
                  validMoves.any((move) => move[0] == row && move[1] == col);
              return GestureDetector(
                onTap: () => onCellTap(row, col),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        piece,
                        if (cell == 0 && isValid)
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: player == 1
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
