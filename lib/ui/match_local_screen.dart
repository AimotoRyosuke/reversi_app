import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/ui/components/game_board.dart';
import 'package:reversi_app/ui/components/score.dart';
import 'package:reversi_app/ui/components/skip_message.dart';
import 'package:reversi_app/ui/components/winner_dialog.dart';
import 'package:reversi_app/view_model/match_local_view_model.dart';

class MatchLocalScreen extends ConsumerWidget {
  const MatchLocalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchLocalViewModel = ref.read(matchLocalProvider.notifier);

    ref.listen(
      matchLocalProvider.select((state) => state.winner),
      (_, winner) {
        if (winner != 0) {
          showDialog<void>(
            context: context,
            builder: (context) => WinnerDialog(
              winnerName: winner == 1 ? '黒' : '白',
              loserName: winner == 1 ? '白' : '黒',
              winnerScore: winner == 1
                  ? ref.read(matchLocalProvider).blackScore
                  : ref.read(matchLocalProvider).whiteScore,
              loserScore: winner == 1
                  ? ref.read(matchLocalProvider).whiteScore
                  : ref.read(matchLocalProvider).blackScore,
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFCF6E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF6E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'ローカル対人戦',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          TextButton(
            onPressed: matchLocalViewModel.resetGame,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'リセット',
              style: TextStyle(color: Colors.black, fontSize: 16),
              softWrap: false,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // 設定画面の実装はここで行う
            },
          ),
        ],
      ),
      body: const _GameContent(),
    );
  }
}

class _GameContent extends ConsumerWidget {
  const _GameContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(matchLocalProvider);
    final gameViewModel = ref.read(matchLocalProvider.notifier);

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
              onCellTap: gameViewModel.applyMove,
            ),
            if (gameState.showSkipMessage)
              SkipMessage(
                onEnd: gameViewModel.hideSkipMessage,
              ),
          ],
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
