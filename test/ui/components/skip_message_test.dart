import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reversi_app/ui/components/skip_message.dart';

// 手動でモッククラスを作成
class MockCallable extends Mock {
  void call();
}

void main() {
  group('SkipMessage', () {
    testWidgets('正しくスキップメッセージを表示すること', (WidgetTester tester) async {
      // モックコールバックを作成
      final mockCallback = MockCallable();

      // SkipMessageウィジェットをレンダリング
      await tester.pumpWidget(
        MaterialApp(
          home: SkipMessage(onEnd: mockCallback.call),
        ),
      );

      // 「スキップ」テキストが表示されていることを確認
      expect(find.text('スキップ'), findsOneWidget);

      // スタイルが正しいことを確認
      final textWidget = tester.widget<Text>(find.text('スキップ'));
      expect(textWidget.style?.fontSize, 32);
      expect(textWidget.style?.color, Colors.white);
    });

    testWidgets('アニメーションが実行されること', (WidgetTester tester) async {
      // モックコールバックを作成
      final mockCallback = MockCallable();

      // SkipMessageウィジェットをレンダリング
      await tester.pumpWidget(
        MaterialApp(
          home: SkipMessage(onEnd: mockCallback.call),
        ),
      );

      // 初期状態での不透明度を取得
      final initialOpacity = tester
          .widget<AnimatedOpacity>(
            find.byType(AnimatedOpacity),
          )
          .opacity;

      // アニメーションを進める
      await tester.pump(const Duration(milliseconds: 500));

      // 中間状態の不透明度を取得
      final midOpacity = tester
          .widget<AnimatedOpacity>(
            find.byType(AnimatedOpacity),
          )
          .opacity;

      // 不透明度が変化していることを確認
      expect(midOpacity, lessThan(initialOpacity));

      // アニメーションを完了させる
      await tester.pumpAndSettle();

      // 最終状態の不透明度を取得
      final finalOpacity = tester
          .widget<AnimatedOpacity>(
            find.byType(AnimatedOpacity),
          )
          .opacity;

      // 不透明度が0に近いことを確認
      expect(finalOpacity, lessThanOrEqualTo(0.01));
    });

    testWidgets('アニメーション終了後にonEndが呼ばれること', (WidgetTester tester) async {
      // モックコールバックを作成
      final mockCallback = MockCallable();

      // SkipMessageウィジェットをレンダリング
      await tester.pumpWidget(
        MaterialApp(
          home: SkipMessage(onEnd: mockCallback.call),
        ),
      );

      // アニメーションを完了させる
      await tester.pumpAndSettle();

      // onEndコールバックが1回だけ呼ばれることを確認
      verify(mockCallback.call()).called(1);
    });
  });
}
