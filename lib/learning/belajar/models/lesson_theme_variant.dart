import 'package:flutter/material.dart';

enum LessonThemeVariant { blue, orange }

class BelajarThemePalette {
  const BelajarThemePalette({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.cardBackground,
    required this.cardAccent,
    required this.titleColor,
    required this.bodyColor,
    required this.noteColor,
    required this.infoBackground,
    required this.infoBorder,
    required this.progressColor,
    required this.progressTrackColor,
    required this.buttonBackground,
    required this.buttonForeground,
    required this.indicatorBackground,
    required this.indicatorForeground,
    required this.tableHeaderBackground,
    required this.tableHeaderForeground,
    required this.tableRowEven,
    required this.tableRowOdd,
    required this.tableBorder,
  });

  final Color backgroundTop;
  final Color backgroundBottom;
  final Color cardBackground;
  final Color cardAccent;
  final Color titleColor;
  final Color bodyColor;
  final Color noteColor;
  final Color infoBackground;
  final Color infoBorder;
  final Color progressColor;
  final Color progressTrackColor;
  final Color buttonBackground;
  final Color buttonForeground;
  final Color indicatorBackground;
  final Color indicatorForeground;
  final Color tableHeaderBackground;
  final Color tableHeaderForeground;
  final Color tableRowEven;
  final Color tableRowOdd;
  final Color tableBorder;
}

class BelajarThemeVariants {
  const BelajarThemeVariants._();

  static const BelajarThemePalette blue = BelajarThemePalette(
    backgroundTop: Color(0xFFEAF5FF),
    backgroundBottom: Color(0xFFD8ECFF),
    cardBackground: Color(0xFFFDFEFF),
    cardAccent: Color(0xFF3B82F6),
    titleColor: Color(0xFF1E3A8A),
    bodyColor: Color(0xFF1F2937),
    noteColor: Color(0xFF334155),
    infoBackground: Color(0xFFEFF6FF),
    infoBorder: Color(0xFFBFDBFE),
    progressColor: Color(0xFF3B82F6),
    progressTrackColor: Color(0xFFDBEAFE),
    buttonBackground: Color(0xFF2563EB),
    buttonForeground: Colors.white,
    indicatorBackground: Color(0xFFE0ECFF),
    indicatorForeground: Color(0xFF1E40AF),
    tableHeaderBackground: Color(0xFF2563EB),
    tableHeaderForeground: Colors.white,
    tableRowEven: Color(0xFFF3F8FF),
    tableRowOdd: Color(0xFFE9F2FF),
    tableBorder: Color(0xFFC4DAF7),
  );

  static const BelajarThemePalette orange = BelajarThemePalette(
    backgroundTop: Color(0xFFFFF4E3),
    backgroundBottom: Color(0xFFFFE7C6),
    cardBackground: Color(0xFFFFFEFC),
    cardAccent: Color(0xFFEA580C),
    titleColor: Color(0xFF9A3412),
    bodyColor: Color(0xFF3F2A1F),
    noteColor: Color(0xFF7C2D12),
    infoBackground: Color(0xFFFFF2DE),
    infoBorder: Color(0xFFFED7AA),
    progressColor: Color(0xFFEA580C),
    progressTrackColor: Color(0xFFFED7AA),
    buttonBackground: Color(0xFFF97316),
    buttonForeground: Colors.white,
    indicatorBackground: Color(0xFFFFE8CF),
    indicatorForeground: Color(0xFF9A3412),
    tableHeaderBackground: Color(0xFFEA580C),
    tableHeaderForeground: Colors.white,
    tableRowEven: Color(0xFFFFF7EE),
    tableRowOdd: Color(0xFFFFF1E3),
    tableBorder: Color(0xFFFAC79A),
  );

  static BelajarThemePalette of(LessonThemeVariant variant) {
    switch (variant) {
      case LessonThemeVariant.blue:
        return blue;
      case LessonThemeVariant.orange:
        return orange;
    }
  }
}
