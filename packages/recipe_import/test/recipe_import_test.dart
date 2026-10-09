import 'dart:convert';

import 'package:nutrition_core/nutrition_core.dart';
import 'package:recipe_import/recipe_import.dart';
import 'package:test/test.dart';

final wordpressGraph = jsonEncode({
  '@context': 'https://schema.org',
  '@graph': [
    {'@type': 'Article', 'headline': 'Our favourite plum cake'},
    {'@type': 'WebPage', 'name': 'Plum cake'},
    {
      '@type': 'Recipe',
      'name': 'Plum Cake &amp; Walnuts',
      'description': '<p>A soft <b>yeast</b> cake.</p>',
      'image': [
        'https://example.com/img/plum-cake-1.jpg',
        'https://example.com/img/plum-cake-2.jpg',
      ],
      'recipeYield': ['12', '12 pieces'],
      'prepTime': 'PT20M',
      'cookTime': 'PT1H5M',
      'totalTime': 'PT1H25M',
      'recipeIngredient': [
        '1-1/2 cups all-purpose flour',
        '1/2 cup butter ((softened))',
        '2 large eggs',
        'pinch of salt',
      ],
      'recipeInstructions': [
        {
          '@type': 'HowToSection',
          'name': 'Dough',
          'itemListElement': [
            {'@type': 'HowToStep', 'name': 'Mix', 'text': 'Mix the flour &amp; butter.'},
            {'@type': 'HowToStep', 'text': 'Add the eggs.'},
          ],
        },
        {'@type': 'HowToStep', 'text': 'Bake at 180&nbsp;°C.'},
      ],
    },
  ],
});

final flatRecipe = jsonEncode({
  '@context': 'https://schema.org',
  '@type': 'Recipe',
  'name': 'Kolač sa šljivama',
  'image': 'https://cdn.example.com/kolac.jpg',
  'recipeIngredient': ['2 dl toplog mlijeka', '400 g brašna', '25 dag šećera'],
  'recipeInstructions': [
    {'@type': 'HowToStep', 'text': 'Otopiti maslac u mlijeku.\nDodati brašno.'},
  ],
});

void main() {
  group('finding the recipe', () {
    test('inside a WordPress @graph', () {
      final r = recipeFromJsonLd([wordpressGraph], pageUrl: Uri.parse('https://example.com/plum-cake/'))!;
      expect(r.name, 'Plum Cake & Walnuts');
      expect(r.description, 'A soft yeast cake.');
      expect(r.imageUrl.toString(), 'https://example.com/img/plum-cake-1.jpg');
      expect(r.portions, 12);
      expect(r.prepMinutes, 20);
      expect(r.cookMinutes, 65);
      expect(r.totalMinutes, 85);
      expect(r.sourceUrl.toString(), 'https://example.com/plum-cake/');
    });

    test('as a flat object without times or portions', () {
      final r = recipeFromJsonLd([flatRecipe])!;
      expect(r.name, 'Kolač sa šljivama');
      expect(r.imageUrl.toString(), 'https://cdn.example.com/kolac.jpg');
      expect(r.portions, isNull);
      expect(r.prepMinutes, isNull);
      expect(r.steps, ['Otopiti maslac u mlijeku.', 'Dodati brašno.']);
    });

    test('broken blocks are skipped and pages without a recipe give null', () {
      expect(recipeFromJsonLd(['{not json', flatRecipe])!.name, 'Kolač sa šljivama');
      expect(recipeFromJsonLd([jsonEncode({'@type': 'WebPage'})]), isNull);
      expect(recipeFromJsonLd([jsonEncode({'@type': 'Recipe'})]), isNull, reason: 'a recipe needs a name');
    });

    test('@type can be a list and the recipe can sit in an array', () {
      final block = jsonEncode([
        {'@type': 'Organization'},
        {'@type': ['Recipe', 'NewsArticle'], 'name': 'Sarma'},
      ]);
      expect(recipeFromJsonLd([block])!.name, 'Sarma');
    });

    test('categories come from recipeCategory as text or list', () {
      String block(Object category) => jsonEncode({'@type': 'Recipe', 'name': 'X', 'recipeCategory': category});
      expect(recipeFromJsonLd([block('Kolači')])!.categories, ['Kolači']);
      expect(recipeFromJsonLd([block(['Dessert', ' Cake '])])!.categories, ['Dessert', 'Cake']);
      expect(recipeFromJsonLd([jsonEncode({'@type': 'Recipe', 'name': 'X'})])!.categories, isEmpty);
    });

    test('blocks are found in raw HTML', () {
      final page = '<html><head><script type="application/ld+json">$flatRecipe</script></head></html>';
      expect(recipeFromJsonLd(jsonLdBlocksFromHtml(page))!.name, 'Kolač sa šljivama');
    });

    test('relative image urls resolve against the page', () {
      final block = jsonEncode({'@type': 'Recipe', 'name': 'X', 'image': {'@type': 'ImageObject', 'url': '/img/x.jpg'}});
      final r = recipeFromJsonLd([block], pageUrl: Uri.parse('https://site.example/recipes/x'))!;
      expect(r.imageUrl.toString(), 'https://site.example/img/x.jpg');
    });
  });

  group('ingredients and steps', () {
    test('ingredient lines are parsed into amount, unit and name', () {
      final r = recipeFromJsonLd([wordpressGraph])!;
      final flour = r.ingredients[0];
      expect(flour.amount, 1.5);
      expect(flour.unit, CookingUnit.cup);
      expect(flour.name, 'all-purpose flour');
      expect(r.ingredients[1].note, 'softened');
      expect(r.ingredients[2].unit, CookingUnit.piece);
      expect(r.ingredients[3].amount, isNull);
      final kolac = recipeFromJsonLd([flatRecipe])!;
      expect(kolac.ingredients[0].unit, CookingUnit.dl);
      expect(kolac.ingredients[2].amount, 250);
    });

    test('sections are flattened and HTML entities decoded', () {
      final r = recipeFromJsonLd([wordpressGraph])!;
      expect(r.steps, ['Mix the flour & butter.', 'Add the eggs.', 'Bake at 180 °C.']);
    });

    test('plain string instructions are split into steps', () {
      final block = jsonEncode({'@type': 'Recipe', 'name': 'X', 'recipeInstructions': 'Chop.<br>Fry.\n\nServe.'});
      expect(recipeFromJsonLd([block])!.steps, ['Chop.', 'Fry.', 'Serve.']);
    });
  });

  group('values', () {
    test('ISO durations', () {
      expect(parseDurationMinutes('PT45M'), 45);
      expect(parseDurationMinutes('PT1H'), 60);
      expect(parseDurationMinutes('P0DT2H30M'), 150);
      expect(parseDurationMinutes('PT90S'), 2);
      expect(parseDurationMinutes('PT0M'), isNull);
      expect(parseDurationMinutes('soon'), isNull);
    });

    test('portions from many shapes', () {
      expect(parsePortions('4'), 4);
      expect(parsePortions('4 servings'), 4);
      expect(parsePortions(['6', '6 pieces']), 6);
      expect(parsePortions(8), 8);
      expect(parsePortions('Serves 2-3'), 2);
      expect(parsePortions('a few'), isNull);
    });
  });
}
