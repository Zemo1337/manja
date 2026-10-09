import 'package:nutrition_core/nutrition_core.dart';
import 'package:test/test.dart';

void expectParsed(String line, double? amount, CookingUnit? unit, String name, {String? note}) {
  final p = parseIngredientLine(line);
  expect(p.amount, amount == null ? isNull : closeTo(amount, 1e-9), reason: '$line → amount');
  expect(p.unit, unit, reason: '$line → unit');
  expect(p.name, name, reason: '$line → name');
  if (note != null) expect(p.note, note, reason: '$line → note');
}

void main() {
  group('English (Tastes Better From Scratch style)', () {
    test('mixed fractions with a hyphen', () {
      expectParsed('1-1/2 cups granulated sugar', 1.5, CookingUnit.cup, 'granulated sugar');
    });
    test('double parentheses become a note', () {
      expectParsed(
        '1 cup plain Greek yogurt ((or sour cream))',
        1,
        CookingUnit.cup,
        'plain Greek yogurt',
        note: 'or sour cream',
      );
      expectParsed('1/2 cup butter (softened)', 0.5, CookingUnit.cup, 'butter', note: 'softened');
    });
    test('counts without a unit are pieces', () {
      expectParsed('2 large eggs', 2, CookingUnit.piece, 'large eggs');
    });
    test('abbreviations, plurals and vulgar fractions', () {
      expectParsed('½ tsp salt', 0.5, CookingUnit.tsp, 'salt');
      expectParsed('1½ cups milk', 1.5, CookingUnit.cup, 'milk');
      expectParsed('2 Tbsp. olive oil', 2, CookingUnit.tbsp, 'olive oil');
      expectParsed('1 T butter', 1, CookingUnit.tbsp, 'butter');
      expectParsed('1 t vanilla', 1, CookingUnit.tsp, 'vanilla');
      expectParsed('1 c. flour', 1, CookingUnit.cup, 'flour');
      expectParsed('8 fl oz cream', 8, CookingUnit.flOz, 'cream');
      expectParsed('2 lbs chicken thighs', 2, CookingUnit.lb, 'chicken thighs');
    });
    test('comma notes and "of"', () {
      expectParsed('3 cloves garlic, minced', 3, CookingUnit.clove, 'garlic', note: 'minced');
      expectParsed('1 cup of rice', 1, CookingUnit.cup, 'rice');
      expectParsed('1 (14 oz) can diced tomatoes', 1, CookingUnit.can, 'diced tomatoes', note: '14 oz');
    });
    test('ranges take the lower value', () {
      expectParsed('2-3 apples', 2, CookingUnit.piece, 'apples');
      expectParsed('2 to 3 tbsp honey', 2, CookingUnit.tbsp, 'honey');
    });
    test('no amount', () {
      expectParsed('salt to taste', null, null, 'salt to taste');
      expectParsed('Fresh parsley, chopped', null, null, 'Fresh parsley', note: 'chopped');
    });
  });

  group('Croatian, Bosnian and Serbian (Coolinarika style)', () {
    test('metric with decilitres', () {
      expectParsed('2 dl toplog mleka', 2, CookingUnit.dl, 'toplog mleka');
      expectParsed('400 g mekog pšeničnog brašna', 400, CookingUnit.g, 'mekog pšeničnog brašna');
      expectParsed('1,5 kg krumpira', 1.5, CookingUnit.kg, 'krumpira');
    });
    test('decagrams become grams', () {
      expectParsed('25 dag šećera', 250, CookingUnit.g, 'šećera');
      expectParsed('10 dkg maslaca', 100, CookingUnit.g, 'maslaca');
    });
    test('spoons, cups, pinches and pieces', () {
      expectParsed('2 žlice ulja', 2, CookingUnit.tbsp, 'ulja');
      expectParsed('1 žličica soli', 1, CookingUnit.tsp, 'soli');
      expectParsed('1 kašika paprike', 1, CookingUnit.tbsp, 'paprike');
      expectParsed('1 šolja pirinča', 1, CookingUnit.cup, 'pirinča');
      expectParsed('prstohvat soli', null, null, 'prstohvat soli');
      expectParsed('1 prstohvat soli', 1, CookingUnit.pinch, 'soli');
      expectParsed('3 češnja češnjaka', 3, CookingUnit.clove, 'češnjaka');
      expectParsed('2 kom jaja', 2, CookingUnit.piece, 'jaja');
    });
  });

  test('German spoons', () {
    expectParsed('2 EL Öl', 2, CookingUnit.tbsp, 'Öl');
    expectParsed('1 TL Salz', 1, CookingUnit.tsp, 'Salz');
  });

  group('conversion', () {
    const flour = Food(
      source: FoodSource.user,
      sourceId: 'f',
      name: 'Flour',
      per100g: Nutrients({}),
      portions: [FoodPortion(label: '1 cup', grams: 125, unit: CookingUnit.cup)],
    );

    test('within the same kind no food is needed', () {
      expect(convertAmount(2, CookingUnit.dl, CookingUnit.ml), closeTo(200, 1e-9));
      expect(convertAmount(1, CookingUnit.cup, CookingUnit.ml), closeTo(236.5882365, 1e-9));
      expect(convertAmount(1, CookingUnit.lb, CookingUnit.g), closeTo(453.59237, 1e-9));
      expect(convertAmount(1, CookingUnit.cup, CookingUnit.g), isNull, reason: 'volume to mass needs a food');
    });

    test('volume and mass convert through the food', () {
      expect(convertAmount(2, CookingUnit.cup, CookingUnit.g, food: flour), closeTo(250, 1e-9));
      expect(convertAmount(250, CookingUnit.g, CookingUnit.cup, food: flour), closeTo(2, 1e-9));
      expect(convertAmount(1, CookingUnit.dl, CookingUnit.g, food: flour), closeTo(125 / 236.5882365 * 100, 1e-9));
      expect(convertAmount(1, CookingUnit.piece, CookingUnit.g, food: flour), isNull);
    });
  });
}
