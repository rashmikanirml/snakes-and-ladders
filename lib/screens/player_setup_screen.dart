import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game_provider.dart';
import 'game_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int _playerCount = 2;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      4,
      (int i) => TextEditingController(text: 'Player ${i + 1}'),
    );
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _startGame() async {
    final List<String> names = _controllers
        .take(_playerCount)
        .map((TextEditingController controller) => controller.text.trim())
        .toList();

    for (int i = 0; i < names.length; i++) {
      if (names[i].isEmpty) {
        names[i] = 'Player ${i + 1}';
      }
    }

    final GameProvider provider = context.read<GameProvider>();
    await provider.startNewGame(names);
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Setup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'How many players?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 2, label: Text('2')),
              ButtonSegment<int>(value: 3, label: Text('3')),
              ButtonSegment<int>(value: 4, label: Text('4')),
            ],
            selected: <int>{_playerCount},
            onSelectionChanged: (Set<int> selected) {
              setState(() {
                _playerCount = selected.first;
              });
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Player Names',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < _playerCount; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _controllers[i],
                decoration: InputDecoration(
                  labelText: 'Player ${i + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
