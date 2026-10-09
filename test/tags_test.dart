import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/data/recipe_importer.dart';
import 'package:manja/domain/tag_matching.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/main.dart';
import 'package:manja/ui/recipes/recipe_edit_screen.dart';
import 'package:manja/ui/settings/tags_screen.dart';

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

void _tallView(WidgetTester tester, {double width = 1080}) {
  tester.view
    ..physicalSize = Size(width, 3200)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('tags', () {
    test('a new database starts with the course tags in order', () async {
      final db = _memory();
      expect([for (final t in await db.allTags()) t.name], defaultTags);
    });

    test('tags can be added once, renamed, reordered and deleted without touching recipes', () async {
      final db = _memory();
      final quick = await db.addTag('Quick weekday');
      expect(await db.addTag('quick weekday '), quick, reason: 'same name, any case, is the same tag');
      final dessert = (await db.tagByName('Dessert'))!.id;
      final id = await db.saveRecipe(RecipeDraft(name: 'Baklava', portions: 12, tagIds: [dessert, quick]));
      expect([for (final t in (await db.recipeFull(id))!.tags) t.name], ['Dessert', 'Quick weekday']);

      await db.renameTag(quick, 'Fast');
      final tags = await db.allTags();
      await db.reorderTags([quick, for (final t in tags) if (t.id != quick) t.id]);
      expect((await db.allTags()).first.name, 'Fast');

      await db.deleteTag(quick);
      expect([for (final t in (await db.recipeFull(id))!.tags) t.name], ['Dessert']);
      expect(await db.allRecipes(), hasLength(1));
    });

    test('saving without tag ids keeps the tags a recipe already has', () async {
      final db = _memory();
      final main = (await db.tagByName('Main'))!.id;
      final id = await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4, tagIds: [main]));
      await db.saveRecipe(RecipeDraft(id: id, name: 'Sarma', portions: 6));
      expect([for (final t in (await db.recipeFull(id))!.tags) t.name], ['Main']);
    });

    test('site categories map to the built-in tags in English, Croatian and German', () {
      expect(matchTagNames(['Kolači'], defaultTags), ['Dessert']);
      expect(matchTagNames(['Juhe i variva'], defaultTags), isEmpty, reason: 'only whole category names count');
      expect(matchTagNames(['Juhe', 'Glavna jela'], defaultTags), containsAll(['Soup', 'Main']));
      expect(matchTagNames(['Main Course, Dinner'], defaultTags), ['Main']);
      expect(matchTagNames(['Nachspeise'], defaultTags), ['Dessert']);
      expect(matchTagNames(['Grill season'], [...defaultTags, 'Grill season']), ['Grill season']);
      expect(matchTagNames(['Dessert'], ['Main']), isEmpty, reason: 'a deleted tag is not brought back');
    });
  });

  group('wheel', () {
    test('a new round starts after the latest meal even when both happen in the same instant', () async {
      final db = _memory();
      final wheel = WheelService(db);
      final id = await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
      final at = DateTime(2026, 10, 9, 22, 38, 53, 85, 119);
      await db.logMeal(id, at);
      final start = await wheel.resetCycle(at);
      expect(start.isAfter(at), isTrue);
      expect(await db.mealLogsSince(start), isEmpty);
    });

    testWidgets('a tag above the wheel shows only those dishes and is remembered', (tester) async {
      _tallView(tester, width: 2400);
      final db = _memory();
      final wheel = WheelService(db);
      final main = (await db.tagByName('Main'))!.id;
      final dessert = (await db.tagByName('Dessert'))!.id;
      await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4, tagIds: [main]));
      await db.saveRecipe(RecipeDraft(name: 'Ćevapi', portions: 4, tagIds: [main]));
      await db.saveRecipe(RecipeDraft(name: 'Baklava', portions: 12, tagIds: [dessert]));
      await tester.pumpWidget(
        AppScope(
          db: db,
          wheel: wheel,
          photos: PhotoStore(Directory.systemTemp),
          nutrition: NutritionRepository(db),
          child: const ManjaApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('3 of 3 dishes left'), findsOneWidget);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Dessert'));
      await tester.pumpAndSettle();
      expect(find.text('Dessert · 1 of 1 dishes left'), findsOneWidget);
      expect((await wheel.computeState()).tag?.name, 'Dessert');

      await tester.tap(find.text('Spin'));
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      expect(find.text('Baklava'), findsWidgets);
      await tester.tap(find.text("Let's cook it"));
      await tester.pumpAndSettle();
      expect(find.text('All Dessert dishes eaten'), findsOneWidget);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Main'));
      await tester.pumpAndSettle();
      expect(find.text('Main · 2 of 2 dishes left'), findsOneWidget);

      await tester.tap(find.widgetWithText(ChoiceChip, 'Soup'));
      await tester.pumpAndSettle();
      expect(find.text('Nothing tagged Soup'), findsOneWidget);
      await tester.tap(find.text('Show all dishes'));
      await tester.pumpAndSettle();
      expect(find.text('2 of 3 dishes left'), findsOneWidget);
    });
  });

  group('editor', () {
    testWidgets('a new recipe starts as Main and can get a new tag', (tester) async {
      _tallView(tester);
      final db = _memory();
      await tester.pumpWidget(_scope(db, const MaterialApp(home: RecipeEditScreen())));
      await tester.pumpAndSettle();
      FilterChip chip(String name) => tester.widget<FilterChip>(find.widgetWithText(FilterChip, name));
      expect(chip('Main').selected, isTrue);
      expect(chip('Dessert').selected, isFalse);

      await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Burek');
      await tester.tap(find.widgetWithText(FilterChip, 'Main'));
      await tester.tap(find.widgetWithText(FilterChip, 'Snack'));
      await tester.tap(find.text('New tag'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Mama');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(chip('Mama').selected, isTrue);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final recipe = (await db.allRecipes()).single;
      expect([for (final t in (await db.recipeFull(recipe.id))!.tags) t.name], ['Snack', 'Mama']);
    });

    testWidgets('an imported dessert is tagged Dessert', (tester) async {
      _tallView(tester);
      final db = _memory();
      await tester.pumpWidget(
        _scope(
          db,
          const MaterialApp(
            home: RecipeEditScreen(
              template: RecipeTemplate(name: 'Tufahije', categories: ['Kolači']),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Dessert')).selected, isTrue);
      expect(tester.widget<FilterChip>(find.widgetWithText(FilterChip, 'Main')).selected, isFalse);
    });
  });

  testWidgets('tags can be renamed and deleted in settings', (tester) async {
    _tallView(tester);
    final db = _memory();
    final snack = (await db.tagByName('Snack'))!.id;
    await db.saveRecipe(RecipeDraft(name: 'Uštipci', portions: 4, tagIds: [snack]));
    await tester.pumpWidget(_scope(db, const MaterialApp(home: TagsScreen())));
    await tester.pumpAndSettle();
    expect(find.text('1 recipe'), findsOneWidget);

    final snackTile = find.widgetWithText(ListTile, 'Snack');
    await tester.tap(find.descendant(of: snackTile, matching: find.byTooltip('Rename')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Bites');
    await tester.tap(find.widgetWithText(FilledButton, 'Rename'));
    await tester.pumpAndSettle();
    expect(find.text('Bites'), findsOneWidget);

    await tester.tap(find.descendant(of: find.widgetWithText(ListTile, 'Bites'), matching: find.byTooltip('Delete')));
    await tester.pumpAndSettle();
    expect(find.text('It is removed from 1 recipe. The recipes themselves stay.'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Bites'), findsNothing);
    expect(await db.allRecipes(), hasLength(1));
  });
}
