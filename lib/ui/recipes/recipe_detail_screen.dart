import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nutrition_core/nutrition_core.dart' show IngredientLine, RecipeNutrition;

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../domain/units.dart';
import '../app_theme.dart';
import '../nutrition/nutrition_panel.dart';
import 'recipe_edit_screen.dart';
import 'recipe_photo.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final int recipeId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeFull? _full;
  RecipeNutrition? _nutrition;
  bool _loaded = false;
  int? _portions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _load();
  }

  Future<void> _load() async {
    _loaded = true;
    final scope = AppScope.of(context);
    final full = await scope.db.recipeFull(widget.recipeId);
    RecipeNutrition? nutrition;
    if (full != null) {
      final foods = await scope.nutrition.foodsByKey({for (final i in full.ingredients) ?i.foodKey});
      nutrition = RecipeNutrition.calculate(
        [
          for (final i in full.ingredients)
            IngredientLine(name: i.name, amount: i.amount, unit: CookingUnit.fromName(i.unit), food: foods[i.foodKey]),
        ],
        portions: full.recipe.portions,
        finishedWeightG: full.recipe.finishedWeightG,
      );
    }
    if (!mounted) return;
    setState(() {
      _full = full;
      _nutrition = nutrition;
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
    if (ok != true || !mounted) return;
    final photos = AppScope.of(context).photos;
    await db.deleteRecipe(widget.recipeId);
    await photos.delete(_full!.recipe.photoPath);
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
          if (recipe.photoPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: RecipePhoto(recipe: recipe, cacheWidth: 1200),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (recipe.prepMinutes != null)
                _InfoChip(icon: Icons.timer_outlined, label: 'Prep ${recipe.prepMinutes} min'),
              if (recipe.cookMinutes != null)
                _InfoChip(icon: Icons.local_fire_department_outlined, label: 'Cook ${recipe.cookMinutes} min'),
              for (final t in full.tags) _InfoChip(icon: Icons.label_outline, label: t.name),
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
              IconButton(
                onPressed: () => setState(() => _portions = portions + 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
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
                      ingredient.amount > 0
                          ? '${formatAmount(ingredient.amount * scale)} ${CookingUnit.fromName(ingredient.unit).symbol}'
                          : '',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(child: Text(ingredient.name, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
          const Divider(),
          Text('Nutrition', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          if (_nutrition != null) NutritionPanel(result: _nutrition!),
          if (recipe.cookingInfo.isNotEmpty) ...[
            const Divider(),
            Text('Cooking info', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(recipe.cookingInfo),
          ],
          if (recipe.sourceUrl case final source?)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                onPressed: () => launchUrl(Uri.parse(source), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.link, size: 18),
                label: Text('Source: ${Uri.tryParse(source)?.host ?? source}', overflow: TextOverflow.ellipsis),
              ),
            ),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = HighlightColors.of(context);
    return Chip(
      avatar: Icon(icon, color: colors.foreground),
      label: Text(label, style: TextStyle(color: colors.foreground)),
      backgroundColor: colors.background,
      side: BorderSide.none,
    );
  }
}
