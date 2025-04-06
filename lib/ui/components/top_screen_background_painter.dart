import 'package:flutter/material.dart';

class TopScreenBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.green.shade200, Colors.teal.shade700],
        radius: 1,
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 3),
          radius: size.width,
        ),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final piecePaint = Paint();

    for (var y = size.height / 4; y < size.height; y += size.height / 4) {
      for (var x = size.width / 4; x < size.width; x += size.width / 4) {
        piecePaint.color =
            ((x ~/ (size.width / 4)) % 2 == (y ~/ (size.height / 4)) % 2)
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.black.withValues(alpha: 0.8);
        canvas.drawCircle(
          Offset(x, y),
          size.width / 10,
          piecePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
