import 'dart:typed_data';

import 'package:nutrition_core/nutrition_core.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/database.dart';
import 'units.dart';

enum CookbookLayout {
  classic('Classic', 'A4, one recipe per page with a big photo'),
  compact('Compact', 'A4, recipes one after another, saves paper'),
  cards('Recipe cards', 'A6 cards, one recipe each, easy to cut out');

  const CookbookLayout(this.label, this.description);

  final String label;
  final String description;
}

class CookbookOptions {
  const CookbookOptions({
    this.title = 'Manja cookbook',
    this.layout = CookbookLayout.classic,
    this.cover = true,
    this.contents = true,
    this.photos = true,
    this.nutrition = true,
  });

  final String title;
  final CookbookLayout layout;
  final bool cover;
  final bool contents;
  final bool photos;
  final bool nutrition;
}

class CookbookRecipe {
  const CookbookRecipe(this.full, {this.photo, this.perPortion, this.partial = const {}, this.complete = true});

  final RecipeFull full;
  final Uint8List? photo;
  final Nutrients? perPortion;
  final Set<Nutrient> partial;
  final bool complete;
}

class CookbookFonts {
  const CookbookFonts({required this.regular, required this.bold, required this.light});

  final pw.Font regular;
  final pw.Font bold;
  final pw.Font light;
}

const _paprika = PdfColor.fromInt(0xFFC2410C);
const _basil = PdfColor.fromInt(0xFF2E7D32);
const _saffron = PdfColor.fromInt(0xFFE9A000);
const _ink = PdfColor.fromInt(0xFF1C1B1A);
const _muted = PdfColor.fromInt(0xFF55504C);
const _line = PdfColor.fromInt(0xFFD7D1CC);
const _cream = PdfColor.fromInt(0xFFFFF4EC);
const _saffronLight = PdfColor.fromInt(0xFFFFF0C2);

class _Style {
  const _Style({
    required this.format,
    required this.margin,
    required this.body,
    required this.title,
    required this.heading,
    required this.photoHeight,
    required this.ingredientColumns,
    required this.contentsPerPage,
  });

  final PdfPageFormat format;
  final double margin;
  final double body;
  final double title;
  final double heading;
  final double photoHeight;
  final int ingredientColumns;
  final int contentsPerPage;

  static _Style of(CookbookLayout layout) => switch (layout) {
    CookbookLayout.classic => const _Style(
      format: PdfPageFormat.a4,
      margin: 48,
      body: 11,
      title: 26,
      heading: 13,
      photoHeight: 240,
      ingredientColumns: 2,
      contentsPerPage: 30,
    ),
    CookbookLayout.compact => const _Style(
      format: PdfPageFormat.a4,
      margin: 36,
      body: 9.5,
      title: 17,
      heading: 10.5,
      photoHeight: 64,
      ingredientColumns: 2,
      contentsPerPage: 34,
    ),
    CookbookLayout.cards => const _Style(
      format: PdfPageFormat.a6,
      margin: 18,
      body: 7.5,
      title: 13,
      heading: 8.5,
      photoHeight: 90,
      ingredientColumns: 1,
      contentsPerPage: 16,
    ),
  };
}

String nutritionLine(Nutrients n, Set<Nutrient> partial) {
  String value(Nutrient k, double v) {
    final text = k == Nutrient.energy || k == Nutrient.sodium || v >= 10 ? v.round().toString() : v.toStringAsFixed(1);
    return '$text ${k.unit}${partial.contains(k) ? '*' : ''}';
  }

  return [
    for (final k in const [Nutrient.energy, Nutrient.protein, Nutrient.fat, Nutrient.carbohydrate, Nutrient.fiber])
      if (n[k] case final v?) k == Nutrient.energy ? value(k, v) : '${value(k, v)} ${k.label.toLowerCase()}',
  ].join(' · ');
}

String recipeInfo(Recipe r) => [
  '${r.portions} ${r.portions == 1 ? 'portion' : 'portions'}',
  if (r.prepMinutes case final m? when m > 0) 'Prep ${_minutes(m)}',
  if (r.cookMinutes case final m? when m > 0) 'Cook ${_minutes(m)}',
].join(' · ');

String _minutes(int m) => m < 60 ? '$m min' : '${m ~/ 60} h${m % 60 == 0 ? '' : ' ${m % 60} min'}';

String _amount(RecipeIngredient i) =>
    i.amount > 0 ? '${formatAmount(i.amount)} ${CookingUnit.fromName(i.unit).symbol}' : '';

Future<Uint8List> buildCookbook(
  List<CookbookRecipe> recipes,
  CookbookOptions options,
  CookbookFonts fonts, {
  DateTime? date,
}) => buildCookbookDocument(recipes, options, fonts, date: date).save();

pw.Document buildCookbookDocument(
  List<CookbookRecipe> recipes,
  CookbookOptions options,
  CookbookFonts fonts, {
  DateTime? date,
}) {
  final sorted = [...recipes]..sort((a, b) => compareNames(a.full.recipe.name, b.full.recipe.name));
  final images = <int, pw.ImageProvider>{};
  if (options.photos) {
    for (final r in sorted) {
      if (r.photo == null) continue;
      try {
        images[r.full.recipe.id] = pw.MemoryImage(r.photo!);
      } on Object {
        // Formats the PDF library cannot read are left out.
      }
    }
  }
  final builder = _Builder(sorted, options, fonts, images, date ?? DateTime.now());
  final firstPass = builder.document(const {});
  if (!options.contents) return firstPass;
  return builder.document(recipePages(firstPass));
}

const _folded = {'č': 'c', 'ć': 'c', 'š': 's', 'ž': 'z', 'đ': 'd', 'ä': 'a', 'ö': 'o', 'ü': 'u', 'ß': 'ss'};

String _sortKey(String name) => name.toLowerCase().split('').map((c) => _folded[c] ?? c).join();

int compareNames(String a, String b) {
  final byKey = _sortKey(a).compareTo(_sortKey(b));
  return byKey != 0 ? byKey : a.toLowerCase().compareTo(b.toLowerCase());
}

Map<String, String> recipePages(pw.Document doc) => {
  for (final o in doc.document.outline.outlines)
    if (o.anchor != null && o.page != null) o.anchor!: o.page!,
};

class _Builder {
  _Builder(this.recipes, this.options, this.fonts, this.images, this.date) : style = _Style.of(options.layout);

  final List<CookbookRecipe> recipes;
  final CookbookOptions options;
  final CookbookFonts fonts;
  final Map<int, pw.ImageProvider> images;
  final DateTime date;
  final _Style style;

  bool get _cards => options.layout == CookbookLayout.cards;

  String _anchor(Recipe r) => 'recipe-${r.id}';

  pw.Document document(Map<String, String> pages) {
    final doc = pw.Document(
      title: options.title,
      creator: 'Manja',
      theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold, italic: fonts.light),
    );
    if (options.cover) doc.addPage(_cover());
    if (options.contents && recipes.isNotEmpty) {
      for (var start = 0; start < recipes.length; start += style.contentsPerPage) {
        doc.addPage(_contents(recipes.skip(start).take(style.contentsPerPage).toList(), pages, first: start == 0));
      }
    }
    if (options.layout == CookbookLayout.compact) {
      doc.addPage(
        pw.MultiPage(
          pageTheme: _pageTheme(),
          footer: _footer,
          build: (_) => [
            for (final (index, r) in recipes.indexed) ...[
              if (index > 0) pw.Divider(color: _line, height: 28, thickness: 0.6),
              ..._recipe(r),
            ],
          ],
        ),
      );
    } else {
      for (final r in recipes) {
        doc.addPage(pw.MultiPage(pageTheme: _pageTheme(), footer: _footer, build: (_) => _recipe(r)));
      }
    }
    if (recipes.isEmpty) {
      doc.addPage(
        pw.Page(
          pageTheme: _pageTheme(),
          build: (_) => pw.Center(child: pw.Text('No recipes yet')),
        ),
      );
    }
    return doc;
  }

  pw.PageTheme _pageTheme() => pw.PageTheme(
    pageFormat: style.format,
    margin: pw.EdgeInsets.all(style.margin),
    theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold, italic: fonts.light).copyWith(
      defaultTextStyle: pw.TextStyle(fontSize: style.body, color: _ink, lineSpacing: 1.5),
    ),
  );

  pw.Widget _footer(pw.Context context) => pw.Container(
    margin: pw.EdgeInsets.only(top: style.body),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          options.title,
          style: pw.TextStyle(fontSize: style.body * 0.8, color: _muted),
        ),
        pw.Text(
          '${context.pageNumber}',
          style: pw.TextStyle(fontSize: style.body * 0.8, color: _muted),
        ),
      ],
    ),
  );

  pw.Page _cover() {
    final photos = [for (final r in recipes) ?images[r.full.recipe.id]];
    final withPhotos = photos.take(photos.length >= 4 ? 4 : (photos.length >= 2 ? 2 : photos.length)).toList();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', //
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final scale = _cards ? 0.45 : 1.0;
    return pw.Page(
      pageTheme: pw.PageTheme(
        pageFormat: style.format,
        margin: pw.EdgeInsets.zero,
        buildBackground: (_) => pw.FullPage(ignoreMargins: true, child: pw.Container(color: _cream)),
      ),
      build: (_) => pw.Padding(
        padding: pw.EdgeInsets.all(style.margin * 1.2),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(width: 64 * scale, height: 6 * scale, color: _saffron),
            pw.SizedBox(height: 18 * scale),
            pw.Text(
              options.title,
              style: pw.TextStyle(font: fonts.bold, fontSize: 40 * scale, color: _paprika, lineSpacing: 4 * scale),
            ),
            pw.SizedBox(height: 10 * scale),
            pw.Text(
              '${recipes.length} ${recipes.length == 1 ? 'recipe' : 'recipes'} · ${months[date.month - 1]} ${date.year}',
              style: pw.TextStyle(font: fonts.light, fontSize: 16 * scale, color: _muted),
            ),
            pw.SizedBox(height: 28 * scale),
            if (withPhotos.isNotEmpty)
              pw.Expanded(
                child: pw.GridView(
                  crossAxisCount: withPhotos.length == 4 ? 2 : 1,
                  crossAxisSpacing: 8 * scale,
                  mainAxisSpacing: 8 * scale,
                  childAspectRatio: switch (withPhotos.length) {
                    4 => 1,
                    2 => 2,
                    _ => 1.4,
                  },
                  children: [
                    for (final image in withPhotos)
                      pw.ClipRRect(
                        horizontalRadius: 10 * scale,
                        verticalRadius: 10 * scale,
                        child: pw.Image(image, fit: pw.BoxFit.cover),
                      ),
                  ],
                ),
              )
            else
              pw.Spacer(),
            pw.SizedBox(height: 16 * scale),
            pw.Row(
              children: [
                for (final c in const [_paprika, _basil, _saffron])
                  pw.Container(
                    width: 14 * scale,
                    height: 14 * scale,
                    margin: pw.EdgeInsets.only(right: 6 * scale),
                    decoration: pw.BoxDecoration(color: c, shape: pw.BoxShape.circle),
                  ),
                pw.Spacer(),
                pw.Text(
                  'Made with Manja',
                  style: pw.TextStyle(fontSize: 10 * scale, color: _muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Page _contents(List<CookbookRecipe> entries, Map<String, String> pages, {required bool first}) => pw.Page(
    pageTheme: _pageTheme(),
    build: (_) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (first) ...[
          pw.Text(
            'Contents',
            style: pw.TextStyle(font: fonts.bold, fontSize: style.title, color: _paprika),
          ),
          pw.SizedBox(height: style.body * 1.5),
        ],
        for (final r in entries)
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: style.body * 0.35),
            child: pw.Link(
              destination: _anchor(r.full.recipe),
              child: pw.Row(
                children: [
                  pw.ConstrainedBox(
                    constraints: pw.BoxConstraints(maxWidth: (style.format.width - 2 * style.margin) * 0.8),
                    child: pw.Text(r.full.recipe.name, maxLines: 1),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: pw.Divider(borderStyle: pw.BorderStyle.dotted, color: _muted, thickness: 0.4),
                  ),
                  pw.SizedBox(
                    width: style.body * 2.5,
                    child: pw.Text(
                      pages[_anchor(r.full.recipe)] ?? '',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(color: _muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );

  List<pw.Widget> _recipe(CookbookRecipe entry) {
    final r = entry.full.recipe;
    final image = images[r.id];
    final compact = options.layout == CookbookLayout.compact;
    final titleBlock = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Outline(
          name: _anchor(r),
          title: r.name,
          child: pw.Text(
            r.name,
            style: pw.TextStyle(font: fonts.bold, fontSize: style.title, color: _paprika),
          ),
        ),
        pw.SizedBox(height: style.body * 0.3),
        pw.Text(recipeInfo(r), style: pw.TextStyle(color: _muted)),
      ],
    );
    final photo = image == null
        ? null
        : pw.ClipRRect(
            horizontalRadius: 8,
            verticalRadius: 8,
            child: pw.SizedBox(
              height: style.photoHeight,
              width: compact ? style.photoHeight * 1.4 : double.infinity,
              child: pw.Image(image, fit: pw.BoxFit.cover),
            ),
          );
    return [
      if (compact)
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: titleBlock),
            if (photo != null) ...[pw.SizedBox(width: 12), photo],
          ],
        )
      else ...[
        if (photo != null) ...[photo, pw.SizedBox(height: style.body * 1.2)],
        titleBlock,
      ],
      if (options.nutrition && entry.perPortion != null && entry.perPortion!.has(Nutrient.energy)) ...[
        pw.SizedBox(height: style.body * 0.8),
        pw.Container(
          padding: pw.EdgeInsets.symmetric(horizontal: style.body * 0.8, vertical: style.body * 0.4),
          decoration: pw.BoxDecoration(color: _saffronLight, borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Text(
            '${entry.complete ? 'Per portion' : 'Per portion, at least'}: '
            '${nutritionLine(entry.perPortion!, entry.partial)}',
            style: pw.TextStyle(fontSize: style.body * 0.9),
          ),
        ),
      ],
      if (entry.full.ingredients.isNotEmpty) ...[_heading('Ingredients'), _ingredients(entry.full.ingredients)],
      if (entry.full.steps.isNotEmpty) ...[
        _heading('Preparation'),
        for (final (index, step) in entry.full.steps.indexed)
          pw.Padding(
            padding: pw.EdgeInsets.only(bottom: style.body * 0.5),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: style.body * 2,
                  child: pw.Text(
                    '${index + 1}.',
                    style: pw.TextStyle(font: fonts.bold, color: _basil),
                  ),
                ),
                pw.Expanded(child: pw.Text(step.body)),
              ],
            ),
          ),
      ],
      if (r.cookingInfo.trim().isNotEmpty) ...[_heading('Notes'), pw.Text(r.cookingInfo.trim())],
      if (r.sourceUrl case final url? when url.isNotEmpty) ...[
        pw.SizedBox(height: style.body),
        pw.UrlLink(
          destination: url,
          child: pw.Text(
            'Source: ${Uri.tryParse(url)?.host ?? url}',
            style: pw.TextStyle(fontSize: style.body * 0.8, color: _muted),
          ),
        ),
      ],
    ];
  }

  pw.Widget _heading(String text) => pw.Padding(
    padding: pw.EdgeInsets.only(top: style.body * 1.3, bottom: style.body * 0.5),
    child: pw.Text(
      text.toUpperCase(),
      style: pw.TextStyle(font: fonts.bold, fontSize: style.heading, color: _basil, letterSpacing: 0.8),
    ),
  );

  pw.Widget _ingredients(List<RecipeIngredient> ingredients) {
    final columns = style.ingredientColumns;
    final rows = (ingredients.length / columns).ceil();
    pw.Widget cell(RecipeIngredient? i) => i == null
        ? pw.SizedBox()
        : pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: style.body * 0.25),
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  if (_amount(i).isNotEmpty)
                    pw.TextSpan(
                      text: '${_amount(i)}  ',
                      style: pw.TextStyle(font: fonts.bold),
                    ),
                  pw.TextSpan(text: i.name),
                ],
              ),
            ),
          );
    return pw.Table(
      columnWidths: {for (var c = 0; c < columns; c++) c: const pw.FlexColumnWidth()},
      border: const pw.TableBorder(horizontalInside: pw.BorderSide(color: _line, width: 0.4)),
      children: [
        for (var row = 0; row < rows; row++)
          pw.TableRow(
            children: [
              for (var c = 0; c < columns; c++)
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: c < columns - 1 ? 12 : 0),
                  child: cell(row + c * rows < ingredients.length ? ingredients[row + c * rows] : null),
                ),
            ],
          ),
      ],
    );
  }
}
