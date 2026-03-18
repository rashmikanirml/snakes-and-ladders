import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../logic/board_config.dart';
import '../models/player.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key, required this.players});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final List<int> cellNumbers = _buildSerpentineCells();

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Opacity(
                opacity: 0.45,
                child: SvgPicture.asset(
                  'assets/images/snakes_ladders_bg.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: BoardConfig.winningPosition,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: BoardConfig.boardSize,
            ),
            itemBuilder: (BuildContext context, int index) {
              final int position = cellNumbers[index];
              final int? jumpTarget = BoardConfig.snakesAndLadders[position];
              final List<Player> playersHere = players
                  .where((Player player) => player.position == position)
                  .toList();

              final Color tileColor =
                  (index + (index ~/ BoardConfig.boardSize)) % 2 == 0
                  ? const Color(0x99FFF8E1)
                  : const Color(0x99FFECB3);

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFBCAAA4),
                    width: 0.5,
                  ),
                  color: tileColor,
                ),
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$position',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (jumpTarget != null)
                      Text(
                        jumpTarget > position
                            ? 'L:$jumpTarget'
                            : 'S:$jumpTarget',
                        style: TextStyle(
                          fontSize: 9,
                          color: jumpTarget > position
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const Spacer(),
                    if (playersHere.isNotEmpty)
                      Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: playersHere
                            .map(
                              (Player player) => Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Color(player.colorValue),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<int> _buildSerpentineCells() {
    final List<int> cells = <int>[];

    for (int row = BoardConfig.boardSize - 1; row >= 0; row--) {
      final int start = row * BoardConfig.boardSize + 1;
      final int end = start + BoardConfig.boardSize - 1;
      final bool leftToRight = (BoardConfig.boardSize - 1 - row).isEven;

      if (leftToRight) {
        for (int value = start; value <= end; value++) {
          cells.add(value);
        }
      } else {
        for (int value = end; value >= start; value--) {
          cells.add(value);
        }
      }
    }

    return cells;
  }
}
