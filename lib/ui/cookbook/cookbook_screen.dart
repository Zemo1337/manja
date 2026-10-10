import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/cookbook_pdf.dart';
import '../../domain/text_fold.dart';
import '../settings/option_card.dart';
import '../app_theme.dart';

Future<List<CookbookRecipe>> loadCookbookRecipes(AppScope scope, Iterable<int> ids, {required bool photos}) async {
  final result = <CookbookRecipe>[];
  for (final id in ids) {
    final full = await scope.db.recipeFull(id);
    if (full == null) continue;
    Uint8List? photo;
    if (photos && full.recipe.photoPath != null) {
      final file = scope.photos.file(full.recipe.photoPath!);
      if (await file.exists()) photo = await file.readAsBytes();
    }
    final foods = await scope.nutrition.foodsByKey({for (final i in full.ingredients) ?i.foodKey});
    final nutrition = RecipeNutrition.calculate(
      [
        for (final i in full.ingredients)
          IngredientLine(name: i.name, amount: i.amount, unit: CookingUnit.fromName(i.unit), food: foods[i.foodKey]),
      ],
      portions: full.recipe.portions,
      finishedWeightG: full.recipe.finishedWeightG,
    );
    final counted = nutrition.lines.any((l) => l.counted);
    result.add(
      CookbookRecipe(
        full,
        photo: photo,
        perPortion: counted ? nutrition.perPortion : null,
        partial: nutrition.partial,
        complete: nutrition.complete,
      ),
    );
  }
  return result;
}

Future<Uint8List> makeCookbookPdf(List<CookbookRecipe> recipes, CookbookOptions options) async {
  Future<ByteData> font(String name) => rootBundle.load('assets/fonts/Roboto-$name.ttf');
  final regular = await font('Regular');
  final bold = await font('Bold');
  final light = await font('Light');
  final date = DateTime.now();
  return Isolate.run(
    () => buildCookbook(
      recipes,
      options,
      CookbookFonts(regular: pw.Font.ttf(regular), bold: pw.Font.ttf(bold), light: pw.Font.ttf(light)),
      date: date,
    ),
  );
}

enum _Selection { all, favorites, tag, chosen }

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  final _title = TextEditingController(text: 'Manja cookbook');
  CookbookLayout _layout = CookbookLayout.classic;
  bool _cover = true;
  bool _contents = true;
  bool _photos = true;
  bool _nutrition = true;
  _Selection _selection = _Selection.all;
  List<Tag> _tags = const [];
  Map<int, Set<int>> _tagsByRecipe = const {};
  int? _tagId;
  Set<int> _chosen = {};
  List<Recipe>? _recipes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_recipes == null) _load();
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = AppScope.of(context).db;
    final recipes = await db.allRecipes();
    final tags = await db.allTags();
    final tagsByRecipe = await db.tagsByRecipe();
    recipes.sort((a, b) => compareNames(a.name, b.name));
    if (!mounted) return;
    setState(() {
      _recipes = recipes;
      _tags = tags;
      _tagsByRecipe = tagsByRecipe;
      _tagId = tags.isEmpty ? null : tags.first.id;
      _chosen = {for (final r in recipes) r.id};
    });
  }

  List<Recipe> get _selected => switch (_selection) {
    _Selection.all => _recipes ?? const [],
    _Selection.favorites => [
      for (final r in _recipes ?? const <Recipe>[])
        if (r.isFavorite) r,
    ],
    _Selection.tag => [
      for (final r in _recipes ?? const <Recipe>[])
        if (_tagsByRecipe[r.id]?.contains(_tagId) ?? false) r,
    ],
    _Selection.chosen => [
      for (final r in _recipes ?? const <Recipe>[])
        if (_chosen.contains(r.id)) r,
    ],
  };

  CookbookOptions get _options => CookbookOptions(
    title: _title.text.trim().isEmpty ? 'Cookbook' : _title.text.trim(),
    layout: _layout,
    cover: _cover,
    contents: _contents,
    photos: _photos,
    nutrition: _nutrition,
  );

  Future<void> _choose() async {
    final chosen = await Navigator.push<Set<int>>(
      context,
      MaterialPageRoute(
        builder: (_) => _ChooseRecipesScreen(recipes: _recipes!, chosen: _chosen),
      ),
    );
    if (chosen != null) {
      setState(() {
        _chosen = chosen;
        _selection = _Selection.chosen;
      });
    }
  }

  void _preview() {
    final scope = AppScope.of(context);
    final ids = [for (final r in _selected) r.id];
    final options = _options;
    final pdf = loadCookbookRecipes(scope, ids, photos: options.photos).then((r) => makeCookbookPdf(r, options));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CookbookPreviewScreen(pdf: pdf, fileName: '${options.title}.pdf'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipes = _recipes;
    final selected = _selected;
    final favorites = recipes?.where((r) => r.isFavorite).length ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Cookbook PDF')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: selected.isEmpty ? null : _preview,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(
              selected.isEmpty
                  ? 'No recipes selected'
                  : 'Create PDF with ${selected.length} ${selected.length == 1 ? 'recipe' : 'recipes'}',
            ),
          ),
        ),
      ),
      body: recipes == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  ),
                ),
                const SettingsSectionTitle('Layout'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      for (final (index, layout) in CookbookLayout.values.indexed) ...[
                        if (index > 0) const SizedBox(width: 8),
                        Expanded(
                          child: OptionCard(
                            label: layout.label,
                            preview: _LayoutPreview(layout: layout),
                            selected: _layout == layout,
                            onTap: () => setState(() => _layout = layout),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(_layout.description, style: theme.textTheme.bodySmall),
                ),
                const SettingsSectionTitle('Recipes'),
                RadioGroup<_Selection>(
                  groupValue: _selection,
                  onChanged: (v) => setState(() => _selection = v!),
                  child: Column(
                    children: [
                      RadioListTile(value: _Selection.all, title: Text('All recipes (${recipes.length})')),
                      RadioListTile(
                        value: _Selection.favorites,
                        enabled: favorites > 0,
                        title: Text('Favorites ($favorites)'),
                      ),
                      if (_tags.isNotEmpty)
                        RadioListTile(
                          value: _Selection.tag,
                          title: const Text('Tagged'),
                          secondary: DropdownButton<int>(
                            value: _tagId,
                            items: [for (final t in _tags) DropdownMenuItem(value: t.id, child: Text(t.name))],
                            onChanged: (id) => setState(() {
                              _tagId = id;
                              _selection = _Selection.tag;
                            }),
                          ),
                        ),
                      RadioListTile(
                        value: _Selection.chosen,
                        title: Text('Chosen (${_chosen.length})'),
                        secondary: TextButton(onPressed: _choose, child: const Text('Choose')),
                      ),
                    ],
                  ),
                ),
                const SettingsSectionTitle('Include'),
                SwitchListTile(
                  title: const Text('Cover page'),
                  value: _cover,
                  onChanged: (v) => setState(() => _cover = v),
                ),
                SwitchListTile(
                  title: const Text('Table of contents'),
                  value: _contents,
                  onChanged: (v) => setState(() => _contents = v),
                ),
                SwitchListTile(
                  title: const Text('Photos'),
                  value: _photos,
                  onChanged: (v) => setState(() => _photos = v),
                ),
                SwitchListTile(
                  title: const Text('Nutrition per portion'),
                  subtitle: const Text('Only for recipes with linked ingredients'),
                  value: _nutrition,
                  onChanged: (v) => setState(() => _nutrition = v),
                ),
              ],
            ),
    );
  }
}

class _LayoutPreview extends StatelessWidget {
  const _LayoutPreview({required this.layout});

  final CookbookLayout layout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget bar(double width, Color color, {double height = 4}) => Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
    );
    final photo = scheme.secondary.withValues(alpha: 0.5);
    final text = scheme.onSurfaceVariant.withValues(alpha: 0.35);
    final (width, height) = layout == CookbookLayout.cards ? (44.0, 62.0) : (52.0, 72.0);
    return SizedBox(
      height: 76,
      child: Center(
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: switch (layout) {
              CookbookLayout.classic => [
                bar(double.infinity, photo, height: 22),
                bar(26, scheme.primary),
                bar(double.infinity, text, height: 3),
                bar(double.infinity, text, height: 3),
                bar(30, text, height: 3),
              ],
              CookbookLayout.compact => [
                for (var i = 0; i < 3; i++) ...[
                  Row(
                    children: [
                      Expanded(child: bar(double.infinity, scheme.primary, height: 3)),
                      const SizedBox(width: 3),
                      bar(10, photo, height: 6),
                    ],
                  ),
                  bar(double.infinity, text, height: 2),
                  bar(double.infinity, text, height: 2),
                ],
              ],
              CookbookLayout.cards => [
                bar(double.infinity, photo, height: 16),
                bar(20, scheme.primary),
                bar(double.infinity, text, height: 2),
                bar(double.infinity, text, height: 2),
                bar(24, text, height: 2),
              ],
            },
          ),
        ),
      ),
    );
  }
}

class _ChooseRecipesScreen extends StatefulWidget {
  const _ChooseRecipesScreen({required this.recipes, required this.chosen});

  final List<Recipe> recipes;
  final Set<int> chosen;

  @override
  State<_ChooseRecipesScreen> createState() => _ChooseRecipesScreenState();
}

class _ChooseRecipesScreenState extends State<_ChooseRecipesScreen> {
  late final _chosen = {...widget.chosen};

  @override
  Widget build(BuildContext context) {
    final all = _chosen.length == widget.recipes.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_chosen.length} chosen'),
        actions: [
          HeaderTextButton(
            onPressed: () => setState(() {
              if (all) {
                _chosen.clear();
              } else {
                _chosen.addAll([for (final r in widget.recipes) r.id]);
              }
            }),
            label: all ? 'None' : 'All',
          ),
          HeaderTextButton(onPressed: () => Navigator.pop(context, _chosen), label: 'Done'),
        ],
      ),
      body: ListView(
        children: [
          for (final r in widget.recipes)
            CheckboxListTile(
              title: Text(r.name),
              value: _chosen.contains(r.id),
              onChanged: (v) => setState(() => v! ? _chosen.add(r.id) : _chosen.remove(r.id)),
            ),
        ],
      ),
    );
  }
}

class CookbookPreviewScreen extends StatelessWidget {
  const CookbookPreviewScreen({super.key, required this.pdf, required this.fileName});

  final Future<Uint8List> pdf;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: PdfPreview(
        build: (_) => pdf,
        pdfFileName: fileName,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: true,
        loadingWidget: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator(), SizedBox(height: 12), Text('Laying out your cookbook…')],
        ),
      ),
    );
  }
}
