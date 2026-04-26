import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';
import '../models/belajar_indicator.dart';
import '../models/lesson_theme_variant.dart';

class BelajarIndicatorRow extends StatelessWidget {
  const BelajarIndicatorRow({
    super.key,
    required this.indicators,
    required this.palette,
  });

  final List<BelajarIndicator> indicators;
  final BelajarThemePalette palette;

  @override
  Widget build(BuildContext context) {
    if (indicators.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: BelajarTokens.gapSm,
      runSpacing: BelajarTokens.gapSm,
      children: indicators.map((indicator) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: BelajarTokens.gapSm,
            vertical: BelajarTokens.gapXs,
          ),
          decoration: BoxDecoration(
            color: palette.indicatorBackground,
            borderRadius: BorderRadius.circular(BelajarTokens.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                indicator.icon,
                size: 16,
                color: palette.indicatorForeground,
              ),
              const SizedBox(width: BelajarTokens.gapXs),
              Text(
                indicator.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: BelajarTokens.fontFamily,
                  fontFamilyFallback: BelajarTokens.fontFallback,
                  fontWeight: BelajarTokens.subtitleWeight,
                  color: palette.indicatorForeground,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
