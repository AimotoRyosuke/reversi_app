import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SkipMessage extends HookWidget {
  const SkipMessage({required this.onEnd, super.key});
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 1),
    )..forward();

    final opacity = 1.0 - useAnimation(animationController);

    return AnimatedOpacity(
      opacity: opacity,
      onEnd: () async {
        onEnd();
      },
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black87,
        child: const Text(
          'スキップ',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}
