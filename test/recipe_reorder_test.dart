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
import 'package:manja/ui/recipes/recipe_edit_screen.dart';

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

Future<void> _drag(WidgetTester tester, Finder handle, double dy) async {
  final gesture = await tester.startGesture(tester.getCenter(handle));
  for (var i = 0; i < 10; i++) {
    await gesture.moveBy(Offset(0, dy / 10));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

Finder _handleOf(Finder field) => find.descendant(
  of: find.ancestor(of: field, matching: find.byType(KeyedSubtree)).first,
  matching: find.byIcon(Icons.drag_indicator),
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('ingredients and steps keep the order they are dragged into', (tester) async {
    tester.view
      ..physicalSize = const Size(945, 6000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = _memory();
    final id = await db.saveRecipe(
      RecipeDraft(
        name: 'Pizza',
        portions: 2,
        ingredients: [
          for (final n in ['Flour', 'Water', 'Yeast', 'Tomato']) IngredientDraft(name: n, amount: 100, unit: 'g'),
        ],
        steps: ['Knead', 'Bake', 'Rest'],
      ),
    );
    final recipe = (await db.recipeFull(id))!;
    await tester.pumpWidget(_scope(db, MaterialApp(home: RecipeEditScreen(existing: recipe))));
    await tester.pumpAndSettle();

    final tomato = find.widgetWithText(TextFormField, 'Tomato');
    final flour = find.widgetWithText(TextFormField, 'Flour');
    await _drag(tester, _handleOf(tomato), tester.getCenter(flour).dy - tester.getCenter(tomato).dy - 20);
    final rest = find.widgetWithText(TextFormField, 'Rest');
    final bake = find.widgetWithText(TextFormField, 'Bake');
    await _drag(tester, _handleOf(rest), tester.getCenter(bake).dy - tester.getCenter(rest).dy - 20);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final saved = (await db.recipeFull(id))!;
    expect([for (final i in saved.ingredients) i.name], ['Tomato', 'Flour', 'Water', 'Yeast']);
    expect([for (final s in saved.steps) s.body], ['Knead', 'Rest', 'Bake']);
  });
}
