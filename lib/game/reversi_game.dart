import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ReversiGame extends FlameGame {
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.green;
    // Draw a green background covering the entire game canvas
    canvas.drawRect(Offset.zero & size.toSize(), paint);
  }

  @override
  void update(double dt) {
    // Update game state here
  }
}
