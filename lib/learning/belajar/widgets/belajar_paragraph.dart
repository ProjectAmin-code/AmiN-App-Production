import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';

class BelajarParagraph extends StatelessWidget {
  const BelajarParagraph({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color,
        fontFamily: BelajarTokens.fontFamily,
        fontFamilyFallback: BelajarTokens.fontFallback,
        fontWeight: BelajarTokens.bodyWeight,
        fontSize: BelajarTokens.bodyFontSize,
        height: 1.45,
      ),
    );
  }
}
