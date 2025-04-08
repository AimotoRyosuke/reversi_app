import 'package:flutter/material.dart';

/// アプリで使用する色を定義するクラス
class AppColors {
  /// ヒント機能の評価値に対応する色定義（21段階）
  static const Map<int, Color> hintScoreColors = {
    100: Color(0xFF0000FF), // 濃い青
    95: Color(0xFF0033FF), // 青
    90: Color(0xFF3333FF), // 青紫
    85: Color(0xFF4169E1), // 藍色
    80: Color(0xFF00BFFF), // 水色
    75: Color(0xFF87CEEB), // スカイブルー
    70: Color(0xFFADD8E6), // 淡い青
    65: Color(0xFF48D1CC), // 青緑
    60: Color(0xFF40E0D0), // ターコイズ
    55: Color(0xFF9370DB), // 紫
    50: Color(0xFFE6E6FA), // ラベンダー
    45: Color(0xFFD8BFD8), // 薄紫
    40: Color(0xFFFFC0CB), // ピンク
    35: Color(0xFFFFFF00), // 黄色
    30: Color(0xFFFFA500), // オレンジ
    25: Color(0xFFFF8C00), // 濃いオレンジ
    20: Color(0xFFFF4500), // 赤橙
    15: Color(0xFFFF6347), // 薄い赤
    10: Color(0xFFFF0000), // 赤
    5: Color(0xFF8B0000), // 暗い赤
    0: Color(0xFF4B0082), // インディゴ（濃い紫）
  };
}
