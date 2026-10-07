import 'package:nutrition_core/nutrition_core.dart';
import 'package:test/test.dart';

const flour = Food(
  source: FoodSource.user,
  sourceId: 'flour',
  name: 'Wheat flour',
  per100g: Nutrients({
    Nutrient.energy: 364,
    Nutrient.protein: 10.3,
    Nutrient.fat: 1,
    Nutrient.carbohydrate: 76.3,
    Nutrient.fiber: 2.7,
    Nutrient.sodium: 2,
  }),
  portions: [FoodPortion(label: '1 cup', grams: 125, unit: CookingUnit.cup)],
);

const milk = Food(
  source: FoodSource.user,
  sourceId: 'milk',
  name: 'Milk 3.5 %',
  per100g: Nutrients({Nutrient.energy: 64, Nutrient.protein: 3.3, Nutrient.fat: 3.5, Nutrient.carbohydrate: 4.8}),
  densityGPerMl: 1.03,
);

const egg = Food(
  source: FoodSource.user,
  sourceId: 'egg',
  name: 'Egg',
  per100g: Nutrients({Nutrient.energy: 143, Nutrient.protein: 12.6, Nutrient.fat: 9.5, Nutrient.sodium: 142}),
  portions: [FoodPortion(label: '1 large', grams: 50)],
);

const sugar = Food(
  source: FoodSource.user,
  sourceId: 'sugar',
  name: 'Sugar',
  per100g: Nutrients({Nutrient.energy: 387, Nutrient.carbohydrate: 100, Nutrient.sugars: 100}),
  portions: [FoodPortion(label: '2 tbsp', grams: 25, unit: CookingUnit.tbsp, amount: 2)],
);

void main() {
  group('nutrients', () {
    test('scale and add', () {
      final a = Nutrients.of(energyKcal: 100, protein: 10);
      final b = Nutrients.of(energyKcal: 50, fat: 2);
      final sum = a.scaled(2) + b;
      expect(sum[Nutrient.energy], 250);
      expect(sum[Nutrient.protein], 20);
      expect(sum[Nutrient.fat], 2);
      expect(sum.has(Nutrient.fiber), isFalse);
    });

    test('salt is derived from sodium', () {
      expect(Nutrients.of(sodiumMg: 400).saltG, closeTo(1.0, 1e-9));
      expect(Nutrients.empty.saltG, isNull);
    });

    test('json round trip', () {
      expect(Nutrients.fromJson(flour.per100g.toJson()), flour.per100g);
    });
  });

  group('grams', () {
    test('mass units convert directly', () {
      expect(gramsFor(flour, 1.5, CookingUnit.kg), 1500);
      expect(gramsFor(flour, 1, CookingUnit.oz), closeTo(28.35, 0.01));
    });

    test('volume uses the food density or a volume portion', () {
      expect(gramsFor(milk, 250, CookingUnit.ml), closeTo(257.5, 1e-9));
      expect(gramsFor(flour, 2, CookingUnit.cup), closeTo(250, 1e-9));
      expect(gramsFor(flour, 1, CookingUnit.tbsp), closeTo(125 / 16, 0.01));
      expect(gramsFor(sugar, 1, CookingUnit.tbsp), closeTo(12.5, 1e-9));
      expect(gramsFor(egg, 1, CookingUnit.cup), isNull);
    });

    test('counts use a matching portion, pieces fall back to a generic portion', () {
      expect(gramsFor(egg, 3, CookingUnit.piece), 150);
      expect(gramsFor(egg, 1, CookingUnit.slice), isNull);
      expect(gramsFor(flour, 1, CookingUnit.piece), isNull);
    });
  });

  group('search ranking', () {
    List<String> rank(String query, Map<String, bool> names) {
      final list = names.keys.toList()
        ..sort((a, b) => searchScore(query, b, hasPortions: names[b]!).compareTo(searchScore(query, a, hasPortions: names[a]!)));
      return list;
    }

    test('the basic ingredient beats things that merely contain the word', () {
      expect(
        rank('milk', {
          'Crackers, milk': true,
          'SILK Nog, soymilk': true,
          'Milk, whole, 3.25% milkfat, with added vitamin D': true,
          'Buttermilk, low fat': false,
        }).first,
        'Milk, whole, 3.25% milkfat, with added vitamin D',
      );
      expect(
        rank('egg', {
          'Eggnog': true,
          'Bread, egg': true,
          'Egg, whole, raw, fresh': true,
          'Eggplant, raw': true,
        }).first,
        'Egg, whole, raw, fresh',
      );
      expect(rank('onion', {'Onion rings, breaded': true, 'Onions, raw': true}).first, 'Onions, raw');
    });

    test('foods with portions win over the same food without', () {
      expect(
        rank('flour wheat all-purpose', {
          'Flour, wheat, all-purpose, enriched, bleached': false,
          'Wheat flour, white, all-purpose, enriched, bleached': true,
        }).first,
        'Wheat flour, white, all-purpose, enriched, bleached',
      );
    });

    test('brand products rank below generic foods', () {
      expect(rank('soymilk', {'SILK Plain, soymilk': true, 'Soymilk, original and vanilla, unfortified': true}).first,
          'Soymilk, original and vanilla, unfortified');
    });
  });

  group('recipe', () {
    final lines = [
      const IngredientLine(name: 'Flour', amount: 250, unit: CookingUnit.g, food: flour),
      const IngredientLine(name: 'Milk', amount: 500, unit: CookingUnit.ml, food: milk),
      const IngredientLine(name: 'Eggs', amount: 3, unit: CookingUnit.piece, food: egg),
      const IngredientLine(name: 'Sugar', amount: 2, unit: CookingUnit.tbsp, food: sugar),
      const IngredientLine(name: 'Salt', amount: 1, unit: CookingUnit.pinch),
    ];

    test('totals, per portion and per 100 g', () {
      final r = RecipeNutrition.calculate(lines, portions: 4);
      const energy = 364 * 2.5 + 64 * 5.15 + 143 * 1.5 + 387 * 0.25;
      expect(r.total[Nutrient.energy], closeTo(energy, 1e-6));
      expect(r.ingredientWeightG, closeTo(250 + 515 + 150 + 25, 1e-9));
      expect(r.perPortion[Nutrient.energy], closeTo(energy / 4, 1e-6));
      expect(r.per100g[Nutrient.energy], closeTo(energy / 940 * 100, 1e-6));
      expect(r.perWeight(250)[Nutrient.energy], closeTo(energy / 940 * 250, 1e-6));
      expect(r.portionWeightG, closeTo(235, 1e-9));
    });

    test('lines without a food are reported, not guessed', () {
      final r = RecipeNutrition.calculate(lines, portions: 4);
      expect(r.complete, isFalse);
      expect(r.missing.single.line.name, 'Salt');
      expect(r.missing.single.issue, LineIssue.noFood);
      final unknown = RecipeNutrition.calculate(
        [const IngredientLine(name: 'Egg', amount: 1, unit: CookingUnit.cup, food: egg)],
        portions: 1,
      );
      expect(unknown.missing.single.issue, LineIssue.unknownWeight);
    });

    test('nutrients missing for some counted foods are flagged as partial', () {
      final r = RecipeNutrition.calculate(lines, portions: 4);
      expect(r.partial, containsAll([Nutrient.fiber, Nutrient.sugars, Nutrient.sodium]));
      expect(r.partial, isNot(contains(Nutrient.energy)));
    });

    test('a weighed finished dish replaces the ingredient weight', () {
      final r = RecipeNutrition.calculate(lines, portions: 4, finishedWeightG: 800);
      expect(r.totalWeightG, 800);
      expect(r.per100g[Nutrient.energy], closeTo(r.total[Nutrient.energy]! / 8, 1e-6));
      expect(r.perPortion, r.total.scaled(1 / 4));
    });

    test('portions must be positive', () {
      expect(() => RecipeNutrition.calculate(lines, portions: 0), throwsArgumentError);
    });
  });
}
