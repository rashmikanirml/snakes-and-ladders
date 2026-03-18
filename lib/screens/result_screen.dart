import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game_provider.dart';
import 'home_screen.dart';
import 'player_setup_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.winnerName});

  final String winnerName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
              const SizedBox(height: 14),
              Text(
                '$winnerName wins!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const PlayerSetupScreen(),
                    ),
                    (_) => false,
                  );
                },
                child: const Text('Play Again'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  await context.read<GameProvider>().resetGame();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                    (_) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
