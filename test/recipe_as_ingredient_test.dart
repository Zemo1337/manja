import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/data/profile_backup.dart';
import 'package:manja/data/recipe_foods.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/ui/recipes/recipe_detail_screen.dart';
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

/// A bun recipe of 8 buns from 500 g flour at 364 kcal per 100 g, so 1820 kcal in all.
Future<int> _bun(AppDatabase db, {double? finishedWeightG = 480}) async {
  final flour = await NutritionRepository(db).saveUserFood(name: 'Flour', per100g: Nutrients.of(energyKcal: 364));
  return db.saveRecipe(
    RecipeDraft(
      name: 'Brioche bun',
      portions: 8,
      finishedWeightG: finishedWeightG,
      ingredients: [IngredientDraft(name: 'flour', amount: 500, unit: 'g', foodKey: flour.key)],
      tagIds: [(await db.tagOfKind(TagKind.ingredient))!.id],
    ),
  );
}

Future<int> _burger(AppDatabase db, int bun, {double amount = 4, String unit = 'portion'}) async => db.saveRecipe(
  RecipeDraft(
    name: 'Burger',
    portions: 4,
    ingredients: [
      IngredientDraft(name: 'Brioche bun', amount: amount, unit: unit, foodKey: recipeFoodKey(bun)),
      IngredientDraft(name: 'Salt', amount: 0, unit: 'pinch'),
    ],
  ),
);

double _kcal(Nutrients n) => n[Nutrient.energy]!;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('a recipe counts as an ingredient by portion or by weight', () async {
    final db = _memory();
    final bun = await _bun(db);
    final food = (await recipeFood(db, bun))!;
    expect(food.key, recipeFoodKey(bun));
    expect(food.detail, '1 portion = 60 g');
    expect(_kcal(food.per100g), closeTo(1820 / 4.8, 0.01));

    final byPortion = await recipeNutrition(db, (await db.recipeFull(await _burger(db, bun)))!);
    expect(_kcal(byPortion.perPortion), closeTo(1820 / 8, 0.01), reason: 'one bun per burger');
    final byWeight = await recipeNutrition(db, (await db.recipeFull(await _burger(db, bun, amount: 120, unit: 'g')))!);
    expect(_kcal(byWeight.total), closeTo(1820 / 4, 0.01), reason: '120 g are two 60 g buns');
  });

  test('without a finished weight, a portion is estimated from the raw ingredients', () async {
    final db = _memory();
    final food = (await recipeFood(db, await _bun(db, finishedWeightG: null)))!;
    expect(food.detail, '1 portion ≈ 62.5 g');
    final empty = await db.saveRecipe(RecipeDraft(name: 'Mystery dough', portions: 2));
    final unknown = (await recipeFood(db, empty))!;
    expect(unknown.portions, isEmpty);
    expect(unknown.detail, 'Weight of a portion unknown');
  });

  test('recipes using each other do not loop, and cannot be picked for each other', () async {
    final db = _memory();
    final a = await db.saveRecipe(RecipeDraft(name: 'A', portions: 1));
    final b = await db.saveRecipe(
      RecipeDraft(
        name: 'B',
        portions: 1,
        ingredients: [IngredientDraft(name: 'A', amount: 1, unit: 'portion', foodKey: recipeFoodKey(a))],
      ),
    );
    final c = await db.saveRecipe(
      RecipeDraft(
        name: 'C',
        portions: 1,
        ingredients: [IngredientDraft(name: 'B', amount: 1, unit: 'portion', foodKey: recipeFoodKey(b))],
      ),
    );
    await db.saveRecipe(
      RecipeDraft(
        id: a,
        name: 'A',
        portions: 1,
        ingredients: [IngredientDraft(name: 'C', amount: 1, unit: 'portion', foodKey: recipeFoodKey(c))],
      ),
    );
    expect(await recipesUsing(db, a), {a, b, c});
    final nutrition = await recipeNutrition(db, (await db.recipeFull(a))!);
    expect(nutrition.lines, hasLength(1));
  });

  test('the wheel filter counts the calories of recipes used as ingredients', () async {
    final db = _memory();
    final burger = await _burger(db, await _bun(db));
    final kcal = await WheelService(db).kcalPerPortion((await db.allRecipes()).where((r) => r.id == burger).toList());
    expect(kcal[burger], closeTo(1820 / 8, 0.01));
  });

  test('deleting a recipe keeps it as plain text where it was used', () async {
    final db = _memory();
    final bun = await _bun(db);
    final burger = await _burger(db, bun);
    await db.deleteRecipe(bun);
    final line = (await db.recipeFull(burger))!.ingredients.first;
    expect((line.name, line.amount, line.unit, line.foodKey), ('Brioche bun', 4, 'piece', null));
  });

  test('backups keep the links between recipes, whatever ids they get', () async {
    PhotoStore photos() {
      final dir = Directory.systemTemp.createTempSync('manja_link_');
      addTearDown(() => dir.deleteSync(recursive: true));
      return PhotoStore(dir);
    }

    final phone = _memory();
    await phone.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    await _burger(phone, await _bun(phone));
    final bytes = await ProfileBackup(phone, photos()).export();

    Future<void> expectLinked(AppDatabase pc, String reason) async {
      final recipes = await pc.allRecipes();
      final bun = recipes.singleWhere((r) => r.name == 'Brioche bun');
      final burger = recipes.singleWhere((r) => r.name == 'Burger');
      expect((await pc.recipeFull(burger.id))!.ingredients.first.foodKey, recipeFoodKey(bun.id), reason: reason);
    }

    final fresh = _memory();
    await ProfileBackup(fresh, photos()).import(bytes, replace: true);
    await expectLinked(fresh, 'fresh phone');

    final busy = _memory();
    for (final n in ['Grah', 'Burek', 'Ćevapi', 'Pita']) {
      await busy.saveRecipe(RecipeDraft(name: n, portions: 2));
    }
    await ProfileBackup(busy, photos()).import(bytes, replace: false);
    await expectLinked(busy, 'other recipes took the old ids');

    final ownBun = _memory();
    await ownBun.saveRecipe(RecipeDraft(name: 'Pita', portions: 2));
    final existingBun = await ownBun.saveRecipe(RecipeDraft(name: 'Brioche bun', portions: 6));
    await ProfileBackup(ownBun, photos()).import(bytes, replace: false);
    await expectLinked(ownBun, 'the bun already there is used');
    expect((await ownBun.allRecipes()).where((r) => r.name == 'Brioche bun').single.id, existingBun);
  });

  testWidgets('a recipe tagged Ingredient can be linked, in portions, and shows on the recipe page', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = _memory();
    await _bun(db);
    await db.saveRecipe(RecipeDraft(name: 'Burger sauce', portions: 4));
    await tester.pumpWidget(_scope(db, const MaterialApp(home: RecipeEditScreen())));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Burger');
    await tester.enterText(find.widgetWithText(TextFormField, 'Qty'), '1');
    await tester.tap(find.text('Link nutrition'));
    await tester.pumpAndSettle();
    expect(find.text('Burger sauce'), findsNothing, reason: 'only recipes tagged Ingredient');
    await tester.tap(find.text('Brioche bun'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Brioche bun'), findsOneWidget, reason: 'the name is filled in');
    expect(find.text('portion'), findsOneWidget);
    await tester.tap(find.text('portion'));
    await tester.pumpAndSettle();
    expect([
      for (final w in tester.widgetList<DropdownMenuItem<CookingUnit>>(find.byType(DropdownMenuItem<CookingUnit>)))
        w.value,
    ], containsAll(recipeUnits));
    expect(find.text('ml').hitTestable(), findsNothing, reason: 'no volumes for recipes');
    await tester.tap(find.text('portion').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final burger = (await db.allRecipes()).singleWhere((r) => r.name == 'Burger');
    final line = (await db.recipeFull(burger.id))!.ingredients.single;
    expect((line.unit, line.foodKey?.startsWith('recipe:')), ('portion', true));

    await tester.pumpWidget(
      _scope(
        db,
        MaterialApp(
          key: UniqueKey(),
          home: RecipeDetailScreen(recipeId: burger.id),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 portion'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    expect(find.text('1.5 portions'), findsOneWidget);
  });
}
