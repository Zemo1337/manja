import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/data/recipe_importer.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/recipes/import_recipe_screen.dart';

final _page =
    '''
<html><head><script type="application/ld+json">${jsonEncode({
      '@context': 'https://schema.org',
      '@graph': [
        {'@type': 'WebPage'},
        {
          '@type': 'Recipe',
          'name': 'Palačinke',
          'description': 'Thin pancakes.',
          'recipeYield': '4 servings',
          'prepTime': 'PT10M',
          'cookTime': 'PT20M',
          'recipeIngredient': ['250 g brašna', '5 dl mlijeka', '2 jaja', 'prstohvat soli'],
          'recipeInstructions': [
            {'@type': 'HowToStep', 'text': 'Mix everything.'},
            {'@type': 'HowToStep', 'text': 'Fry thin.'},
          ],
        },
      ],
    })}</script></head><body>Palačinke</body></html>
''';

void main() {
  late AppDatabase db;

  Future<void> pump(WidgetTester tester, http.Response Function(Uri) site) async {
    tester.view
      ..physicalSize = const Size(1080, 7000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        child: MaterialApp(
          home: ImportRecipeScreen(
            useWebView: false,
            initialUrl: 'www.coolinarika.com/recept/palacinke',
            importer: RecipeImporter(client: MockClient((r) async => site(r.url))),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> import(WidgetTester tester) async {
    await tester.tap(find.text('Import'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
  }

  testWidgets('a recipe page fills the editor and saves with its source', (tester) async {
    await pump(tester, (url) => http.Response.bytes(utf8.encode(_page), 200, headers: {'content-type': 'text/html'}));
    await import(tester);

    expect(find.text('New recipe'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Palačinke'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '4'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '10'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '20'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'brašna'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'prstohvat soli'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Fry thin.'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final recipe = (await db.allRecipes()).single;
    expect(recipe.name, 'Palačinke');
    expect(recipe.sourceUrl, 'https://www.coolinarika.com/recept/palacinke');
    final full = (await db.recipeFull(recipe.id))!;
    expect(
      [for (final i in full.ingredients) (i.amount, i.unit, i.name)],
      [(250.0, 'g', 'brašna'), (5.0, 'dl', 'mlijeka'), (2.0, 'piece', 'jaja'), (0.0, 'piece', 'prstohvat soli')],
    );
    expect(full.steps.map((s) => s.body), ['Mix everything.', 'Fry thin.']);
  });

  testWidgets('a site that blocks downloads explains what to do', (tester) async {
    await pump(tester, (_) => http.Response('', 403));
    await import(tester);
    expect(find.textContaining('blocks automatic downloads'), findsOneWidget);
    expect(find.text('Import'), findsOneWidget, reason: 'stays on the import screen');
  });

  testWidgets('a page without recipe data says so', (tester) async {
    await pump(tester, (_) => http.Response('<html><body>Hello</body></html>', 200));
    await import(tester);
    expect(find.textContaining('No recipe data found'), findsOneWidget);
  });
}
