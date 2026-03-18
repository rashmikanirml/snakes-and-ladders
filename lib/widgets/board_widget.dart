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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: Opacity(
                opacity: 0.88,
                child: SvgPicture.asset(
                  'assets/images/snakes_ladders_bg.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _SnakesAndLaddersPainter()),
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
                    ? const Color(0x40FFFFFF)
                    : const Color(0x33FFFDE7);

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF8D6E63),
                      width: 0.65,
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
                        Icon(
                          jumpTarget > position ? Icons.north : Icons.south,
                          size: 12,
                          color: jumpTarget > position
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      const Spacer(),
                      if (playersHere.isNotEmpty)
                        Wrap(
                          spacing: 3,
                          runSpacing: 3,
                          children: playersHere
                              .map(
                                (Player player) => Container(
                                  width: 11,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: Color(player.colorValue),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.7,
                                    ),
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

class _SnakesAndLaddersPainter extends CustomPainter {
  const _SnakesAndLaddersPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double cell = size.width / BoardConfig.boardSize;

    for (final MapEntry<int, int> entry
        in BoardConfig.snakesAndLadders.entries) {
      final int start = entry.key;
      final int end = entry.value;
      final Offset a = _cellCenter(start, cell);
      final Offset b = _cellCenter(end, cell);

      if (end > start) {
        _drawLadder(canvas, a, b);
      } else {
        _drawSnake(canvas, a, b);
      }
    }
  }

  Offset _cellCenter(int position, double cell) {
    final int zero = position - 1;
    final int rowFromBottom = zero ~/ BoardConfig.boardSize;
    final int col = zero % BoardConfig.boardSize;
    final bool leftToRight = rowFromBottom.isEven;
    final int visualCol = leftToRight ? col : (BoardConfig.boardSize - 1 - col);
    final int rowFromTop = BoardConfig.boardSize - 1 - rowFromBottom;

    return Offset((visualCol + 0.5) * cell, (rowFromTop + 0.5) * cell);
  }

  void _drawLadder(Canvas canvas, Offset start, Offset end) {
    final Offset direction = (end - start);
    final double length = direction.distance;
    if (length == 0) {
      return;
    }
    final Offset unit = Offset(direction.dx / length, direction.dy / length);
    final Offset perp = Offset(-unit.dy, unit.dx);
    const double halfWidth = 6;

    final Paint rail = Paint()
      ..color = const Color(0xFF6D4C41)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final Paint rung = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final Offset s1 = start + perp * halfWidth;
    final Offset s2 = start - perp * halfWidth;
    final Offset e1 = end + perp * halfWidth;
    final Offset e2 = end - perp * halfWidth;

    canvas.drawLine(s1, e1, rail);
    canvas.drawLine(s2, e2, rail);

    for (double t = 0.2; t <= 0.8; t += 0.2) {
      final Offset p1 = Offset.lerp(s1, e1, t)!;
      final Offset p2 = Offset.lerp(s2, e2, t)!;
      canvas.drawLine(p1, p2, rung);
    }
  }

  void _drawSnake(Canvas canvas, Offset start, Offset end) {
    final Offset mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final Offset delta = end - start;
    final double distance = delta.distance;
    final Offset bend = distance == 0
        ? Offset.zero
        : Offset(-delta.dy / distance, delta.dx / distance) * 18;

    final Path body = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(mid.dx + bend.dx, mid.dy + bend.dy, end.dx, end.dy);

    final Paint outlinePaint = Paint()
      ..color = const Color(0xCC000000)
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint bodyPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint headPaint = Paint()..color = const Color(0xFFB71C1C);
    final Paint eyePaint = Paint()..color = Colors.white;

    canvas.drawPath(body, outlinePaint);
    canvas.drawPath(body, bodyPaint);
    canvas.drawCircle(end, 7.2, headPaint);
    canvas.drawCircle(Offset(end.dx - 2.2, end.dy - 1.8), 1.1, eyePaint);
    canvas.drawCircle(Offset(end.dx + 2.2, end.dy - 1.8), 1.1, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
