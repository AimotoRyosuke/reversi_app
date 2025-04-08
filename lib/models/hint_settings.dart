import 'package:freezed_annotation/freezed_annotation.dart';

part 'hint_settings.freezed.dart';

/// ヒント表示モード
enum HintDisplayMode {
  /// 非表示
  none,

  /// 色のみ表示（小さい円）
  colorOnly,

  /// 数値表示
  number,
}

/// ヒント機能の設定を管理するモデル
@freezed
class HintSettings with _$HintSettings {
  const factory HintSettings({
    /// ヒント表示モード
    @Default(HintDisplayMode.none) HintDisplayMode displayMode,
    
    /// ミニマックスアルゴリズムの深さ
    @Default(4) int minimaxDepth,
  }) = _HintSettings;
}
