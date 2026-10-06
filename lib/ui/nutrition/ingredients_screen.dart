import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../../app_scope.dart';
import '../../data/nutrition_repository.dart';
import 'food_edit_screen.dart';
import 'nutrition_panel.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  FoodCacheMode? _mode;
  Set<String> _linked = const {};
  bool _busy = false;

  NutritionRepository get _repo => AppScope.of(context).nutrition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mode == null) _loadMeta();
  }

  Future<void> _loadMeta() async {
    final scope = AppScope.of(context);
    final mode = await scope.nutrition.mode();
    final linked = await scope.db.linkedFoodKeys();
    if (mounted) {
      setState(() {
        _mode = mode;
        _linked = linked;
      });
    }
  }

  Future<void> _setMode(FoodCacheMode mode) async {
    await _repo.setMode(mode);
    setState(() => _mode = mode);
  }

  Future<void> _run(Future<String> Function() action) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final message = await action();
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _busy = false);
      await _loadMeta();
    }
  }

  Future<void> _refresh() => _run(() async {
        final r = await _repo.refreshCached();
        return r.failed == 0 ? 'Updated ${r.updated} ingredients' : 'Updated ${r.updated}, ${r.failed} could not be updated';
      });

  Future<void> _prune() => _run(() async {
        final removed = await _repo.pruneUnused();
        return removed == 0 ? 'Nothing to remove' : 'Removed $removed unused ingredients';
      });

  Future<void> _edit([Food? food]) async {
    await Navigator.push<Food>(context, MaterialPageRoute(builder: (_) => FoodEditScreen(existing: food)));
    await _loadMeta();
  }

  Future<void> _delete(Food food) async {
    final used = _linked.contains(food.key);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${food.name}"?'),
        content: Text(
          used
              ? 'Some recipes use this ingredient. They will show it as "no food linked" until you link another one.'
              : 'The ingredient will be removed from this device.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) await _repo.delete(food.key);
  }

  void _show(Food food) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _FoodSheet(
          food: food,
          onEdit: () {
            Navigator.pop(context);
            _edit(food);
          },
          onDelete: () {
            Navigator.pop(context);
            _delete(food);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('My ingredient'),
      ),
      body: StreamBuilder<List<Food>>(
        stream: _repo.watchLibrary(),
        builder: (context, snapshot) {
          final foods = snapshot.data ?? const <Food>[];
          final mine = [for (final f in foods) if (f.source == FoodSource.user) f];
          final saved = [for (final f in foods) if (f.source != FoodSource.user) f];
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('Ingredient data', style: theme.textTheme.titleMedium),
              ),
              if (_mode != null)
                RadioGroup<FoodCacheMode>(
                  groupValue: _mode,
                  onChanged: (m) => m == null ? null : _setMode(m),
                  child: Column(
                    children: [
                      for (final m in [FoodCacheMode.online, FoodCacheMode.cacheUsed])
                        RadioListTile<FoodCacheMode>(value: m, title: Text(m.label), subtitle: Text(m.description)),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _busy || saved.isEmpty ? null : _refresh,
                      icon: const Icon(Icons.sync),
                      label: const Text('Update saved'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy || saved.isEmpty ? null : _prune,
                      icon: const Icon(Icons.cleaning_services_outlined),
                      label: const Text('Remove unused'),
                    ),
                  ],
                ),
              ),
              if (_busy) const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
              const Divider(height: 32),
              _section(context, 'My ingredients', mine, 'Add ingredients you cannot find online, e.g. from a package label.'),
              _section(context, 'Saved from USDA', saved, 'Ingredients you link in recipes are saved here.'),
            ],
          );
        },
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Food> foods, String empty) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text('$title (${foods.length})', style: theme.textTheme.titleMedium),
        ),
        if (foods.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(empty, style: theme.textTheme.bodySmall),
          ),
        for (final f in foods)
          ListTile(
            title: Text(f.name),
            subtitle: Text([
              if (f.per100g[Nutrient.energy] case final kcal?) '${kcal.round()} kcal / 100 g',
              if (_linked.contains(f.key)) 'used in recipes',
            ].join(' · ')),
            onTap: () => _show(f),
          ),
      ],
    );
  }
}

class _FoodSheet extends StatelessWidget {
  const _FoodSheet({required this.food, required this.onEdit, required this.onDelete});

  final Food food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = food.source == FoodSource.user;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(food.name, style: theme.textTheme.titleLarge),
            Text(food.detail?.isNotEmpty == true ? '${food.source.label} · ${food.detail}' : food.source.label,
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Text('Per 100 g', style: theme.textTheme.titleSmall),
            for (final n in Nutrient.values)
              if (food.per100g[n] case final v?)
                Row(children: [Expanded(child: Text(n.label)), Text('${formatNutrient(n, v)} ${n.unit}')]),
            if (food.per100g.saltG case final salt?)
              Row(children: [const Expanded(child: Text('Salt')), Text('${formatNutrient(Nutrient.fat, salt)} g')]),
            if (food.portions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Portions', style: theme.textTheme.titleSmall),
              for (final p in food.portions)
                Row(children: [Expanded(child: Text(p.label)), Text('${p.grams.round()} g')]),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onEdit,
                  icon: Icon(mine ? Icons.edit_outlined : Icons.copy),
                  label: Text(mine ? 'Edit' : 'Copy to my ingredients'),
                ),
                TextButton.icon(onPressed: onDelete, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
