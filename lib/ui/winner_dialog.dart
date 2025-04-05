import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/view_model/game_view_model.dart';

class WinnerDialog extends ConsumerWidget {
  const WinnerDialog({
    required this.winnerName,
    required this.loserName,
    required this.winnerScore,
    required this.loserScore,
    super.key,
  });
  final String winnerName;
  final String loserName;
  final int winnerScore;
  final int loserScore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 16),
              Text(
                '$loserName: $loserScore',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(gameProvider.notifier).resetGame();
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
