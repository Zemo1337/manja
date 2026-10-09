import 'package:flutter_test/flutter_test.dart';
import 'package:manja/domain/pantry_matcher.dart';

MatchRecipe<String> recipe(String name, List<String> ingredients) =>
    MatchRecipe(name, [for (final i in ingredients) MatchIngredient(i)]);

void main() {
  group('words', () {
    test('inflections share a stem', () {
      expect(stemWord('jaja'), stemWord('jaje'));
      expect(stemWord('brašno'), stemWord('brašna'));
      expect(stemWord('mlijeko'), stemWord('mlijeka'));
      expect(stemWord('eggs'), stemWord('egg'));
      expect(stemWord('onions'), stemWord('onion'));
      expect(stemWord('tomatoes'), stemWord('tomato'));
      expect(stemWord('soli'), stemWord('sol'));
      expect(stemWord('ulje'), stemWord('ulja'));
    });

    test('different foods stay different', () {
      expect(stemWord('salt'), isNot(stemWord('salmon')));
      expect(stemWord('rice'), isNot(stemWord('ricotta')));
      expect(stemWord('butter'), isNot(stemWord('buttermilk')));
    });
  });

  group('one ingredient', () {
    test('pantry words must all appear in the ingredient', () {
      expect(ingredientMatches(const MatchIngredient('large eggs'), const AvailableIngredient('eggs')), isTrue);
      expect(
        ingredientMatches(const MatchIngredient('red onions, chopped'), const AvailableIngredient('onion')),
        isTrue,
      );
      expect(
        ingredientMatches(const MatchIngredient('mekog pšeničnog brašna'), const AvailableIngredient('Brašno')),
        isTrue,
      );
      expect(
        ingredientMatches(const MatchIngredient('olive oil'), const AvailableIngredient('sunflower oil')),
        isFalse,
      );
      expect(
        ingredientMatches(const MatchIngredient('butter (softened)'), const AvailableIngredient('butter')),
        isTrue,
      );
      expect(ingredientMatches(const MatchIngredient('buttermilk'), const AvailableIngredient('butter')), isFalse);
    });

    test('a shared food link always matches', () {
      expect(
        ingredientMatches(
          const MatchIngredient('mlijeko', foodKey: 'usda:171265'),
          const AvailableIngredient('whole milk', foodKey: 'usda:171265'),
        ),
        isTrue,
      );
    });

    test("the linked food's name is used too", () {
      expect(
        ingredientMatches(
          const MatchIngredient('toplog mleka', foodName: 'Milk, whole, 3.25% milkfat'),
          const AvailableIngredient('milk'),
        ),
        isTrue,
      );
    });

    test('water is always there', () {
      expect(alwaysAvailable(const MatchIngredient('water')), isTrue);
      expect(alwaysAvailable(const MatchIngredient('Voda')), isTrue);
      expect(alwaysAvailable(const MatchIngredient('coconut water')), isFalse);
    });
  });

  group('recipes', () {
    final recipes = [
      recipe('Palačinke', ['brašno', 'mlijeko', 'jaja', 'sol']),
      recipe('Omelette', ['3 eggs', 'salt', 'water']),
      recipe('Pasta', ['spaghetti', 'olive oil', 'garlic', 'salt']),
      recipe('Burek', ['yufka dough', 'minced beef', 'onion', 'oil', 'salt']),
      recipe('Empty', []),
    ];
    const pantry = [
      AvailableIngredient('salt'),
      AvailableIngredient('sol'),
      AvailableIngredient('eggs'),
      AvailableIngredient('jaje'),
      AvailableIngredient('brašno'),
      AvailableIngredient('olive oil'),
    ];

    test('complete recipes first, then those missing one or two', () {
      final result = matchRecipes(recipes, pantry: pantry);
      expect([for (final m in result) m.recipe], ['Omelette', 'Palačinke', 'Pasta']);
      expect(result[0].complete, isTrue);
      expect(result[1].missing.map((i) => i.name), ['mlijeko']);
      expect(result[2].missing.map((i) => i.name), ['spaghetti', 'garlic']);
    });

    test('recipes using fewer ingredients than available still count', () {
      final result = matchRecipes(
        recipes,
        pantry: [...pantry, const AvailableIngredient('mlijeko'), const AvailableIngredient('cheese')],
      );
      expect(result.where((m) => m.complete).map((m) => m.recipe), containsAll(['Omelette', 'Palačinke']));
    });

    test('with cravings, only recipes using one of them show up', () {
      final result = matchRecipes(recipes, pantry: pantry, cravings: const [AvailableIngredient('garlic')]);
      expect([for (final m in result) m.recipe], ['Pasta']);
      expect(result.single.missing.map((i) => i.name), ['spaghetti']);
      expect(result.single.cravingsUsed, 1);
    });

    test('maxMissing limits the near misses', () {
      final result = matchRecipes(recipes, pantry: pantry, maxMissing: 0);
      expect([for (final m in result) m.recipe], ['Omelette']);
    });
  });
}
