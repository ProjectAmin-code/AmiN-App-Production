import 'package:flutter/material.dart';

import 'belajar_animation_type.dart';
import 'belajar_character_config.dart';
import 'belajar_indicator.dart';
import 'belajar_info_box.dart';
import 'belajar_table_content.dart';
import 'lesson_theme_variant.dart';

class BelajarLessonContent {
  const BelajarLessonContent({
    required this.id,
    required this.title,
    required this.descriptionBlocks,
    required this.themeVariant,
    required this.buttonLabel,
    this.infoBox,
    this.indicators = const [],
    this.table,
    this.noteText,
    this.character = const BelajarCharacterConfig.hidden(),
    this.animationType = BelajarAnimationType.none,
    this.buttonIcon = Icons.arrow_forward_rounded,
    this.nextRoute,
  });

  final String id;
  final String title;
  final List<String> descriptionBlocks;
  final BelajarInfoBoxData? infoBox;
  final List<BelajarIndicator> indicators;
  final BelajarTableContent? table;
  final String? noteText;
  final BelajarCharacterConfig character;
  final BelajarAnimationType animationType;
  final LessonThemeVariant themeVariant;
  final String buttonLabel;
  final IconData buttonIcon;
  final String? nextRoute;
}
