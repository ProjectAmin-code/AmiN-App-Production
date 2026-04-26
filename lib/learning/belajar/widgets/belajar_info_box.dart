import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';
import '../models/belajar_info_box.dart';
import '../models/lesson_theme_variant.dart';

class BelajarInfoBox extends StatelessWidget {
  const BelajarInfoBox({super.key, required this.data, required this.palette});

  final BelajarInfoBoxData data;
  final BelajarThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(BelajarTokens.cardPadding),
      decoration: BoxDecoration(
        color: palette.infoBackground,
        borderRadius: BorderRadius.circular(BelajarTokens.radiusMd),
        border: Border.all(color: palette.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: palette.cardAccent, size: 20),
          const SizedBox(width: BelajarTokens.gapSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: BelajarTokens.fontFamily,
                    fontFamilyFallback: BelajarTokens.fontFallback,
                    fontWeight: BelajarTokens.subtitleWeight,
                    fontSize: BelajarTokens.subtitleFontSize,
                    color: palette.titleColor,
                  ),
                ),
                const SizedBox(height: BelajarTokens.gapXs),
                Text(
                  data.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: BelajarTokens.fontFamily,
                    fontFamilyFallback: BelajarTokens.fontFallback,
                    fontWeight: BelajarTokens.bodyWeight,
                    fontSize: BelajarTokens.bodyFontSize,
                    color: palette.bodyColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
