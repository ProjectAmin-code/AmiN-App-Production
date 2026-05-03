import 'package:flutter/material.dart';

enum LearningStepType {
  equationExamples,
  arrowExamples,
  table,
  changeCards,
  levelTransition,
  situation,
  summary,
  quizGateway,
}

class LearningRuleRow {
  const LearningRuleRow({required this.cells, this.backgroundColor});

  final List<String> cells;
  final Color? backgroundColor;
}

class LearningEquationExample {
  const LearningEquationExample({
    required this.left,
    required this.middle,
    required this.right,
    this.leftColor = const Color(0xFFFACC15),
    this.middleColor = const Color(0xFF0EA5E9),
    this.rightColor = const Color(0xFF4CAF50),
  });

  final String left;
  final String middle;
  final String right;
  final Color leftColor;
  final Color middleColor;
  final Color rightColor;
}

class LearningColorLegend {
  const LearningColorLegend({
    required this.color,
    required this.name,
    required this.description,
  });

  final Color color;
  final String name;
  final String description;
}

class LearningArrowRow {
  const LearningArrowRow({
    required this.letter,
    required this.baseWord,
    required this.derivedWord,
  });

  final String letter;
  final String baseWord;
  final String derivedWord;
}

class LearningChangeCard {
  const LearningChangeCard({
    required this.letter,
    required this.example,
    required this.note,
    this.accentColor = const Color(0xFF0B7285),
  });

  final String letter;
  final String example;
  final String note;
  final Color accentColor;
}

class LearningHotspot {
  const LearningHotspot({
    required this.label,
    required this.baseWord,
    required this.derivedWord,
    required this.alignment,
    this.icon = Icons.star_rounded,
    this.ruleNote = '',
  });

  final String label;
  final String baseWord;
  final String derivedWord;
  final Alignment alignment;
  final IconData icon;
  final String ruleNote;
}

class LearningSummaryCard {
  const LearningSummaryCard({
    required this.prefix,
    required this.ruleText,
    required this.example,
  });

  final String prefix;
  final String ruleText;
  final String example;
}

class LearningStep {
  const LearningStep({
    required this.id,
    required this.title,
    required this.type,
    this.subtitle = '',
    this.voiceScript = '',
    this.buttonText = 'Teruskan',
    this.backgroundTop = const Color(0xFFE7F8FF),
    this.backgroundBottom = const Color(0xFFC7EDFF),
    this.backgroundImage,
    this.tableHeaders = const [],
    this.tableRows = const [],
    this.footerNote = '',
    this.changeCards = const [],
    this.hotspots = const [],
    this.summaryCards = const [],
    this.sceneImageAsset = '',
    this.instructionTitle = '',
    this.instructionBody = '',
    this.exampleSubheading = '',
    this.equationExamples = const [],
    this.colorLegends = const [],
    this.highlightedLetters = const [],
    this.afterHighlightLine = '',
    this.arrowRows = const [],
    this.highlightedPrefix = 'me',
  });

  final String id;
  final String title;
  final String subtitle;
  final String voiceScript;
  final String buttonText;
  final LearningStepType type;
  final Color backgroundTop;
  final Color backgroundBottom;
  final String? backgroundImage;
  final List<String> tableHeaders;
  final List<LearningRuleRow> tableRows;
  final String footerNote;
  final List<LearningChangeCard> changeCards;
  final List<LearningHotspot> hotspots;
  final List<LearningSummaryCard> summaryCards;
  final String sceneImageAsset;
  final String instructionTitle;
  final String instructionBody;
  final String exampleSubheading;
  final List<LearningEquationExample> equationExamples;
  final List<LearningColorLegend> colorLegends;
  final List<String> highlightedLetters;
  final String afterHighlightLine;
  final List<LearningArrowRow> arrowRows;
  final String highlightedPrefix;
}
