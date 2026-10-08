import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/nutrition/ingredients_screen.dart';
import 'package:nutrition_core/nutrition_core.dart';

class SlowUsda implements NutritionSource {
  Completer<Food?>? pending;

  @override
  FoodSource get source => FoodSource.usda;

  @override
  Future<Food?> fetch(String sourceId) => (pending = Completer<Food?>()).future;

  @override
  Future<List<FoodSummary>> search(String query, {int limit = 25}) async => const [];
}

final _milk = Food(
  source: FoodSource.usda,
  sourceId: '171265',
  name: 'Milk, whole',
  per100g: Nutrients.of(energyKcal: 61),
);

void main() {
  testWidgets('updating a USDA ingredient shows a spinner until USDA answers', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final usda = SlowUsda();
    final repo = NutritionRepository(db, remotes: {FoodSource.usda: usda});
    await repo.store(_milk);
    await db.saveRecipe(RecipeDraft(
      name: 'Palačinke',
      portions: 4,
      ingredients: [IngredientDraft(name: 'Milk', amount: 500, unit: 'ml', foodKey: _milk.key)],
    ));

    await tester.pumpWidget(AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(Directory.systemTemp),
      nutrition: repo,
      child: const MaterialApp(home: IngredientsScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.text('USDA ingredients in your recipes (1)'), findsOneWidget);

    await tester.tap(find.text('Milk, whole'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update from USDA'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('updating')), findsOneWidget);
    expect(find.text('Asking USDA for the latest values…'), findsOneWidget);

    await tester.tap(find.text('Milk, whole'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      tester
          .widget<ButtonStyleButton>(find.ancestor(
            of: find.text('Updating…'),
            matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
          ))
          .onPressed,
      isNull,
      reason: 'no second update while one is running',
    );
    await tester.tapAt(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 500));

    usda.pending!.complete(Food(
      source: FoodSource.usda,
      sourceId: '171265',
      name: 'Milk, whole, 3.25% milkfat',
      per100g: Nutrients.of(energyKcal: 61),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('updating')), findsNothing);
    expect(find.text('Updated "Milk, whole, 3.25% milkfat"'), findsOneWidget);
    expect(find.text('Milk, whole, 3.25% milkfat'), findsOneWidget);
  });

  testWidgets('a failed update stops the spinner and explains why', (tester) async {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final usda = SlowUsda();
    final repo = NutritionRepository(db, remotes: {FoodSource.usda: usda});
    await repo.store(_milk);
    await db.saveRecipe(RecipeDraft(
      name: 'Palačinke',
      portions: 4,
      ingredients: [IngredientDraft(name: 'Milk', amount: 500, unit: 'ml', foodKey: _milk.key)],
    ));
    await tester.pumpWidget(AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(Directory.systemTemp),
      nutrition: repo,
      child: const MaterialApp(home: IngredientsScreen()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Milk, whole'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update from USDA'));
    await tester.pump();

    usda.pending!.completeError(
      const NutritionSourceException('USDA did not answer in time', kind: NutritionErrorKind.unreachable),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('updating')), findsNothing);
    expect(find.textContaining('USDA could not be reached'), findsOneWidget);
  });
}
