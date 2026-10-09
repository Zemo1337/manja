import 'dart:async';

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/pantry_matcher.dart';
import '../app_theme.dart';
import '../recipes/recipe_detail_screen.dart';
import '../recipes/recipe_photo.dart';
import '../settings/option_card.dart';

const staples = ['Salt', 'Pepper', 'Oil', 'Flour', 'Sugar', 'Eggs', 'Milk', 'Butter', 'Onion', 'Garlic', 'Rice'];

const _basicWords = [...staples, 'Water', 'Sol', 'Biber', 'Papar', 'Ulje', 'Brašno', 'Šećer', 'Voda'];

final _basicStems = [for (final b in _basicWords) nameStems(b)];

bool isStaple(String name) {
  final stems = nameStems(name);
  return _basicStems.any((b) => stems.length == b.length && stems.containsAll(b));
}

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final _pantryInput = TextEditingController();
  final _cravingInput = TextEditingController();
  final _cravings = <String>[];
  bool _wheelOnly = true;
  StreamSubscription<List<PantryItem>>? _pantrySubscription;
  List<PantryItem> _pantry = const [];
  List<MatchRecipe<Recipe>> _allRecipes = const [];
  Set<int> _onWheel = const {};
  List<String> _suggestions = const [];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pantrySubscription == null) {
      _pantrySubscription = AppScope.of(context).db.watchPantry().listen((items) {
        if (mounted) setState(() => _pantry = items);
      });
      _load();
    }
  }

  @override
  void dispose() {
    _pantrySubscription?.cancel();
    _pantryInput.dispose();
    _cravingInput.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final scope = AppScope.of(context);
    final recipes = await scope.db.allRecipes();
    final ingredients = await scope.db.allRecipeIngredients();
    final foods = await scope.nutrition.foodsByKey({for (final i in ingredients) ?i.foodKey});
    final state = await scope.wheel.computeState();
    final byRecipe = <int, List<MatchIngredient>>{};
    final counts = <String, int>{};
    final labels = <String, String>{};
    for (final i in ingredients) {
      byRecipe
          .putIfAbsent(i.recipeId, () => [])
          .add(MatchIngredient(i.name, foodKey: i.foodKey, foodName: foods[i.foodKey]?.name));
      final stems = nameStems(i.name);
      if (stems.isEmpty || stems.length > 2) continue;
      final key = (stems.toList()..sort()).join(' ');
      counts[key] = (counts[key] ?? 0) + 1;
      labels.putIfAbsent(key, () => _label(i.name));
    }
    final popular = counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    if (!mounted) return;
    setState(() {
      _allRecipes = [for (final r in recipes) MatchRecipe(r, byRecipe[r.id] ?? const [])];
      _onWheel = {for (final r in state.available) r.id};
      _suggestions = [for (final k in popular.take(30)) labels[k]!];
      _loaded = true;
    });
  }

  String _label(String name) {
    final text = name.replaceAll(RegExp(r'\([^)]*\)'), '').split(',').first.trim();
    return text.isEmpty ? name : text[0].toUpperCase() + text.substring(1);
  }

  Future<void> _addPantry(String name) async {
    final text = name.trim();
    if (text.isEmpty) return;
    _pantryInput.clear();
    if (_pantry.any((p) => p.name.toLowerCase() == text.toLowerCase())) return;
    await AppScope.of(context).db.addPantryItem(text);
  }

  void _addCraving(String name) {
    final text = name.trim();
    _cravingInput.clear();
    if (text.isEmpty || _cravings.any((c) => c.toLowerCase() == text.toLowerCase())) return;
    setState(() => _cravings.add(text));
  }

  List<RecipeMatch<Recipe>> get _matches => matchRecipes(
    [
      for (final r in _allRecipes)
        if (!_wheelOnly || _onWheel.contains(r.recipe.id)) r,
    ],
    pantry: [for (final p in _pantry) AvailableIngredient(p.name, foodKey: p.foodKey)],
    cravings: [for (final c in _cravings) AvailableIngredient(c)],
  );

  void _spin(List<RecipeMatch<Recipe>> complete) {
    AppScope.of(context).wheel.focus.value = {for (final m in complete) m.recipe.id};
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matches = _loaded ? _matches : const <RecipeMatch<Recipe>>[];
    final complete = [
      for (final m in matches)
        if (m.complete) m,
    ];
    final near = [
      for (final m in matches)
        if (!m.complete) m,
    ];
    final canSpin = complete.isNotEmpty && complete.every((m) => _onWheel.contains(m.recipe.id));
    final pantryStems = [for (final p in _pantry) nameStems(p.name)];
    bool inPantry(String name) {
      final stems = nameStems(name);
      return pantryStems.any((s) => s.isNotEmpty && stems.containsAll(s) && s.containsAll(stems));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('What can I cook?')),
      bottomNavigationBar: complete.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: canSpin ? () => _spin(complete) : null,
                  icon: const Icon(Icons.casino_outlined),
                  label: Text(
                    canSpin ? 'Spin with these ${complete.length}' : 'Switch to "On the wheel" to spin with these',
                  ),
                ),
              ),
            ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const SettingsSectionTitle('Always at home'),
                _ChipEditor(
                  items: [for (final p in _pantry) (p.name, () => AppScope.of(context).db.deletePantryItem(p.id))],
                  controller: _pantryInput,
                  hint: 'Add a basic, e.g. olive oil',
                  onAdd: _addPantry,
                  suggestions: [
                    for (final s in staples)
                      if (!inPantry(s)) s,
                  ],
                  empty: 'Add what you always have, like salt, oil or flour.',
                ),
                const SettingsSectionTitle('In the mood for'),
                _ChipEditor(
                  items: [for (final c in _cravings) (c, () => setState(() => _cravings.remove(c)))],
                  controller: _cravingInput,
                  hint: 'Add an ingredient, e.g. chicken',
                  onAdd: _addCraving,
                  suggestions: [
                    for (final s in _suggestions)
                      if (!inPantry(s) && !isStaple(s) && !_cravings.any((c) => c.toLowerCase() == s.toLowerCase())) s,
                  ].take(12).toList(),
                  empty: 'Optional. Pick what you feel like today to only see dishes with it.',
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: true, label: Text('On the wheel'), icon: Icon(Icons.casino_outlined)),
                      ButtonSegment(value: false, label: Text('All recipes'), icon: Icon(Icons.menu_book_outlined)),
                    ],
                    selected: {_wheelOnly},
                    onSelectionChanged: (s) => setState(() => _wheelOnly = s.single),
                  ),
                ),
                SettingsSectionTitle('You can make (${complete.length})'),
                if (complete.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _pantry.isEmpty && _cravings.isEmpty
                          ? 'Add what you have at home to see which dishes you can make.'
                          : 'Nothing yet with these ingredients.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                for (final m in complete) _MatchTile(match: m),
                if (near.isNotEmpty) ...[
                  SettingsSectionTitle('Missing one or two (${near.length})'),
                  for (final m in near) _MatchTile(match: m),
                ],
              ],
            ),
    );
  }
}

class _ChipEditor extends StatelessWidget {
  const _ChipEditor({
    required this.items,
    required this.controller,
    required this.hint,
    required this.onAdd,
    required this.suggestions,
    required this.empty,
  });

  final List<(String, VoidCallback)> items;
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onAdd;
  final List<String> suggestions;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = HighlightColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isEmpty) Text(empty, style: theme.textTheme.bodySmall),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final (label, onDelete) in items)
                InputChip(
                  label: Text(label, style: TextStyle(color: highlight.foreground)),
                  backgroundColor: highlight.background,
                  deleteIconColor: highlight.foreground,
                  side: BorderSide.none,
                  onDeleted: onDelete,
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: 'Add',
                icon: const Icon(Icons.add),
                onPressed: () => onAdd(controller.text),
              ),
            ),
            onSubmitted: onAdd,
          ),
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 0,
              children: [
                for (final s in suggestions)
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: Text(s),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onAdd(s),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({required this.match});

  final RecipeMatch<Recipe> match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipe = match.recipe;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox.square(dimension: 48, child: RecipePhoto(recipe: recipe, cacheWidth: 144)),
      ),
      title: Text(recipe.name),
      subtitle: Text(
        match.complete
            ? 'You have all ${match.used.length} ingredients'
            : 'Missing: ${match.missing.map((i) => i.name).join(', ')}',
        style: match.complete ? null : TextStyle(color: theme.colorScheme.error),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id))),
    );
  }
}
