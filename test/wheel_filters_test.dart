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
import 'package:manja/main.dart';
import 'package:nutrition_core/nutrition_core.dart';

Future<(AppDatabase, WheelService)> _kitchen() async {
  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  addTearDown(db.close);
  final nutrition = NutritionRepository(db);
  final greens = await nutrition.saveUserFood(name: 'Greens', per100g: Nutrients.of(energyKcal: 100));
  final pasta = await nutrition.saveUserFood(name: 'Pasta bake', per100g: Nutrients.of(energyKcal: 300));
  await db.saveRecipe(
    RecipeDraft(
      name: 'Salad',
      portions: 1,
      prepMinutes: 10,
      ingredients: [IngredientDraft(name: 'greens', amount: 200, unit: 'g', foodKey: greens.key)],
    ),
  );
  await db.saveRecipe(
    RecipeDraft(
      name: 'Lasagne',
      portions: 2,
      prepMinutes: 30,
      cookMinutes: 60,
      ingredients: [IngredientDraft(name: 'pasta bake', amount: 1000, unit: 'g', foodKey: pasta.key)],
    ),
  );
  await db.saveRecipe(RecipeDraft(name: 'Grah', portions: 4));
  return (db, WheelService(db));
}

Future<List<String>> _names(WheelService wheel) async => [
  for (final r in (await wheel.computeState()).available) r.name,
];

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('filters allow dishes within the limits and decide about unknown values', () {
    const f = WheelFilters(maxKcal: 600, maxMinutes: 30);
    expect(f.allows(kcal: 500, minutes: 20), isTrue);
    expect(f.allows(kcal: 650, minutes: 20), isFalse);
    expect(f.allows(kcal: 500, minutes: 45), isFalse);
    expect(f.allows(), isTrue);
    expect(const WheelFilters(maxKcal: 600, includeUnknown: false).allows(minutes: 5), isFalse);
    expect(const WheelFilters().active, isFalse);
  });

  test('calories per portion come from linked ingredients and drive the wheel', () async {
    final (db, wheel) = await _kitchen();
    final recipes = await db.allRecipes();
    final kcal = await wheel.kcalPerPortion(recipes);
    expect({for (final r in recipes) r.name: kcal[r.id]}, {'Salad': 200, 'Lasagne': 1500, 'Grah': null});

    await wheel.saveFilters(const WheelFilters(maxKcal: 700));
    expect(await _names(wheel), ['Grah', 'Salad']);
    expect((await wheel.computeState()).filteredOut, 1);

    await wheel.saveFilters(const WheelFilters(maxKcal: 700, includeUnknown: false));
    expect(await _names(wheel), ['Salad']);

    await wheel.saveFilters(const WheelFilters(maxMinutes: 30));
    expect(await _names(wheel), ['Grah', 'Salad']);

    await wheel.saveFilters(const WheelFilters());
    expect(await _names(wheel), ['Grah', 'Lasagne', 'Salad']);
    expect(await wheel.loadFilters(), isA<WheelFilters>().having((f) => f.active, 'active', isFalse));
  });

  testWidgets('the filter sheet narrows the wheel and filters can be cleared', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final (db, wheel) = await _kitchen();
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

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calories per portion'));
    await tester.pumpAndSettle();
    expect(find.text('Up to 700 kcal per portion'), findsOneWidget);
    await tester.tap(find.text('Total time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Include dishes with unknown values'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('1 of 1 dishes left'), findsOneWidget);
    expect(find.text('Up to 700 kcal · up to 30 min · 2 hidden'), findsOneWidget);

    await wheel.saveFilters(const WheelFilters(maxKcal: 200, maxMinutes: 5, includeUnknown: false));
    await tester.pumpAndSettle();
    expect(find.text('No dishes match your filters'), findsOneWidget);
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('3 of 3 dishes left'), findsOneWidget);
  });
}
