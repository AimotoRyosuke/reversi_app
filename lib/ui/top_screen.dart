import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reversi_app/routes.dart';
import 'package:reversi_app/ui/top_screen_background_painter.dart';

class TopScreen extends StatelessWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: TopScreenBackgroundPainter(),
          size: Size.infinite,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                Card(
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      context.push(Routes.cpu);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.computer, size: 48),
                        SizedBox(height: 8),
                        Text('CPU対戦', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      context.push(Routes.local);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 48),
                        SizedBox(height: 8),
                        Text('ローカル対人戦', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      context.push(Routes.online);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi, size: 48),
                        SizedBox(height: 8),
                        Text('オンライン対人戦', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      context.push(Routes.settings);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings, size: 48),
                        SizedBox(height: 8),
                        Text('設定', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
