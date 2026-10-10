import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/ui/nutrition/food_edit_screen.dart';
import 'package:manja/ui/nutrition/nutrition_panel.dart';
import 'package:nutrition_core/nutrition_core.dart';

void main() {
  test('vitamins and minerals are separate from the basic label values', () {
    expect(Nutrient.basic, hasLength(8));
    expect(Nutrient.vitaminsAndMinerals, hasLength(12));
    expect(Nutrient.vitaminC.dailyReference, 80);
    expect(Nutrient.cholesterol.dailyReference, isNull);
    expect(dailyReferencePercent(Nutrient.vitaminC, 40), '50%');
    expect(dailyReferencePercent(Nutrient.iron, 0.05), '<1%');
    expect(dailyReferencePercent(Nutrient.cholesterol, 20), isNull);
    expect(formatDetailedNutrient(0.034), '0.03');
    expect(formatDetailedNutrient(2.71), '2.7');
    expect(formatDetailedNutrient(558), '558');
  });

  testWidgets('more nutrients can be entered for an own ingredient', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4800)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final nutrition = NutritionRepository(db);
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: nutrition,
        child: const MaterialApp(home: FoodEditScreen(initialName: 'Orange juice')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('nutrient-vitaminC')), findsNothing, reason: 'folded away by default');
    await tester.enterText(find.byKey(const ValueKey('nutrient-energy')), '45');
    await tester.tap(find.text('More nutrients'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('nutrient-vitaminC')), '50');
    await tester.enterText(find.byKey(const ValueKey('nutrient-potassium')), '200');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = (await nutrition.library()).single;
    expect(saved.per100g[Nutrient.energy], 45);
    expect(saved.per100g[Nutrient.vitaminC], 50);
    expect(saved.per100g[Nutrient.potassium], 200);
    expect(saved.per100g.has(Nutrient.calcium), isFalse);
  });

  testWidgets('the recipe panel shows vitamins and minerals per portion with the daily reference', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final juice = Food(
      source: FoodSource.user,
      sourceId: 'oj',
      name: 'Orange juice',
      per100g: Nutrients({Nutrient.energy: 45, Nutrient.vitaminC: 40, Nutrient.cholesterol: 0}),
    );
    final result = RecipeNutrition.calculate([
      IngredientLine(name: 'juice', amount: 200, unit: CookingUnit.g, food: juice),
    ], portions: 1);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: NutritionPanel(result: result)),
        ),
      ),
    );
    expect(find.text('Vitamin C'), findsNothing);
    await tester.tap(find.text('Vitamins and minerals'));
    await tester.pumpAndSettle();
    expect(find.text('Vitamin C'), findsOneWidget);
    expect(find.text('80 mg'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Cholesterol'), findsOneWidget);
  });
}
