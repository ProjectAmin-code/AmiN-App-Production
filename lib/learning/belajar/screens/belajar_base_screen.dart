import 'package:flutter/material.dart';

import '../constants/belajar_tokens.dart';
import '../models/belajar_lesson_content.dart';
import '../models/lesson_theme_variant.dart';
import '../widgets/belajar_animated_content.dart';
import '../widgets/belajar_character.dart';
import '../widgets/belajar_header.dart';
import '../widgets/belajar_indicator_row.dart';
import '../widgets/belajar_info_box.dart';
import '../widgets/belajar_paragraph.dart';
import '../widgets/belajar_primary_button.dart';
import '../widgets/belajar_table.dart';
import '../widgets/belajar_title.dart';

class BelajarBaseScreen extends StatelessWidget {
  const BelajarBaseScreen({
    super.key,
    required this.lesson,
    required this.palette,
    required this.currentStep,
    required this.totalSteps,
    required this.progressValue,
    required this.onBack,
    required this.onContinue,
  });

  final BelajarLessonContent lesson;
  final BelajarThemePalette palette;
  final int currentStep;
  final int totalSteps;
  final double progressValue;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= BelajarTokens.tabletWidthBreakpoint;
    final contentMaxWidth = isTablet
        ? BelajarTokens.contentMaxWidthTablet
        : BelajarTokens.contentMaxWidthPhone;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.backgroundTop, palette.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              BelajarTokens.screenHorizontalPadding,
              BelajarTokens.screenTopPadding,
              BelajarTokens.screenHorizontalPadding,
              BelajarTokens.screenBottomPadding,
            ),
            child: Column(
              children: [
                BelajarHeader(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  progressValue: progressValue,
                  palette: palette,
                  onBack: onBack,
                ),
                const SizedBox(height: BelajarTokens.gapMd),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: palette.cardBackground.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(
                            BelajarTokens.radiusLg,
                          ),
                          border: Border.all(
                            color: palette.cardAccent.withValues(alpha: 0.4),
                            width: BelajarTokens.cardBorderWidth,
                          ),
                          boxShadow: BelajarTokens.cardShadow,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            BelajarTokens.cardPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BelajarAnimatedContent(
                                animationType: lesson.animationType,
                                child: BelajarTitle(
                                  title: lesson.title,
                                  color: palette.titleColor,
                                ),
                              ),
                              const SizedBox(height: BelajarTokens.gapMd),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: _buildScrollableSection(context),
                                ),
                              ),
                              BelajarCharacter(
                                character: lesson.character,
                                animationType: lesson.animationType,
                              ),
                              const SizedBox(height: BelajarTokens.gapMd),
                              BelajarPrimaryButton(
                                label: lesson.buttonLabel,
                                icon: lesson.buttonIcon,
                                onPressed: onContinue,
                                palette: palette,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableSection(BuildContext context) {
    final sections = <Widget>[];
    var index = 0;

    void addSection(Widget child) {
      sections.add(
        BelajarAnimatedContent(
          animationType: lesson.animationType,
          delay: Duration(milliseconds: 70 * index),
          child: child,
        ),
      );
      sections.add(const SizedBox(height: BelajarTokens.gapMd));
      index += 1;
    }

    for (final paragraph in lesson.descriptionBlocks) {
      addSection(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(BelajarTokens.cardPadding),
          decoration: BoxDecoration(
            color: palette.infoBackground.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(BelajarTokens.radiusSm),
            border: Border.all(
              color: palette.infoBorder.withValues(alpha: 0.9),
            ),
          ),
          child: BelajarParagraph(text: paragraph, color: palette.bodyColor),
        ),
      );
    }

    if (lesson.infoBox != null) {
      addSection(BelajarInfoBox(data: lesson.infoBox!, palette: palette));
    }

    if (lesson.indicators.isNotEmpty) {
      addSection(
        BelajarIndicatorRow(indicators: lesson.indicators, palette: palette),
      );
    }

    if (lesson.table != null && !lesson.table!.isEmpty) {
      addSection(BelajarTable(table: lesson.table!, palette: palette));
    }

    if (lesson.noteText != null && lesson.noteText!.trim().isNotEmpty) {
      addSection(
        Text(
          lesson.noteText!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: BelajarTokens.fontFamily,
            fontFamilyFallback: BelajarTokens.fontFallback,
            fontWeight: BelajarTokens.noteWeight,
            fontSize: BelajarTokens.noteFontSize,
            color: palette.noteColor,
            height: 1.4,
          ),
        ),
      );
    }

    if (sections.isNotEmpty) {
      sections.removeLast();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }
}
