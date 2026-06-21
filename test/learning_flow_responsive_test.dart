import 'package:aminapp/learning/screens/learning_flow_screen.dart';
import 'package:aminapp/shared/settings/app_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testSizes = <Size>[
    Size(320, 568),
    Size(360, 640),
    Size(390, 844),
    Size(412, 915),
    Size(640, 360),
  ];

  testWidgets('Learning flow lays out on target mobile sizes', (tester) async {
    await AppSettingsService.instance.setVoiceOverEnabled(false);
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    for (final size in testSizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: const TextScaler.linear(1.3),
              disableAnimations: true,
            ),
            child: LearningFlowScreen(key: ValueKey(size), name: 'Tester'),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'initial size $size');

      for (var index = 0; index < 6; index += 1) {
        await tester.tap(find.byIcon(Icons.arrow_forward_rounded).last);
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull, reason: 'step $index at $size');
      }

      final animationTapPoint = Offset(
        size.width * 0.62,
        size.height * (size.width > size.height ? 0.28 : 0.36),
      );
      for (var step = 7; step <= 14; step += 1) {
        for (var stage = 0; stage < 2; stage += 1) {
          await tester.tapAt(animationTapPoint);
          await tester.pump(const Duration(milliseconds: 80));
          expect(
            tester.takeException(),
            isNull,
            reason: 'B$step stage $stage at $size',
          );
        }
        await tester.tap(find.byIcon(Icons.arrow_forward_rounded).last);
        await tester.pump(const Duration(milliseconds: 500));
        expect(
          tester.takeException(),
          isNull,
          reason: 'B$step continue at $size',
        );
      }
    }
  });
}
