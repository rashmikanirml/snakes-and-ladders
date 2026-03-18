import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/game_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SnakesAndLaddersApp());
}

class SnakesAndLaddersApp extends StatelessWidget {
  const SnakesAndLaddersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameProvider>(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Snakes and Ladders',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
