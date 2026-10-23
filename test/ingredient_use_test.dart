import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/domain/ingredient_suggestions.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/ui/recipes/recipe_edit_screen.dart';
import 'package:nutrition_core/nutrition_core.dart';

AppDatabase _memory() {
  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  addTearDown(db.close);
  return db;
}

AppScope _scope(AppDatabase db, Widget child) => AppScope(
  db: db,
  wheel: WheelService(db),
  photos: PhotoStore(Directory.systemTemp),
  nutrition: NutritionRepository(db),
  child: child,
);

Future<void> _usda(NutritionRepository repo, String id, String name) =>
    repo.store(Food(source: FoodSource.usda, sourceId: id, name: name, per100g: Nutrients.of(energyKcal: 100)));

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('suggestions join spellings, keep the usual link and put names starting with the text first', () {
    final suggestions = ingredientSuggestions([
      (name: 'Flour', foodKey: 'usda:1', recipes: 3),
      (name: 'flour ', foodKey: null, recipes: 1),
      (name: 'Wheat flour T550', foodKey: 'usda:2', recipes: 5),
      (name: 'Ćevapi spice', foodKey: null, recipes: 1),
      (name: '  ', foodKey: null, recipes: 9),
    ]);
    expect(suggestions, hasLength(3));
    final flour = suggestions.singleWhere((s) => s.name == 'Flour');
    expect((flour.recipes, flour.foodKey), (4, 'usda:1'));

    expect([for (final s in matchIngredientSuggestions(suggestions, 'fl')) s.name], ['Flour', 'Wheat flour T550']);
    expect([for (final s in matchIngredientSuggestions(suggestions, 'cev')) s.name], ['Ćevapi spice']);
    expect(matchIngredientSuggestions(suggestions, 'flour'), [
      isA<IngredientSuggestion>().having((s) => s.name, 'name', 'Wheat flour T550'),
    ], reason: 'the exact name is already typed');
    expect(matchIngredientSuggestions(suggestions, ' '), isEmpty);
  });

  test('foods used in recipes come first in the search, even among many matches', () async {
    final db = _memory();
    final repo = NutritionRepository(db);
    for (var i = 0; i < 320; i++) {
      await _usda(repo, 'x$i', 'Flour $i');
    }
    await _usda(repo, 'long', 'Flour, wheat, all-purpose, enriched, bleached, my favourite');
    await _usda(repo, 'plain', 'Flour');
    for (final name in ['Pizza', 'Bread']) {
      await db.saveRecipe(
        RecipeDraft(
          name: name,
          portions: 2,
          ingredients: [
            IngredientDraft(name: 'flour', amount: 500, unit: 'g', foodKey: 'usda:long'),
            if (name == 'Pizza') IngredientDraft(name: 'flour', amount: 10, unit: 'g', foodKey: 'usda:x7'),
          ],
        ),
      );
    }
    expect(await db.foodUseCounts(), {'usda:long': 2, 'usda:x7': 1});
    final results = await repo.searchLocal('flour');
    expect([for (final f in results.take(3)) f.key], ['usda:long', 'usda:x7', 'usda:plain']);
    expect([for (final f in await repo.searchLocal('milk')) f.key], isEmpty);
  });

  testWidgets('typing an ingredient suggests names used before and links their food', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = _memory();
    final repo = NutritionRepository(db);
    await _usda(repo, '1', 'Wheat flour, white');
    await db.saveRecipe(
      RecipeDraft(
        name: 'Bread',
        portions: 4,
        ingredients: [IngredientDraft(name: 'Flour T550', amount: 500, unit: 'g', foodKey: 'usda:1')],
      ),
    );
    await tester.pumpWidget(_scope(db, const MaterialApp(home: RecipeEditScreen())));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Ingredient'), 'fl');
    await tester.pumpAndSettle();
    expect(find.text('1 recipe'), findsOneWidget);
    await tester.tap(find.text('Flour T550'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Flour T550'), findsOneWidget);
    expect(find.text('Wheat flour, white'), findsOneWidget, reason: 'the usual nutrition link comes along');

    await tester.tap(find.byTooltip('Unlink'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Link nutrition'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Flour T550').last, 'flour');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('In 1 recipe'), findsOneWidget);
  });
}
