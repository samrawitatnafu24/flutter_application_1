// ============================================================================
// Smoke & Widget Test: Mini Market App
// Verifies that the home catalog page loads with the app title and products.
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Mini Market smoke test loads catalog', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the Mini Market app bar title is displayed.
    expect(find.text('Mini Market'), findsOneWidget);

    // Verify that initial products are rendered in the catalog.
    expect(find.text('Phone X'), findsOneWidget);
    expect(find.text('Headphones'), findsOneWidget);
  });
}
