import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSettings;

  const Controls({Key? key, required this.onReset, required this.onSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onReset,
          child: const Text('リセット'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onSettings,
          child: const Text('設定'),
        ),
      ],
    );
  }
}
