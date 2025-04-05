import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/ui/game_board.dart';
import 'package:reversi_app/ui/score.dart';
import 'package:reversi_app/ui/skip_message.dart';
import 'package:reversi_app/ui/winner_dialog.dart';
import 'package:reversi_app/view_model/cpu_game_view_model.dart';

class CpuGameScreen extends ConsumerStatefulWidget {
  const CpuGameScreen({super.key});

  @override
  ConsumerState<CpuGameScreen> createState() => _CpuGameScreenState();
}

class _GameSettings {
  _GameSettings({
    required this.playerChoice,
    required this.difficultyLevel,
  });
  final PlayerChoice playerChoice;
  final DifficultyLevel difficultyLevel;
}

class _CpuGameScreenState extends ConsumerState<CpuGameScreen> {
  @override
  void initState() {
    super.initState();
    // 表示後すぐに設定ダイアログを表示する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGameSettingsDialog();
    });
  }

  Future<void> _showGameSettingsDialog() async {
    final defaultPiece = ref.read(cpuGameProvider).playerChoice;
    final defaultDifficulty = ref.read(cpuGameProvider).difficulty;
    final settings = await showDialog<_GameSettings>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _GameSettingsDialog(
          defaultPiece: defaultPiece,
          defaultDifficulty: defaultDifficulty,
        );
      },
    );

    if (settings != null) {
      ref.read(cpuGameProvider.notifier).startGameWithChoice(
            settings.playerChoice,
            settings.difficultyLevel,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cpuState = ref.watch(cpuGameProvider);

    // CPU対戦での勝者が決まったらダイアログ表示
    ref.listen(
      cpuGameProvider.select((state) => state.winner),
      (_, winner) {
        if (winner != 0) {
          showDialog<void>(
            context: context,
            builder: (context) => WinnerDialog(
              winnerName: winner == 1 ? '黒' : '白',
              loserName: winner == 1 ? '白' : '黒',
              winnerScore:
                  winner == 1 ? cpuState.blackScore : cpuState.whiteScore,
              loserScore:
                  winner == 1 ? cpuState.whiteScore : cpuState.blackScore,
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFCF6E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF6E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'オセロ',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          TextButton(
            onPressed: _showGameSettingsDialog,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: const Text(
              'リセット',
              style: TextStyle(color: Colors.black, fontSize: 16),
              softWrap: false,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // 設定画面の実装はここで行う
            },
          ),
        ],
      ),
      body: const _GameContent(),
    );
  }
}

class _GameSettingsDialog extends StatefulWidget {
  const _GameSettingsDialog({
    required this.defaultPiece,
    required this.defaultDifficulty,
  });
  @override
  State<_GameSettingsDialog> createState() => _GameSettingsDialogState();
  final PlayerChoice defaultPiece;
  final DifficultyLevel defaultDifficulty;
}

class _GameSettingsDialogState extends State<_GameSettingsDialog> {
  late PlayerChoice _selectedPiece;
  late DifficultyLevel _selectedDifficulty;

  @override
  void initState() {
    setState(() {
      _selectedPiece = widget.defaultPiece;
      _selectedDifficulty = widget.defaultDifficulty;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ゲーム設定',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '駒の選択',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPieceOption(PlayerChoice.black, '黒'),
                _buildPieceOption(PlayerChoice.white, '白'),
                _buildPieceOption(PlayerChoice.random, 'ランダム'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '難易度',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDifficultyOption(DifficultyLevel.easy, '初級'),
                _buildDifficultyOption(DifficultyLevel.medium, '中級'),
                _buildDifficultyOption(DifficultyLevel.difficult, '上級'),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop();
                  },
                  child: const Text(
                    'キャンセル',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      _GameSettings(
                        playerChoice: _selectedPiece,
                        difficultyLevel: _selectedDifficulty,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'スタート',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieceOption(PlayerChoice choice, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPiece = choice;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedPiece == choice ? Colors.blue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _selectedPiece == choice
                  ? Colors.blue.withOpacity(0.1)
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: _selectedPiece == choice
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyOption(DifficultyLevel difficulty, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedDifficulty = difficulty;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedDifficulty == difficulty
                    ? Colors.blue
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _selectedDifficulty == difficulty
                  ? Colors.blue.withOpacity(0.1)
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: _selectedDifficulty == difficulty
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameContent extends ConsumerWidget {
  const _GameContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cpuState = ref.watch(cpuGameProvider);
    final cpuViewModel = ref.read(cpuGameProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScoreDisplay(
          blackScore: cpuState.blackScore,
          whiteScore: cpuState.whiteScore,
        ),
        const Spacer(flex: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    cpuState.currentPlayer == 1 ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              cpuState.currentPlayer == 1 ? '黒のターン' : '白のターン',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            GameBoardWidget(
              board: cpuState.board,
              validMoves: cpuState.validMoves,
              player: cpuState.currentPlayer,
              onCellTap: cpuViewModel.applyMove,
            ),
            if (cpuState.showSkipMessage)
              SkipMessage(
                onEnd: cpuViewModel.hideSkipMessage,
              ),
          ],
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
