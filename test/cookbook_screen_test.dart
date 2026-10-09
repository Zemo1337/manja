import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/cookbook_pdf.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/cookbook/cookbook_screen.dart';
import 'package:nutrition_core/nutrition_core.dart';

AppScope _scope(AppDatabase db, Widget child) => AppScope(
  db: db,
  wheel: WheelService(db),
  photos: PhotoStore(Directory.systemTemp),
  nutrition: NutritionRepository(db),
  child: child,
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  AppDatabase memory() {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    return db;
  }

  testWidgets('recipes for the cookbook can be all, favorites or chosen', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 4000)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = memory();
    await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4, isFavorite: true));
    await db.saveRecipe(RecipeDraft(name: 'Ćevapi', portions: 4));
    await db.saveRecipe(RecipeDraft(name: 'Burek', portions: 4));
    await tester.pumpWidget(_scope(db, const MaterialApp(home: CookbookScreen())));
    await tester.pumpAndSettle();

    expect(find.text('Create PDF with 3 recipes'), findsOneWidget);
    await tester.tap(find.text('Favorites (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Create PDF with 1 recipe'), findsOneWidget);

    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    final names = [
      for (final t in tester.widgetList<CheckboxListTile>(find.byType(CheckboxListTile))) (t.title! as Text).data,
    ];
    expect(names, ['Burek', 'Ćevapi', 'Sarma']);
    await tester.tap(find.text('Burek'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Chosen (2)'), findsOneWidget);
    expect(find.text('Create PDF with 2 recipes'), findsOneWidget);

    await tester.tap(find.text('Recipe cards'));
    await tester.pumpAndSettle();
    expect(find.text(CookbookLayout.cards.description), findsOneWidget);
  });

  test('loading a recipe brings its nutrition per portion', () async {
    final db = memory();
    final scope = _scope(db, const SizedBox());
    final rice = await scope.nutrition.saveUserFood(name: 'Rice', per100g: Nutrients.of(energyKcal: 360, protein: 7));
    final id = await db.saveRecipe(
      RecipeDraft(
        name: 'Rižoto',
        portions: 2,
        ingredients: [
          IngredientDraft(name: 'riža', amount: 200, unit: 'g', foodKey: rice.key),
          IngredientDraft(name: 'parmezan', amount: 50, unit: 'g'),
        ],
      ),
    );
    final empty = await db.saveRecipe(RecipeDraft(name: 'Voda', portions: 1));

    final loaded = await loadCookbookRecipes(scope, [id, empty], photos: true);
    expect(loaded.first.perPortion?[Nutrient.energy], 360);
    expect(loaded.first.complete, isFalse, reason: 'parmezan has no linked food');
    expect(loaded.last.perPortion, isNull);
  });
}
