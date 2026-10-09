import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/data/database.dart';
import 'package:manja/domain/units.dart';
import 'package:manja/domain/wheel_service.dart';

void main() {
  group('units', () {
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

    test('a new round starts after the last meal even within the same clock tick', () async {
      await addRecipes(['Burek', 'Ćevapi', 'Sarma']);
      final recipes = await db.allRecipes();
      final t = DateTime(2026, 3, 1, 12);
      await wheel.resetCycle(t.subtract(const Duration(days: 1)));
      await db.logMeal(recipes[0].id, t.subtract(const Duration(hours: 2)));
      await db.logMeal(recipes[1].id, t.subtract(const Duration(hours: 1)));
      await db.logMeal(recipes[2].id, t);

      expect((await wheel.computeState(now: t)).available, hasLength(3));
      expect((await wheel.computeState(now: t.add(const Duration(minutes: 1)))).available, hasLength(3));

      await wheel.saveSettings(ResetMode.manual, 7);
      await db.logMeal(recipes[0].id, t.add(const Duration(minutes: 2)));
      await wheel.resetCycle(t.add(const Duration(minutes: 2)));
      expect((await wheel.computeState(now: t.add(const Duration(minutes: 3)))).available, hasLength(3));
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

    test('appearance defaults and round-trips through the settings table', () async {
      final defaults = await wheel.loadAppearance();
      expect(defaults.flipText, isTrue);
      expect(defaults.content, WheelContent.both);
      expect(defaults.maxSlices, 20);
      expect(defaults.winnerPercent, 100);
      expect(defaults.theme, WheelThemeKind.classic);
      await wheel.saveAppearance(
        const WheelAppearance(
          content: WheelContent.photo,
          maxSlices: 8,
          winnerPercent: 40,
          flipText: false,
          theme: WheelThemeKind.burek,
        ),
      );
      final saved = await wheel.loadAppearance();
      expect(saved.theme, WheelThemeKind.burek);
      expect(saved.flipText, isFalse);
      expect(saved.content, WheelContent.photo);
      expect(saved.maxSlices, 8);
      expect(saved.winnerPercent, 40);
      await db.setSetting('wheel.winnerPercent', '5');
      expect((await wheel.loadAppearance()).winnerPercent, WheelAppearance.minWinnerPercent);
      await db.setSetting('wheel.maxSlices', '999');
      expect((await wheel.loadAppearance()).maxSlices, WheelAppearance.maxSlicesLimit);
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
