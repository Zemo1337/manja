import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:manja/data/database.dart';
import 'package:manja/domain/cookbook_pdf.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Font _font(String name) =>
    pw.Font.ttf(ByteData.sublistView(File('assets/fonts/Roboto-$name.ttf').readAsBytesSync()));

final _fonts = CookbookFonts(regular: _font('Regular'), bold: _font('Bold'), light: _font('Light'));

CookbookRecipe _recipe(int id, String name, {int steps = 3, Nutrients? nutrition}) => CookbookRecipe(
  RecipeFull(
    Recipe(
      id: id,
      name: name,
      portions: 4,
      prepMinutes: 20,
      cookMinutes: 90,
      cookingInfo: 'Tastes better the next day.',
      isFavorite: false,
      createdAt: DateTime(2026),
      sourceUrl: 'https://www.coolinarika.com/recept/$id',
    ),
    [
      for (final (i, n) in ['kiseli kupus', 'mljevena junetina', 'riža', 'sol', 'papar'].indexed)
        RecipeIngredient(id: id * 10 + i, recipeId: id, position: i, name: n, amount: i == 3 ? 0 : 500, unit: 'g'),
    ],
    [
      for (var i = 0; i < steps; i++)
        RecipeStep(
          id: id * 100 + i,
          recipeId: id,
          position: i,
          body: 'Korak ${i + 1}: pirjati lagano i miješati. ' * 4,
        ),
    ],
  ),
  perPortion: nutrition,
);

void main() {
  test('Roboto covers Croatian letters', () {
    for (final name in ['Regular', 'Bold', 'Light']) {
      final bytes = ByteData.sublistView(File('assets/fonts/Roboto-$name.ttf').readAsBytesSync());
      final font = PdfTtfFont(PdfDocument(), bytes);
      for (final c in 'čćšžđČĆŠŽĐ·'.runes) {
        expect(font.isRuneSupported(c), isTrue, reason: '$name ${String.fromCharCode(c)}');
      }
    }
  });

  test('every layout builds, with a contents page pointing at each recipe', () async {
    final recipes = [
      _recipe(1, 'Sarma', steps: 40, nutrition: Nutrients.of(energyKcal: 512, protein: 31, fat: 28)),
      _recipe(2, 'Ćevapi'),
      _recipe(3, 'Burek'),
    ];
    for (final layout in CookbookLayout.values) {
      final doc = buildCookbookDocument(recipes, CookbookOptions(layout: layout), _fonts, date: DateTime(2026, 10));
      final pages = recipePages(doc);
      expect(pages.keys, containsAll(['recipe-1', 'recipe-2', 'recipe-3']), reason: layout.name);
      final burek = int.parse(pages['recipe-3']!);
      final cevapi = int.parse(pages['recipe-2']!);
      final sarma = int.parse(pages['recipe-1']!);
      expect(burek, 3, reason: 'cover, contents, then recipes sorted by name (${layout.name})');
      expect(cevapi, greaterThanOrEqualTo(burek));
      expect(sarma, greaterThanOrEqualTo(cevapi));
      final total = doc.document.pdfPageList.pages.length;
      if (layout != CookbookLayout.compact) {
        expect((cevapi, sarma), (burek + 1, cevapi + 1), reason: 'each recipe starts on its own page');
        expect(total, greaterThan(sarma), reason: 'the long Sarma recipe continues on another page');
      }
      final bytes = await doc.save();
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    }
  });

  test('options can leave out the cover and contents', () {
    final doc = buildCookbookDocument(
      [_recipe(1, 'Grah')],
      const CookbookOptions(cover: false, contents: false, layout: CookbookLayout.cards),
      _fonts,
    );
    expect(recipePages(doc)['recipe-1'], '1');
    expect(doc.document.pdfPageList.pages.first.pageFormat, PdfPageFormat.a6);
  });

  test('texts', () {
    expect(
      nutritionLine(Nutrients.of(energyKcal: 512.4, protein: 31.2, fat: 8.25), {Nutrient.fat}),
      '512 kcal · 31 g protein · 8.3 g* fat',
    );
    final r = _recipe(1, 'Sarma').full.recipe;
    expect(recipeInfo(r), '4 portions · Prep 20 min · Cook 1 h 30 min');
  });
}
