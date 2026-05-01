import 'dart:math' as math;

import 'package:flutter/widgets.dart';

double responsiveWidthScale(BuildContext context, {double base = 412}) {
  final width = MediaQuery.sizeOf(context).width;
  final scale = width / base;
  return scale.clamp(0.85, 1.15);
}

double responsiveHeightScale(BuildContext context, {double base = 915}) {
  final height = MediaQuery.sizeOf(context).height;
  final scale = height / base;
  return scale.clamp(0.8, 1.2);
}

double responsiveClamp(
  BuildContext context,
  double min,
  double ideal,
  double max,
) {
  final size = MediaQuery.sizeOf(context);
  final shortestSide = math.min(size.width, size.height);
  final scale = (shortestSide / 390).clamp(0.86, 1.08);
  return (ideal * scale).clamp(min, max).toDouble();
}

TextScaler responsiveTextScaler(
  BuildContext context, {
  double minScaleFactor = 1,
  double maxScaleFactor = 1.3,
}) {
  return MediaQuery.textScalerOf(
    context,
  ).clamp(minScaleFactor: minScaleFactor, maxScaleFactor: maxScaleFactor);
}
