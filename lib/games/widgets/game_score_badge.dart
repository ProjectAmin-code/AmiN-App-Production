import 'package:flutter/material.dart';

class GameScoreBadge extends StatelessWidget {
  const GameScoreBadge({super.key, required this.score, required this.total});

  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6E4F1)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC300)),
            const SizedBox(width: 3),
            Text(
              '$score / $total',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D3557),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
