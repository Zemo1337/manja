import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';

import '../../app_scope.dart';
import '../../data/nutrition_repository.dart';
import 'api_key_dialogs.dart';
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
  ApiKeyOrigin? _keyOrigin;
  StreamSubscription<void>? _foodChanges;

  NutritionRepository get _repo => AppScope.of(context).nutrition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_foodChanges == null) {
      _foodChanges = AppScope.of(context).db.watchFoodChanges().listen((_) => _loadMeta());
      _loadMeta();
    }
  }

  @override
  void dispose() {
    _foodChanges?.cancel();
    super.dispose();
  }

  Future<void> _loadMeta() async {
    if (!mounted) return;
    final scope = AppScope.of(context);
    final linked = await scope.db.linkedFoodKeys();
    final builtIn = await scope.nutrition.countBySource(FoodSource.usda);
    final version = await scope.nutrition.bundleVersion();
    final keyOrigin = scope.nutrition.hasRemote ? await scope.nutrition.loadApiKey() : null;
    final used = (await scope.nutrition.foodsByKey(linked)).values.where((f) => f.source != FoodSource.user).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    if (mounted) {
      setState(() {
        _linked = linked;
        _usedUsda = used;
        _keyOrigin = keyOrigin;
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
    final repo = _repo;
    if (repo.updating.value.contains(food.key)) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final fresh = await repo.refresh(food);
      messenger.showSnackBar(
        SnackBar(content: Text(fresh == null ? '${food.source.label} no longer has this food' : 'Updated "${fresh.name}"')),
      );
    } on NutritionSourceException catch (e) {
      if (mounted) {
        await handleNutritionError(context, e);
      } else {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _editKey() async {
    final origin = await showApiKeyDialog(context);
    if (origin != null && mounted) setState(() => _keyOrigin = origin);
  }

  void _show(Food food) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ValueListenableBuilder<Set<String>>(
      valueListenable: _repo.updating,
      builder: (_, updating, _) => _FoodSheet(
        food: food,
        canUpdate: food.source != FoodSource.user && _repo.hasRemote,
        updating: updating.contains(food.key),
        onUpdate: () {
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
        builder: (context, snapshot) => ValueListenableBuilder<Set<String>>(
          valueListenable: _repo.updating,
          builder: (context, updating, _) => _body(context, snapshot.data ?? const <Food>[], updating),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, List<Food> mine, Set<String> updating) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        ListTile(
          leading: const Icon(Icons.inventory_2_outlined),
          title: Text(_builtIn == null ? 'Built-in ingredients' : 'Built-in ingredients: $_builtIn'),
          subtitle: Text('USDA FoodData Central, works offline${_builtInVersion == null ? '' : '\n$_builtInVersion'}'),
          isThreeLine: _builtInVersion != null,
        ),
        if (_keyOrigin != null)
          ListTile(
            leading: const Icon(Icons.travel_explore),
            title: const Text('USDA online lookup'),
            subtitle: Text(switch (_keyOrigin!) {
              ApiKeyOrigin.demo => 'Shared demo key, a few lookups per hour. Add your own free key for more.',
              ApiKeyOrigin.developer => 'Developer key from config/local.json',
              ApiKeyOrigin.user => 'Your own API key',
            }),
            trailing: TextButton(
              onPressed: _editKey,
              child: Text(_keyOrigin == ApiKeyOrigin.user ? 'Change' : 'Add key'),
            ),
          ),
        const Divider(height: 24),
        _section(
          context,
          'My ingredients',
          mine,
          'Add ingredients you cannot find, e.g. from a package label.',
          updating,
        ),
        if (_usedUsda.isNotEmpty) _section(context, 'Online ingredients in your recipes', _usedUsda, '', updating),
      ],
    );
  }

  Widget _section(BuildContext context, String title, List<Food> foods, String empty, Set<String> updating) {
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
            subtitle: Text(
              updating.contains(f.key)
                  ? 'Asking ${f.source == FoodSource.usda ? 'USDA' : 'Open Food Facts'} for the latest values…'
                  : [
                      if (f.per100g[Nutrient.energy] case final kcal?) '${kcal.round()} kcal / 100 g',
                      if (_linked.contains(f.key)) 'used in recipes',
                    ].join(' · '),
            ),
            trailing: updating.contains(f.key)
                ? const SizedBox.square(
                    key: ValueKey('updating'),
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: () => _show(f),
          ),
      ],
    );
  }
}

class _FoodSheet extends StatelessWidget {
  const _FoodSheet({
    required this.food,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdate,
    this.canUpdate = false,
    this.updating = false,
  });

  final Food food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final bool canUpdate;
  final bool updating;

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
            Text(
              food.detail?.isNotEmpty == true ? '${food.source.label} · ${food.detail}' : food.source.label,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text('Per 100 g', style: theme.textTheme.titleSmall),
            for (final n in Nutrient.values)
              if (food.per100g[n] case final v?)
                Row(
                  children: [
                    Expanded(child: Text(n.label)),
                    Text('${formatNutrient(n, v)} ${n.unit}'),
                  ],
                ),
            if (food.per100g.saltG case final salt?)
              Row(
                children: [
                  const Expanded(child: Text('Salt')),
                  Text('${formatNutrient(Nutrient.fat, salt)} g'),
                ],
              ),
            if (food.portions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Portions', style: theme.textTheme.titleSmall),
              for (final p in food.portions)
                Row(
                  children: [
                    Expanded(child: Text(p.label)),
                    Text('${p.grams.round()} g'),
                  ],
                ),
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
                if (canUpdate)
                  OutlinedButton.icon(
                    onPressed: updating ? null : onUpdate,
                    icon: const Icon(Icons.sync),
                    label: Text(updating ? 'Updating…' : 'Update from ${food.source == FoodSource.usda ? 'USDA' : 'Open Food Facts'}'),
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
