import 'package:flutter/material.dart';

/// Reusable reserved zone for decorative characters above CTA buttons.
///
/// This keeps decoration out of content measurement surprises:
/// - main lesson content stays aligned;
/// - CTA remains the last stable element;
/// - decoration scales down and can hide on compact screens.
class LessonBottomDecorationZone extends StatelessWidget {
  const LessonBottomDecorationZone({
    super.key,
    required this.viewportHeight,
    required this.viewportWidth,
    required this.decorationBuilder,
    this.preferredSize = 220,
    this.maxSize = 260,
    this.minSize = 92,
    this.preferredReservedHeight = 170,
    this.minReservedHeight = 90,
    this.hideBelowHeight = 620,
    this.hideBelowWidth = 320,
    this.collapsedSpacing = 6,
  });

  final double viewportHeight;
  final double viewportWidth;
  final Widget Function(double size) decorationBuilder;
  final double preferredSize;
  final double maxSize;
  final double minSize;
  final double preferredReservedHeight;
  final double minReservedHeight;
  final double hideBelowHeight;
  final double hideBelowWidth;
  final double collapsedSpacing;

  @override
  Widget build(BuildContext context) {
    final hideDecoration =
        viewportHeight < hideBelowHeight || viewportWidth < hideBelowWidth;
    if (hideDecoration) {
      return SizedBox(height: collapsedSpacing);
    }

    final reservedHeight = preferredReservedHeight.clamp(
      minReservedHeight,
      viewportHeight * 0.28,
    );
    final sizeFromReserve = reservedHeight - 10;
    final decorationSize = preferredSize.clamp(
      minSize,
      sizeFromReserve < maxSize ? sizeFromReserve : maxSize,
    );

    return SizedBox(
      height: reservedHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox.square(
          dimension: decorationSize,
          child: decorationBuilder(decorationSize),
        ),
      ),
    );
  }
}
