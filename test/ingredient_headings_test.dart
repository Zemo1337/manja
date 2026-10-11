import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/domain/cookbook_pdf.dart';
import 'package:manja/domain/ingredient_sections.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/ui/recipes/recipe_detail_screen.dart';
import 'package:manja/ui/recipes/recipe_edit_screen.dart';
import 'package:pdf/widgets.dart' as pw;

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

void _tallView(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(945, 6000)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

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

final _ingredientField = find.widgetWithText(TextFormField, 'Ingredient');
final _headingField = find.widgetWithText(TextFormField, 'Heading');

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('ingredients split into sections where the heading changes', () {
    RecipeIngredient i(String name, String? section) =>
        RecipeIngredient(id: 0, recipeId: 1, position: 0, name: name, amount: 1, unit: 'g', section: section);
    final groups = ingredientSections([
      i('salt', null),
      i('flour', 'Dough'),
      i('water', 'Dough'),
      i('tomato', 'Topping'),
    ]);
    expect([for (final g in groups) g.section], [null, 'Dough', 'Topping']);
    expect([for (final g in groups) g.items.length], [1, 2, 1]);
  });

  testWidgets('headings group the ingredients in the editor, on the recipe page and in the PDF', (tester) async {
    _tallView(tester);
    final db = _memory();
    await tester.pumpWidget(_scope(db, const MaterialApp(home: RecipeEditScreen())));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Pizza');
    await tester.enterText(_ingredientField, 'Flour');

    await tester.tap(find.text('Add heading'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(_headingField).dy,
      lessThan(tester.getTopLeft(find.widgetWithText(TextFormField, 'Flour')).dy),
      reason: 'the first heading goes above the ingredients already there',
    );
    await tester.enterText(_headingField, 'Dough');
    await tester.tap(find.text('Add ingredient'));
    await tester.pumpAndSettle();
    await tester.enterText(_ingredientField.last, 'Tomato');
    await tester.tap(find.text('Add ingredient'));
    await tester.pumpAndSettle();
    await tester.enterText(_ingredientField.last, 'Cheese');
    await tester.tap(find.text('Add heading'));
    await tester.pumpAndSettle();
    await tester.enterText(_headingField.last, 'Topping');
    final topping = find.widgetWithText(TextFormField, 'Topping');
    final tomato = find.widgetWithText(TextFormField, 'Tomato');
    await _drag(tester, _handleOf(topping), tester.getCenter(tomato).dy - tester.getCenter(topping).dy - 30);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final id = (await db.allRecipes()).single.id;
    final full = (await db.recipeFull(id))!;
    expect(
      [for (final i in full.ingredients) (i.name, i.section)],
      [('Flour', 'Dough'), ('Tomato', 'Topping'), ('Cheese', 'Topping')],
    );

    await tester.pumpWidget(_scope(db, MaterialApp(key: UniqueKey(), home: RecipeEditScreen(existing: full))));
    await tester.pumpAndSettle();
    final order = [
      for (final name in ['Dough', 'Flour', 'Topping', 'Tomato', 'Cheese'])
        tester.getTopLeft(find.widgetWithText(TextFormField, name)).dy,
    ];
    expect(order, [...order]..sort(), reason: 'headings come back above their ingredients');

    await tester.pumpWidget(_scope(db, MaterialApp(key: UniqueKey(), home: RecipeDetailScreen(recipeId: id))));
    await tester.pumpAndSettle();
    expect(find.text('Dough'), findsOneWidget);
    expect(find.text('Topping'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Topping')).dy, greaterThan(tester.getTopLeft(find.text('Flour')).dy));
    expect(tester.getTopLeft(find.text('Topping')).dy, lessThan(tester.getTopLeft(find.text('Tomato')).dy));

    final font = pw.Font.ttf(File('assets/fonts/Roboto-Regular.ttf').readAsBytesSync().buffer.asByteData());
    final doc = buildCookbookDocument(
      [CookbookRecipe(full)],
      const CookbookOptions(),
      CookbookFonts(regular: font, bold: font, light: font),
    );
    expect(recipePages(doc), contains('recipe-$id'));
  });
}
