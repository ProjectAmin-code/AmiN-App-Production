import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';
import '../models/lesson_theme_variant.dart';

class BelajarHeader extends StatelessWidget {
  const BelajarHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.progressValue,
    required this.palette,
    required this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final double progressValue;
  final BelajarThemePalette palette;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: palette.noteColor,
      fontSize: BelajarTokens.progressLabelFontSize,
      fontWeight: BelajarTokens.subtitleWeight,
      fontFamily: BelajarTokens.fontFamily,
      fontFamilyFallback: BelajarTokens.fontFallback,
    );

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: palette.titleColor,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(BelajarTokens.radiusLg),
                child: LinearProgressIndicator(
                  value: progressValue.clamp(0, 1),
                  minHeight: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    palette.progressColor,
                  ),
                  backgroundColor: palette.progressTrackColor,
                ),
              ),
              const SizedBox(height: BelajarTokens.gapXs),
              Text('$currentStep / $totalSteps', style: textStyle),
            ],
          ),
        ),
      ],
    );
  }
}
