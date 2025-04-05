import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/game_view_model.dart';
import 'skip_message.dart';
import 'winner_dialog.dart';
import 'game_board.dart';
import 'score.dart';
import 'wood_background.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameViewModel = ref.read(gameProvider.notifier);

    ref.listen(
      gameProvider.select((state) => state.winner),
      (_, winner) {
        if (winner != 0) {
          showDialog(
            context: context,
            builder: (context) => WinnerDialog(
              winnerName: winner == 1 ? '黒' : '白',
              loserName: winner == 1 ? '白' : '黒',
              winnerScore: winner == 1
                  ? ref.read(gameProvider).blackScore
                  : ref.read(gameProvider).whiteScore,
              loserScore: winner == 1
                  ? ref.read(gameProvider).whiteScore
                  : ref.read(gameProvider).blackScore,
            ),
          );
        }
      },
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 130,
        leading: Row(
          children: [
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                gameViewModel.resetGame();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                'リセット',
                style: TextStyle(color: Colors.black, fontSize: 16),
                softWrap: false,
              ),
            ),
          ],
        ),
        title: const Text(
          'オセロ',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // 設定画面の実装はここで行う
            },
          ),
        ],
      ),
      body: CustomPaint(
        painter: WoodBackgroundPainter(),
        child: SafeArea(
          child: _GameContent(),
        ),
      ),
    );
  }
}

class _GameContent extends ConsumerWidget {
  const _GameContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameViewModel = ref.read(gameProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScoreDisplay(
          blackScore: gameState.blackScore,
          whiteScore: gameState.whiteScore,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    gameState.currentPlayer == 1 ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              gameState.currentPlayer == 1 ? '黒のターン' : '白のターン',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            GameBoardWidget(
              board: gameState.board,
              validMoves: gameState.validMoves,
              player: gameState.currentPlayer,
              onCellTap: (row, col) {
                gameViewModel.applyMove(row, col);
              },
            ),
            if (gameState.showSkipMessage)
              SkipMessage(
                onEnd: () => gameViewModel.hideSkipMessage(),
              ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
