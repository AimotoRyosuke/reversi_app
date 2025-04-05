import 'dart:math';
import 'package:flutter/material.dart';

class WoodBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 淡い色合いの背景グラデーション（木の色合い）を描画
    final rect = Offset.zero & size;
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFEBCD), Color(0xFFF5DEB3)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // 縦方向の木目模様を描画
    final linePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final random = Random();
    // X軸方向に一定間隔で縦線を描画
    for (var x = 20.0; x < size.width; x += 40.0) {
      final path = Path()..moveTo(x, 0);
      // Y軸方向に進む際、X座標にランダムなオフセットを加えて自然な縦線の変化を表現
      for (double y = 0; y <= size.height; y += 20) {
        final offsetX = random.nextDouble() * 10 - 5; // -5〜+5 のオフセット
        path.lineTo(x + offsetX, y);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
