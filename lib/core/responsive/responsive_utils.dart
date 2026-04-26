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
  BuildContext context, {
  required double min,
  required double max,
  required double byWidthFactor,
}) {
  final width = MediaQuery.sizeOf(context).width;
  return (width * byWidthFactor).clamp(min, max);
}
