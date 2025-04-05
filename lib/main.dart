import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'view_model/game_view_model.dart';
import 'ui/game_board.dart';
import 'ui/score.dart';
import 'ui/wood_background.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'オセロ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameViewModel = ref.read(gameProvider.notifier);

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScoreDisplay(
                blackScore: _calculateScore(gameState.board, 1),
                whiteScore: _calculateScore(gameState.board, -1),
              ),
              const Spacer(),
              GameBoardWidget(
                board: gameState.board,
                validMoves: gameState.validMoves,
                onCellTap: (row, col) {
                  gameViewModel.applyMove(row, col);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateScore(List<List<int>> board, int player) {
    int score = 0;
    for (var row in board) {
      for (var cell in row) {
        if (cell == player) score++;
      }
    }
    return score;
  }
}
