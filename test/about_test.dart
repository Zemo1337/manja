import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/ui/settings/about.dart';

void main() {
  testWidgets('About shows the license, source link and credits for fonts and data', (tester) async {
    registerAppLicenses();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(onPressed: () => showManjaAbout(context), child: const Text('About')),
        ),
      ),
    );
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.textContaining('GNU Affero General Public License v3.0'), findsOneWidget);
    expect(find.textContaining(sourceUrl), findsOneWidget);
    for (final name in ['Lobster font', 'Roboto font', 'USDA FoodData Central', 'Open Food Facts']) {
      await tester.scrollUntilVisible(find.text(name), 200, scrollable: find.byType(Scrollable).last);
      expect(find.text(name), findsOneWidget);
    }
  });
}
