import 'package:aminapp/shared/motion/app_motion_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapWithMedia(Widget child, {bool disableAnimations = false}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  testWidgets('PulsingStars uses static mode when reduced motion is enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithMedia(const PulsingStars(count: 2), disableAnimations: true),
    );

    expect(find.byKey(const Key('pulsing-stars-static')), findsOneWidget);
  });

  testWidgets('BounceTapCard triggers tap callback without layout shift', (
    tester,
  ) async {
    var tapped = false;
    final key = GlobalKey();
    const cardKey = Key('bounce-card');

    await tester.pumpWidget(
      _wrapWithMedia(
        Material(
          child: Center(
            child: SizedBox(
              key: key,
              width: 220,
              height: 90,
              child: BounceTapCard(
                onTap: () => tapped = true,
                child: const ColoredBox(key: cardKey, color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );

    final before = tester.getSize(find.byKey(key));
    await tester.tap(find.byKey(cardKey));
    await tester.pumpAndSettle();
    final after = tester.getSize(find.byKey(key));

    expect(tapped, isTrue);
    expect(after, equals(before));
  });

  testWidgets('StarBurstOverlay shows one burst per trigger', (tester) async {
    var burst = 0;

    await tester.pumpWidget(
      _wrapWithMedia(
        Material(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => burst += 1),
                    child: const Text('Burst'),
                  ),
                  StarBurstOverlay(
                    burstKey: burst,
                    child: const SizedBox(width: 120, height: 120),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('star-burst-icon')), findsNothing);

    await tester.tap(find.text('Burst'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(find.byKey(const Key('star-burst-icon')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 320));
    expect(find.byKey(const Key('star-burst-icon')), findsNothing);
  });

  testWidgets('CelebrationBurst calls completion once when active', (
    tester,
  ) async {
    var completed = 0;
    var active = false;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => active = true),
                    child: const Text('Start'),
                  ),
                  CelebrationBurst(
                    active: active,
                    onCompleted: () => completed += 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000));

    expect(completed, 1);
  });
}
