import 'package:flutter_test/flutter_test.dart';

import 'package:postal_hub/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    await tester.pumpWidget(const PostalHubApp());
    await tester.pump();
    expect(find.text('PostalHub'), findsOneWidget);
  });
}