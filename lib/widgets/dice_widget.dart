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
    return ElevatedButton(
      onPressed: isRolling ? null : onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: SizedBox(
        width: 74,
        height: 74,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              '$value',
              key: ValueKey<int>(value),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
    );
  }
}
