import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/ui/components/game_board.dart';
import 'package:reversi_app/ui/components/score.dart';
import 'package:reversi_app/ui/components/skip_message.dart';
import 'package:reversi_app/ui/components/winner_dialog.dart';
import 'package:reversi_app/view_model/match_cpu_view_model.dart';

class MatchCpuScreen extends ConsumerStatefulWidget {
  const MatchCpuScreen({super.key});

  @override
  ConsumerState<MatchCpuScreen> createState() => _MatchCpuScreenState();
}

class _GameSettings {
  _GameSettings({
    required this.playerChoice,
    required this.difficultyLevel,
  });
  final PlayerChoice playerChoice;
  final CpuDifficulty difficultyLevel;
}

class _MatchCpuScreenState extends ConsumerState<MatchCpuScreen> {
  @override
  void initState() {
    super.initState();
    // 表示後すぐに設定ダイアログを表示する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGameSettingsDialog();
    });
  }

  Future<void> _showGameSettingsDialog() async {
    final defaultPiece = ref.read(matchCpuProvider).playerChoice;
    final defaultDifficulty = ref.read(matchCpuProvider).difficulty;
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
      ref.read(matchCpuProvider.notifier).startGameWithChoice(
            settings.playerChoice,
            settings.difficultyLevel,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cpuState = ref.watch(matchCpuProvider);

    // CPU対戦での勝者が決まったらダイアログ表示
    ref.listen(
      matchCpuProvider.select((s) => s.winner),
      (_, winner) {
        final yourPiece = cpuState.playerPiece;
        final isWinner = winner == yourPiece;
        if (winner != 0) {
          showDialog<void>(
            context: context,
            builder: (context) => WinnerDialog(
              winnerName: isWinner ? 'あなた' : 'CPU',
              loserName: !isWinner ? 'あなた' : 'CPU',
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
          'CPU対戦',
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
  final CpuDifficulty defaultDifficulty;
}

class _GameSettingsDialogState extends State<_GameSettingsDialog> {
  late PlayerChoice _selectedPiece;
  late CpuDifficulty _selectedDifficulty;

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
                _buildDifficultyOption(CpuDifficulty.easy, '初級'),
                _buildDifficultyOption(CpuDifficulty.medium, '中級'),
                _buildDifficultyOption(CpuDifficulty.hard, '上級'),
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
                  ? Colors.blue.withValues(alpha: 0.1)
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

  Widget _buildDifficultyOption(CpuDifficulty difficulty, String label) {
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
                  ? Colors.blue.withValues(alpha: 0.1)
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
    final cpuState = ref.watch(matchCpuProvider);
    final cpuViewModel = ref.read(matchCpuProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScoreDisplay(
          blackScore: cpuState.blackScore,
          whiteScore: cpuState.whiteScore,
        ),
        const Spacer(),
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
                border: Border.all(
                  color: cpuState.currentPlayer == 1
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              cpuState.currentPlayer == cpuState.playerPiece
                  ? 'あなたのターン'
                  : 'CPUのターン',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GameBoardWidget(
                board: cpuState.board,
                validMoves: cpuState.validMoves,
                player: cpuState.currentPlayer,
                onCellTap: cpuViewModel.applyMove,
              ),
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
