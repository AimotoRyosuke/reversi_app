import 'package:flutter/material.dart';

class GameBoardWidget extends StatelessWidget {
  final List<List<int>> board;
  final List<List<int>> validMoves;
  final void Function(int, int) onCellTap;

  const GameBoardWidget({
    Key? key,
    required this.board,
    required this.validMoves,
    required this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final int row = index ~/ 8;
          final int col = index % 8;
          final int cell = board[row][col];
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            );
          }
          // 空セルで有効な着手位置なら赤いマーカーを表示
          bool isValid =
              validMoves.any((move) => move[0] == row && move[1] == col);
          return GestureDetector(
            onTap: () => onCellTap(row, col),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.green,
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
                          color: Colors.red.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
