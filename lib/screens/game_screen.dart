import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/game_provider.dart';
import '../models/player.dart';
import '../widgets/board_widget.dart';
import '../widgets/dice_widget.dart';
import 'home_screen.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (BuildContext context, GameProvider provider, _) {
        if (provider.players.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Game')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                    (_) => false,
                  );
                },
                child: const Text('No active game. Go Home'),
              ),
            ),
          );
        }

        final int? winnerIndex = provider.winnerIndex;
        if (winnerIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => ResultScreen(
                  winnerName: provider.players[winnerIndex].name,
                ),
              ),
            );
          });
        }

        final Player currentPlayer = provider.currentPlayer!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Game'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                Expanded(child: BoardWidget(players: provider.players)),
                const SizedBox(height: 12),
                Text(
                  'Turn: ${currentPlayer.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text('Last Dice: ${provider.lastDiceValue}'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 84,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.players.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final Player player = provider.players[index];
                      final bool isCurrent =
                          index == provider.currentPlayerIndex;
                      return Container(
                        width: 132,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFFE3F2FD)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrent
                                ? const Color(0xFF1976D2)
                                : const Color(0xFFCFD8DC),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(player.colorValue),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    player.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Pos: ${player.position}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                DiceWidget(
                  value: provider.lastDiceValue,
                  isRolling: provider.isRolling,
                  onTap: provider.rollDice,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
