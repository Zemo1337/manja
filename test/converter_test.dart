import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/tools/converter_screen.dart';
import 'package:nutrition_core/nutrition_core.dart';

void main() {
  late AppDatabase db;
  late NutritionRepository repo;

  Future<void> pump(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: repo,
        child: const MaterialApp(home: ConverterScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  String field(WidgetTester tester, String key) => tester.widget<TextField>(find.byKey(ValueKey(key))).controller!.text;

  setUp(() {
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    repo = NutritionRepository(db);
  });

  tearDown(() => db.close());

  testWidgets('cups of flour convert to grams and back', (tester) async {
    await repo.store(
      const Food(
        source: FoodSource.usda,
        sourceId: '168894',
        name: 'Wheat flour, white, all-purpose, enriched, bleached',
        per100g: Nutrients({}),
        portions: [FoodPortion(label: '1 cup', grams: 125, unit: CookingUnit.cup)],
      ),
    );
    await repo.store(
      const Food(
        source: FoodSource.usda,
        sourceId: '173647',
        name: 'Beverages, water, tap, drinking',
        per100g: Nutrients({}),
        portions: [FoodPortion(label: '1 liter', grams: 1000, unit: CookingUnit.l)],
      ),
    );
    await pump(tester);

    expect(field(tester, 'right-amount'), '125');
    expect(find.text('1 decilitre'), findsOneWidget, reason: 'the table lists common amounts');

    await tester.enterText(find.byKey(const ValueKey('right-amount')), '250');
    await tester.pumpAndSettle();
    expect(field(tester, 'left-amount'), '2');

    await tester.tap(find.text('Water'));
    await tester.pumpAndSettle();
    expect(field(tester, 'left-amount'), closeToText(1.057, 0.01));

    await tester.tap(find.byTooltip('Swap units'));
    await tester.pumpAndSettle();
    expect(field(tester, 'left-amount'), '250');
  });

  testWidgets('without an ingredient, volume to weight explains what is missing', (tester) async {
    await pump(tester);
    expect(field(tester, 'right-amount'), '');
    expect(find.textContaining('Pick an ingredient'), findsOneWidget);
    expect(find.text('Common equivalents'), findsOneWidget);
  });
}

Matcher closeToText(double value, double delta) => predicate<String>(
  (s) => (double.tryParse(s) ?? double.nan) - value < delta && value - (double.tryParse(s) ?? double.nan) < delta,
  'a number close to $value',
);
