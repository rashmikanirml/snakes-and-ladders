import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game_provider.dart';
import 'game_screen.dart';
import 'player_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (BuildContext context, GameProvider provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Snakes and Ladders')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Play Offline with Friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PlayerSetupScreen(),
                      ),
                    );
                  },
                  label: const Text('New Game'),
                ),
                const SizedBox(height: 12),
                if (provider.hasActiveGame)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.restore),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const GameScreen(),
                        ),
                      );
                    },
                    label: const Text('Resume Game'),
                  ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  value: provider.soundEnabled,
                  onChanged: (bool value) {
                    provider.toggleSound(value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
