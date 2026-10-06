import 'dart:math';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/domain/units.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/wheel/wheel_painter.dart';

void main() {
  group('wheel geometry', () {
    test('target rotation lands the pointer on the chosen slice', () {
      final random = Random(1);
      for (var count = 1; count <= 20; count++) {
        var rotation = 0.0;
        for (var round = 0; round < 50; round++) {
          final index = random.nextInt(count);
          final jitter = (random.nextDouble() - 0.5) * 0.7;
          rotation = targetRotation(current: rotation, index: index, count: count, fullSpins: 5, jitter: jitter);
          expect(indexAtPointer(rotation, count), index, reason: 'count=$count round=$round');
          rotation %= 2 * pi;
        }
      }
    });

    test('target rotation always spins forward by at least the full spins', () {
      final end = targetRotation(current: 1.0, index: 0, count: 4, fullSpins: 5);
      expect(end - 1.0, greaterThanOrEqualTo(5 * 2 * pi));
      expect(end - 1.0, lessThan(6 * 2 * pi));
    });
  });

  group('units', () {
    test('mass converts to grams, volume needs density', () {
      expect(CookingUnit.kg.toGrams(1.5), 1500);
      expect(CookingUnit.oz.toGrams(1), closeTo(28.35, 0.01));
      expect(CookingUnit.cup.toGrams(1), isNull);
      expect(CookingUnit.cup.toGrams(1, densityGPerMl: 0.53), closeTo(125.4, 0.1));
      expect(CookingUnit.piece.toGrams(2, gramsPerPiece: 60), 120);
    });

    test('formats amounts without trailing zeros', () {
      expect(formatAmount(2), '2');
      expect(formatAmount(1.5), '1.5');
      expect(formatAmount(0.333333), '0.33');
    });
  });

  group('wheel service', () {
    late AppDatabase db;
    late WheelService wheel;

    setUp(() {
      db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
      wheel = WheelService(db);
    });

    tearDown(() => db.close());

    Future<void> addRecipes(List<String> names) async {
      for (final name in names) {
        await db.saveRecipe(RecipeDraft(name: name, portions: 2));
      }
    }

    test('eaten dishes leave the wheel and it refills when empty', () async {
      await addRecipes(['Burek', 'Ćevapi', 'Sarma']);
      var state = await wheel.computeState();
      expect(state.available.length, 3);

      await wheel.confirmMeal(state.available.first);
      state = await wheel.computeState();
      expect(state.available.length, 2);
      expect(state.eaten, 1);

      for (final r in state.available) {
        await wheel.confirmMeal(r);
      }
      state = await wheel.computeState();
      expect(state.available.length, 3, reason: 'whenEmpty mode starts a new round');
    });

    test('manual mode stays empty until reset', () async {
      await addRecipes(['Burek', 'Sarma']);
      await wheel.saveSettings(ResetMode.manual, 7);
      for (final r in (await wheel.computeState()).available) {
        await wheel.confirmMeal(r);
      }
      var state = await wheel.computeState();
      expect(state.exhausted, isTrue);

      await wheel.resetCycle(DateTime.now().add(const Duration(seconds: 1)));
      state = await wheel.computeState();
      expect(state.available.length, 2);
    });

    test('afterDays mode starts a new round once the period passed', () async {
      await addRecipes(['Burek', 'Sarma']);
      await wheel.saveSettings(ResetMode.afterDays, 3);
      final start = DateTime(2026, 1, 1);
      await wheel.resetCycle(start);
      await db.logMeal((await db.allRecipes()).first.id, start.add(const Duration(hours: 1)));

      var state = await wheel.computeState(now: start.add(const Duration(days: 2)));
      expect(state.available.length, 1);

      state = await wheel.computeState(now: start.add(const Duration(days: 3)));
      expect(state.available.length, 2);
    });

    test('saving a recipe replaces its ingredients and steps', () async {
      final id = await db.saveRecipe(RecipeDraft(
        name: 'Pita',
        portions: 4,
        ingredients: [IngredientDraft(name: 'Flour', amount: 500, unit: 'g')],
        steps: ['Knead', 'Bake'],
      ));
      await db.saveRecipe(RecipeDraft(
        id: id,
        name: 'Pita',
        portions: 4,
        ingredients: [
          IngredientDraft(name: 'Flour', amount: 450, unit: 'g'),
          IngredientDraft(name: 'Water', amount: 1, unit: 'cup'),
        ],
        steps: ['Bake'],
      ));
      final full = await db.recipeFull(id);
      expect(full!.ingredients.map((i) => i.name), ['Flour', 'Water']);
      expect(full.ingredients.first.amount, 450);
      expect(full.steps.map((s) => s.body), ['Bake']);
    });
  });
}
