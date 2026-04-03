import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aminapp/main.dart';

void main() {
  testWidgets('App starts on S001 intro screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Hai! Saya AmiN. Jom belajar bersama!'), findsOneWidget);
  });
}
