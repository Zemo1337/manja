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
  Set<String> _linked = const {};
  List<Food> _usedUsda = const [];
  int? _builtIn;
  String? _builtInVersion;
  bool _loaded = false;

  NutritionRepository get _repo => AppScope.of(context).nutrition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadMeta();
    }
  }

  Future<void> _loadMeta() async {
    final scope = AppScope.of(context);
    final linked = await scope.db.linkedFoodKeys();
    final builtIn = await scope.nutrition.countBySource(FoodSource.usda);
    final version = await scope.nutrition.bundleVersion();
    final used = (await scope.nutrition.foodsByKey(linked)).values.where((f) => f.source != FoodSource.user).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    if (mounted) {
      setState(() {
        _linked = linked;
        _usedUsda = used;
        _builtIn = builtIn;
        _builtInVersion = version;
      });
    }
  }

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

  Future<void> _update(Food food) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final fresh = await _repo.refresh(food);
      messenger.showSnackBar(
        SnackBar(content: Text(fresh == null ? 'USDA no longer has this food' : 'Updated "${fresh.name}"')),
      );
    } on NutritionSourceException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
    await _loadMeta();
  }

  void _show(Food food) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _FoodSheet(
          food: food,
          onUpdate: food.source == FoodSource.user || !_repo.hasRemote
              ? null
              : () {
                  Navigator.pop(context);
                  _update(food);
                },
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('My ingredient'),
      ),
      body: StreamBuilder<List<Food>>(
        stream: _repo.watchUserFoods(),
        builder: (context, snapshot) {
          final mine = snapshot.data ?? const <Food>[];
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(_builtIn == null ? 'Built-in ingredients' : 'Built-in ingredients: $_builtIn'),
                subtitle: Text(
                  'USDA FoodData Central, works offline${_builtInVersion == null ? '' : '\n$_builtInVersion'}',
                ),
                isThreeLine: _builtInVersion != null,
              ),
              const Divider(height: 24),
              _section(context, 'My ingredients', mine, 'Add ingredients you cannot find, e.g. from a package label.'),
              if (_usedUsda.isNotEmpty)
                _section(context, 'USDA ingredients in your recipes', _usedUsda, ''),
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
  const _FoodSheet({required this.food, required this.onEdit, required this.onDelete, this.onUpdate});

  final Food food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onUpdate;

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
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: onEdit,
                  icon: Icon(mine ? Icons.edit_outlined : Icons.copy),
                  label: Text(mine ? 'Edit' : 'Copy to my ingredients'),
                ),
                if (onUpdate != null)
                  OutlinedButton.icon(
                    onPressed: onUpdate,
                    icon: const Icon(Icons.sync),
                    label: const Text('Update from USDA'),
                  ),
                if (mine)
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
