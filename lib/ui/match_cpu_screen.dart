import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/models/hint_settings.dart';
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
    required this.hintSettings,
  });
  final PlayerChoice playerChoice;
  final CpuDifficulty difficultyLevel;
  final HintSettings hintSettings;
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
    final defaultHintSettings = ref.read(matchCpuProvider).hintSettings;
    final settings = await showDialog<_GameSettings>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _GameSettingsDialog(
          defaultPiece: defaultPiece,
          defaultDifficulty: defaultDifficulty,
          defaultHintSettings: defaultHintSettings,
        );
      },
    );

    if (settings != null) {
      ref.read(matchCpuProvider.notifier).startGameWithChoice(
            settings.playerChoice,
            settings.difficultyLevel,
            settings.hintSettings,
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
    required this.defaultHintSettings,
  });
  final PlayerChoice defaultPiece;
  final CpuDifficulty defaultDifficulty;
  final HintSettings defaultHintSettings;

  @override
  State<_GameSettingsDialog> createState() => _GameSettingsDialogState();
}

class _GameSettingsDialogState extends State<_GameSettingsDialog> {
  late PlayerChoice _selectedPiece;
  late CpuDifficulty _selectedDifficulty;
  late HintDisplayMode _selectedHintMode;
  late int _selectedDepth;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedPiece = widget.defaultPiece;
      _selectedDifficulty = widget.defaultDifficulty;
      _selectedHintMode = widget.defaultHintSettings.displayMode;
      _selectedDepth = widget.defaultHintSettings.minimaxDepth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ゲーム設定',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              '持ち駒を選択',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPieceOption(PlayerChoice.black, '黒（先手）'),
                const SizedBox(width: 8),
                _buildPieceOption(PlayerChoice.white, '白（後手）'),
                const SizedBox(width: 8),
                _buildPieceOption(PlayerChoice.random, 'ランダム'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'CPUの強さ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDifficultyOption(CpuDifficulty.easy, '初級'),
                const SizedBox(width: 8),
                _buildDifficultyOption(CpuDifficulty.medium, '中級'),
                const SizedBox(width: 8),
                _buildDifficultyOption(CpuDifficulty.hard, '上級'),
                const SizedBox(width: 8),
                _buildDifficultyOption(CpuDifficulty.veryHard, '超級'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'ヒント表示',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildHintOption(HintDisplayMode.none, '非表示'),
                const SizedBox(width: 8),
                _buildHintOption(HintDisplayMode.colorOnly, '色のみ'),
                const SizedBox(width: 8),
                _buildHintOption(HintDisplayMode.number, '数値'),
              ],
            ),
            if (_selectedHintMode != HintDisplayMode.none) ...[
              const SizedBox(height: 16),
              const Text(
                '先読みの深さ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('浅い'),
                  Expanded(
                    child: Slider(
                      value: _selectedDepth.toDouble(),
                      min: 2,
                      max: 6,
                      divisions: 4,
                      label: _selectedDepth.toString(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDepth = value.toInt();
                        });
                      },
                    ),
                  ),
                  const Text('深い'),
                ],
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  _GameSettings(
                    playerChoice: _selectedPiece,
                    difficultyLevel: _selectedDifficulty,
                    hintSettings: HintSettings(
                      displayMode: _selectedHintMode,
                      minimaxDepth: _selectedDepth,
                    ),
                  ),
                );
              },
              child: const Text('開始'),
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
        child: ChoiceChip(
          label: Text(label),
          selected: _selectedPiece == choice,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedPiece = choice;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDifficultyOption(CpuDifficulty difficulty, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ChoiceChip(
          label: Text(label),
          selected: _selectedDifficulty == difficulty,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedDifficulty = difficulty;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildHintOption(HintDisplayMode mode, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(
          label: Text(label),
          selected: _selectedHintMode == mode,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedHintMode = mode;
              });
            }
          },
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
                hintSettings: cpuState.hintSettings,
                hintEvaluations: cpuState.hintEvaluations,
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
