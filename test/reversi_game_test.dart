import 'package:flutter_test/flutter_test.dart';
import 'package:reversi_app/game/reversi_game.dart';

void main() {
  test('ReversiGame update test', () {
    final game = ReversiGame();
    // Call update to ensure it runs without errors.
    game.update(0.1);
    expect(true, isTrue);
  });
}
