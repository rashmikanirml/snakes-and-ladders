import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Opacity(
                opacity: 0.32,
                child: SvgPicture.asset(
                  'assets/images/snakes_ladders_bg.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Play Offline with Friends',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
                    Card(
                      elevation: 2,
                      child: SwitchListTile(
                        secondary: Icon(
                          provider.soundEnabled
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                        ),
                        title: const Text('Sound Effects'),
                        subtitle: Text(
                          provider.soundEnabled ? 'Enabled' : 'Disabled',
                        ),
                        value: provider.soundEnabled,
                        onChanged: (bool value) {
                          provider.toggleSound(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
