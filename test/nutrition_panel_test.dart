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
import 'package:manja/ui/nutrition/nutrition_panel.dart';
import 'package:manja/ui/recipes/recipe_detail_screen.dart';
import 'package:nutrition_core/nutrition_core.dart';

void main() {
  testWidgets('recipe page shows nutrition per portion, per 100 g and per custom weight', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final nutrition = NutritionRepository(db);
    final flour = await nutrition.saveUserFood(
      name: 'Flour',
      per100g: Nutrients.of(energyKcal: 364, protein: 10, fiber: 3),
    );
    final milk = await nutrition.saveUserFood(
      name: 'Milk',
      per100g: Nutrients.of(energyKcal: 64, protein: 3.3, sodiumMg: 40),
      densityGPerMl: 1,
    );
    final id = await db.saveRecipe(RecipeDraft(
      name: 'Palačinke',
      portions: 2,
      ingredients: [
        IngredientDraft(name: 'Flour', amount: 100, unit: 'g', foodKey: flour.key),
        IngredientDraft(name: 'Milk', amount: 300, unit: 'ml', foodKey: milk.key),
        IngredientDraft(name: 'Salt', amount: 1, unit: 'pinch'),
      ],
    ));

    await tester.pumpWidget(AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(Directory.systemTemp),
      nutrition: nutrition,
      child: MaterialApp(home: RecipeDetailScreen(recipeId: id)),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Nutrition'), findsOneWidget);
    expect(find.text('278 kcal'), findsOneWidget, reason: '(364 + 192) / 2 portions');
    expect(find.text('9.9 g'), findsOneWidget, reason: 'protein (10 + 9.9) / 2');
    expect(find.text('1.5 g *'), findsOneWidget, reason: 'fiber only known for flour');
    expect(find.textContaining('Dish 400 g (sum of ingredients)'), findsOneWidget);
    expect(find.text('Salt: no food linked'), findsOneWidget);

    await tester.tap(find.descendant(of: find.byType(SegmentedButton<NutritionBasis>), matching: find.text('100 g')));
    await tester.pumpAndSettle();
    expect(find.text('139 kcal'), findsOneWidget, reason: '556 kcal / 400 g');

    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '50');
    await tester.pumpAndSettle();
    expect(find.text('70 kcal'), findsOneWidget, reason: '556 / 400 * 50 = 69.5');
  });

  testWidgets('without linked foods the page explains how to get nutrition', (tester) async {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final id = await db.saveRecipe(RecipeDraft(
      name: 'Sarma',
      portions: 4,
      ingredients: [IngredientDraft(name: 'Rice', amount: 200, unit: 'g')],
    ));
    await tester.pumpWidget(AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(Directory.systemTemp),
      nutrition: NutritionRepository(db),
      child: MaterialApp(home: RecipeDetailScreen(recipeId: id)),
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('Link ingredients to foods'), findsOneWidget);
  });
}
