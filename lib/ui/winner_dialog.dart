import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../view_model/game_view_model.dart';

class WinnerDialog extends StatelessWidget {
  final String winnerName;
  final String loserName;
  final int winnerScore;
  final int loserScore;

  const WinnerDialog({
    super.key,
    required this.winnerName,
    required this.loserName,
    required this.winnerScore,
    required this.loserScore,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ゲーム終了'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$winnerName の勝利です！',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$winnerName: $winnerScore',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 16),
              Text(
                '$loserName: $loserScore',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            final gameViewModel =
                ProviderScope.containerOf(context).read(gameProvider.notifier);
            gameViewModel.resetGame();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
