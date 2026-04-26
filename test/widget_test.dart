import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aminapp/app/app.dart';
import 'package:aminapp/features/intro/screens/s001_intro_screen.dart';

void main() {
  testWidgets('App starts on S001 intro screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AminApp()));

    expect(find.byType(S001IntroScreen), findsOneWidget);
  });
}
