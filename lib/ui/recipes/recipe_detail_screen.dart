import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart' show LineNutrition, RecipeNutrition, gramsPerCount;
import 'package:url_launcher/url_launcher.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../data/recipe_foods.dart';
import '../../domain/ingredient_sections.dart';
import '../../domain/units.dart';
import '../app_theme.dart';
import '../nutrition/nutrition_panel.dart';
import 'recipe_edit_screen.dart';
import 'recipe_photo.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId, this.portions});

  final int recipeId;

  /// The portions to show first, e.g. as many buns as the burger opened from needs.
  final int? portions;

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
      nutrition = await recipeNutrition(scope.db, full);
    }
    if (!mounted) return;
    setState(() {
      _full = full;
      _nutrition = nutrition;
      _portions = _portions == null ? widget.portions ?? full?.recipe.portions : full?.recipe.portions;
    });
  }

  Widget _ingredientRow(BuildContext context, RecipeIngredient ingredient, double scale, Widget row) {
    final padded = Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: row);
    final used = recipeIdOfFoodKey(ingredient.foodKey);
    if (used == null) return padded;
    final index = _full!.ingredients.indexOf(ingredient);
    final lines = _nutrition?.lines;
    final line = lines != null && index >= 0 && index < lines.length ? lines[index] : null;
    return InkWell(borderRadius: BorderRadius.circular(8), onTap: () => _openUsed(used, line, scale), child: padded);
  }

  /// Opens a recipe used as an ingredient, set to the portions this recipe needs of it.
  void _openUsed(int recipeId, LineNutrition? line, double scale) {
    final food = line?.line.food;
    final each = food == null ? null : gramsPerCount(food, CookingUnit.portion);
    final needed = line?.grams == null || each == null || each <= 0 ? null : line!.grams! * scale / each;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(recipeId: recipeId, portions: needed == null ? null : max(1, needed.ceil())),
      ),
    );
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
          for (final (index, group) in ingredientSections(full.ingredients).indexed) ...[
            if (group.section case final section?)
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 4 : 16, bottom: 4),
                child: Text(section, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
              ),
            for (final ingredient in group.items)
              _ingredientRow(
                context,
                ingredient,
                scale,
                Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        ingredient.amount > 0
                            ? '${formatAmount(ingredient.amount * scale)} ${unitText(CookingUnit.fromName(ingredient.unit), ingredient.amount * scale)}'
                            : '',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: recipeIdOfFoodKey(ingredient.foodKey) == null
                            ? theme.textTheme.bodyLarge
                            : theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: theme.colorScheme.primary,
                              ),
                      ),
                    ),
                    if (recipeIdOfFoodKey(ingredient.foodKey) != null)
                      Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                  ],
                ),
              ),
          ],
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
