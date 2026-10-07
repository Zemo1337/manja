import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/main.dart';
import 'package:nutrition_core/nutrition_core.dart';

void main() {
  testWidgets('add a recipe, spin the wheel, cook it, see it in history', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));

    final photos = PhotoStore(Directory.systemTemp.createTempSync('manja_photos_'));
    addTearDown(() => _deleteQuietly(photos.baseDir));
    await tester.pumpWidget(AppScope(db: db, wheel: WheelService(db), photos: photos, nutrition: NutritionRepository(db), child: const ManjaManjaApp()));
    await tester.pumpAndSettle();
    expect(find.text('1 of 1 dishes left'), findsOneWidget);

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add recipe'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Ćevapi');
    await tester.enterText(find.widgetWithText(TextFormField, 'Qty'), '500');
    await tester.enterText(find.widgetWithText(TextFormField, 'Ingredient'), 'Minced beef');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Ćevapi'), findsOneWidget);

    await tester.tap(find.text('Wheel'));
    await tester.pumpAndSettle();
    expect(find.text('2 of 2 dishes left'), findsOneWidget);

    await tester.tap(find.text('Spin'));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Today you cook'), findsOneWidget);

    final chosen = tester.widget<Text>(find.byKey(const ValueKey('result-name'))).data;
    await tester.tap(find.byKey(const ValueKey('wheel')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Today you cook'), findsOneWidget, reason: 'tapping the wheel keeps the result');
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.byKey(const ValueKey('result-name'))).data, chosen);

    await tester.tap(find.text("Let's cook it"));
    await tester.pumpAndSettle();
    expect(find.text('1 of 2 dishes left'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    final logs = await db.select(db.mealLogs).get();
    expect(logs, hasLength(1));
    final eaten = (await db.allRecipes()).firstWhere((r) => r.id == logs.single.recipeId);
    expect(find.descendant(of: find.byType(ListTile), matching: find.text(eaten.name)), findsOneWidget);
  });

  for (final screen in const [Size(360, 640), Size(412, 915)]) {
    testWidgets('result buttons are visible without scrolling on ${screen.width.round()}x${screen.height.round()}',
        (tester) async {
      tester.view
        ..physicalSize = screen * 3
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
      addTearDown(db.close);
      final photos = PhotoStore(Directory.systemTemp.createTempSync('manja_photos_'));
      addTearDown(() => _deleteQuietly(photos.baseDir));
      final pixel = File('${photos.baseDir.path}/pixel.png')
        ..writeAsBytesSync(base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
        ));
      await tester.runAsync(() async {
        for (final name in ['Begova čorba sa piletinom i povrćem', 'Sarma']) {
          await db.saveRecipe(RecipeDraft(name: name, portions: 2, photoPath: await photos.save(pixel.path)));
        }
      });

      await tester.pumpWidget(AppScope(db: db, wheel: WheelService(db), photos: photos, nutrition: NutritionRepository(db), child: const ManjaManjaApp()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Spin'));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      final navTop = tester.getTopLeft(find.byType(NavigationBar)).dy;
      for (final label in ['Spin again', "Let's cook it"]) {
        final rect = tester.getRect(find.text(label));
        expect(rect.bottom, lessThanOrEqualTo(navTop), reason: '$label must not be hidden below the fold');
        expect(rect.right, lessThanOrEqualTo(screen.width));
      }
    });
  }

  testWidgets('an ingredient can be linked to a food from the picker', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final nutrition = NutritionRepository(db);
    final flour = await nutrition.saveUserFood(
      name: 'Wheat flour, white',
      per100g: Nutrients.of(energyKcal: 364),
      portions: const [FoodPortion(label: '1 cup', grams: 125, unit: CookingUnit.cup)],
    );
    final photos = PhotoStore(Directory.systemTemp.createTempSync('manja_photos_'));
    addTearDown(() => _deleteQuietly(photos.baseDir));
    await tester.pumpWidget(
      AppScope(db: db, wheel: WheelService(db), photos: photos, nutrition: nutrition, child: const ManjaManjaApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add recipe'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Palačinke');
    await tester.enterText(find.widgetWithText(TextFormField, 'Qty'), '2');
    await tester.enterText(find.widgetWithText(TextFormField, 'Ingredient'), 'flour');
    await tester.tap(find.text('Link nutrition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wheat flour, white'));
    await tester.pumpAndSettle();
    expect(find.text('Link nutrition'), findsNothing);
    expect(find.textContaining('No gram weight'), findsNothing, reason: 'grams are known per g');

    await tester.tap(find.widgetWithText(DropdownButtonFormField<CookingUnit>, 'g'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('pinch').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('No gram weight for "pinch"'), findsOneWidget);
    await tester.tap(find.widgetWithText(DropdownButtonFormField<CookingUnit>, 'pinch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('cup').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('No gram weight'), findsNothing, reason: 'the food has a cup portion');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final ingredient = (await db.select(db.recipeIngredients).get()).single;
    expect(ingredient.foodKey, flour.key);
    expect(ingredient.unit, 'cup');
  });

  testWidgets('own ingredients can be created from the picker and managed on the Ingredients screen', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final nutrition = NutritionRepository(db);
    final photos = PhotoStore(Directory.systemTemp.createTempSync('manja_photos_'));
    addTearDown(() => _deleteQuietly(photos.baseDir));
    await tester.pumpWidget(
      AppScope(db: db, wheel: WheelService(db), photos: photos, nutrition: nutrition, child: const ManjaManjaApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add recipe'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Burek');
    await tester.enterText(find.widgetWithText(TextFormField, 'Qty'), '2');
    await tester.enterText(find.widgetWithText(TextFormField, 'Ingredient'), 'Ajvar');
    await tester.tap(find.text('Link nutrition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create my own ingredient'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Ajvar'), findsOneWidget, reason: 'name is prefilled');
    await tester.enterText(find.byKey(const ValueKey('nutrient-energy')), '85');
    await tester.enterText(find.byKey(const ValueKey('nutrient-fat')), '5,5');
    await tester.enterText(find.byKey(const ValueKey('nutrient-sodium')), '1.2');
    await tester.tap(find.text('Add portion'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(DropdownButtonFormField<CookingUnit>, 'piece'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('tablespoon').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Weight'), '16');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Ajvar'), findsWidgets);
    expect(find.text('Link nutrition'), findsNothing);
    final foods = await nutrition.library();
    final ajvar = foods.single;
    expect(ajvar.source, FoodSource.user);
    expect(ajvar.per100g[Nutrient.fat], 5.5);
    expect(ajvar.per100g[Nutrient.sodium], closeTo(480, 1e-9));
    expect(gramsFor(ajvar, 2, CookingUnit.tbsp), 32);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ingredients'));
    await tester.pumpAndSettle();
    expect(find.text('My ingredients (1)'), findsOneWidget);
    expect(find.text('85 kcal / 100 g · used in recipes'), findsOneWidget);

    expect(find.textContaining('Built-in ingredients'), findsOneWidget);
  });

  testWidgets('recipes hidden behind the +n slice can still be drawn', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final wheel = WheelService(db);
    await wheel.saveAppearance(const WheelAppearance(maxSlices: 4));
    const names = ['Burek', 'Ćevapi', 'Dolma', 'Grah', 'Japrak', 'Musaka', 'Pasulj', 'Sarma'];
    for (final name in names) {
      await db.saveRecipe(RecipeDraft(name: name, portions: 2));
    }

    final photos = PhotoStore(Directory.systemTemp.createTempSync('manja_photos_'));
    addTearDown(() => _deleteQuietly(photos.baseDir));
    await tester.pumpWidget(AppScope(db: db, wheel: wheel, photos: photos, nutrition: NutritionRepository(db), child: const ManjaManjaApp()));
    await tester.pumpAndSettle();

    for (var left = names.length; left > 0; left--) {
      expect(find.text('$left of ${names.length} dishes left'), findsOneWidget);
      await tester.tap(find.text('Spin'));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Today you cook'), findsOneWidget);
      await tester.tap(find.text("Let's cook it"));
      await tester.pumpAndSettle();
    }

    final eaten = {for (final log in await db.select(db.mealLogs).get()) log.recipeId};
    expect(eaten, hasLength(names.length), reason: 'every recipe, visible or hidden, was drawn once');
    expect(find.text('8 of 8 dishes left'), findsOneWidget);
  });
}

void _deleteQuietly(Directory dir) {
  try {
    dir.deleteSync(recursive: true);
  } on FileSystemException {
    // Windows keeps decoded test images open until the test process exits.
  }
}
