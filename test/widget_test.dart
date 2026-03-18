import 'package:flutter_test/flutter_test.dart';

import 'package:snakes_and_ladders/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SnakesAndLaddersApp());

    expect(find.text('Snakes and Ladders'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
  });
}
