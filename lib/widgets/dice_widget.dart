import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  const DiceWidget({
    super.key,
    required this.value,
    required this.onTap,
    required this.isRolling,
  });

  final int value;
  final VoidCallback onTap;
  final bool isRolling;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Roll Dice', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: isRolling ? null : onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: SizedBox(
            width: 90,
            height: 82,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  '$value',
                  key: ValueKey<int>(value),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
