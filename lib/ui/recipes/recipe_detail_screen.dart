import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/units.dart';
import 'recipe_edit_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final int recipeId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeFull? _full;
  bool _loaded = false;
  int? _portions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _load();
  }

  Future<void> _load() async {
    _loaded = true;
    final full = await AppScope.of(context).db.recipeFull(widget.recipeId);
    if (!mounted) return;
    setState(() {
      _full = full;
      _portions = full?.recipe.portions;
    });
  }

  Future<void> _edit() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeEditScreen(existing: _full)));
    await _load();
  }

  Future<void> _delete() async {
    final db = AppScope.of(context).db;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('"${_full!.recipe.name}" and its meal history will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await db.deleteRecipe(widget.recipeId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final full = _full;
    if (full == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: _loaded ? const Text('Recipe not found') : const CircularProgressIndicator()),
      );
    }
    final theme = Theme.of(context);
    final recipe = full.recipe;
    final portions = _portions ?? recipe.portions;
    final scale = portions / recipe.portions;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(tooltip: 'Edit', icon: const Icon(Icons.edit_outlined), onPressed: _edit),
          IconButton(tooltip: 'Delete', icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (recipe.prepMinutes != null) Chip(avatar: const Icon(Icons.timer_outlined), label: Text('Prep ${recipe.prepMinutes} min')),
              if (recipe.cookMinutes != null)
                Chip(avatar: const Icon(Icons.local_fire_department_outlined), label: Text('Cook ${recipe.cookMinutes} min')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Portions', style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton(
                onPressed: portions > 1 ? () => setState(() => _portions = portions - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$portions', style: theme.textTheme.titleMedium),
              IconButton(onPressed: () => setState(() => _portions = portions + 1), icon: const Icon(Icons.add_circle_outline)),
            ],
          ),
          const Divider(),
          Text('Ingredients', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          if (full.ingredients.isEmpty) const Text('No ingredients added.'),
          for (final ingredient in full.ingredients)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      '${formatAmount(ingredient.amount * scale)} ${CookingUnit.fromName(ingredient.unit).symbol}',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(child: Text(ingredient.name, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
          if (recipe.cookingInfo.isNotEmpty) ...[
            const Divider(),
            Text('Cooking info', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(recipe.cookingInfo),
          ],
          const Divider(),
          Text('Preparation', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          if (full.steps.isEmpty) const Text('No steps added.'),
          for (final (index, step) in full.steps.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 14, child: Text('${index + 1}')),
              title: Text(step.body),
            ),
        ],
      ),
    );
  }
}
