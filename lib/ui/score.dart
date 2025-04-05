import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int blackScore;
  final int whiteScore;

  const ScoreDisplay({Key? key, this.blackScore = 0, this.whiteScore = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '黒: $blackScore',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        const SizedBox(width: 20),
        Text(
          '白: $whiteScore',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }
}
