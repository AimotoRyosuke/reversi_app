import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_app/routes.dart';
import 'package:reversi_app/ui/match_cpu_screen.dart';
import 'package:reversi_app/ui/match_local_screen.dart';
import 'package:reversi_app/ui/top_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    // Initialize router only once to preserve navigation state on hot reload.
    router = GoRouter(
      initialLocation: Routes.top,
      routes: [
        GoRoute(
          path: Routes.top,
          builder: (context, state) => const TopScreen(),
        ),
        GoRoute(
          path: Routes.local,
          builder: (context, state) => const MatchLocalScreen(),
        ),
        GoRoute(
          path: Routes.cpu,
          builder: (context, state) => const MatchCpuScreen(),
        ),
        GoRoute(
          path: Routes.online,
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: Routes.settings,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'オセロ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
