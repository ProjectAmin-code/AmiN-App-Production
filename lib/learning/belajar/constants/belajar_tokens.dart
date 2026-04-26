import 'package:flutter/material.dart';

class BelajarTokens {
  const BelajarTokens._();

  static const String fontFamily = 'Poppins';
  static const List<String> fontFallback = ['Roboto', 'Noto Sans', 'Arial'];

  static const FontWeight titleWeight = FontWeight.w900;
  static const FontWeight subtitleWeight = FontWeight.w700;
  static const FontWeight bodyWeight = FontWeight.w600;
  static const FontWeight noteWeight = FontWeight.w600;
  static const FontWeight tableHeaderWeight = FontWeight.w800;
  static const FontWeight tableCellWeight = FontWeight.w600;
  static const FontWeight buttonWeight = FontWeight.w800;

  static const double titleFontSize = 25;
  static const double subtitleFontSize = 20;
  static const double bodyFontSize = 19;
  static const double noteFontSize = 17;
  static const double tableHeaderFontSize = 16;
  static const double tableCellFontSize = 15;
  static const double buttonFontSize = 18;
  static const double progressLabelFontSize = 13;

  static const double buttonHeight = 56;
  static const double buttonMaxWidth = 360;

  static const double radiusXs = 10;
  static const double radiusSm = 14;
  static const double radiusMd = 18;
  static const double radiusLg = 24;

  static const double screenHorizontalPadding = 14;
  static const double screenTopPadding = 8;
  static const double screenBottomPadding = 14;
  static const double cardPadding = 16;
  static const double tableCellHorizontalPadding = 10;
  static const double tableCellVerticalPadding = 10;

  static const double gapXs = 6;
  static const double gapSm = 10;
  static const double gapMd = 14;
  static const double gapLg = 18;

  static const double cardBorderWidth = 1.2;
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x220A2744), blurRadius: 12, offset: Offset(0, 6)),
  ];

  static const Duration fadeDuration = Duration(milliseconds: 280);
  static const Duration slideDuration = Duration(milliseconds: 320);
  static const Duration scaleDuration = Duration(milliseconds: 280);
  static const Duration mascotIdleDuration = Duration(milliseconds: 1700);

  static const double contentMaxWidthPhone = 560;
  static const double contentMaxWidthTablet = 760;
  static const double compactWidthBreakpoint = 360;
  static const double tabletWidthBreakpoint = 720;

  static const double tableMinColumnWidth = 108;
  static const double characterHeightFactor = 0.18;
  static const double characterMinHeight = 104;
  static const double characterMaxHeight = 190;
}
