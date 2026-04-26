import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';

class BelajarTitle extends StatelessWidget {
  const BelajarTitle({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: color,
        fontFamily: BelajarTokens.fontFamily,
        fontFamilyFallback: BelajarTokens.fontFallback,
        fontWeight: BelajarTokens.titleWeight,
        fontSize: BelajarTokens.titleFontSize,
        height: 1.2,
      ),
    );
  }
}
