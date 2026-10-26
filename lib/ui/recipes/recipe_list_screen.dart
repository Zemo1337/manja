import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../l10n/l10n.dart';
import '../cookbook/cookbook_screen.dart';
import '../nutrition/ingredients_screen.dart';
import '../tools/converter_screen.dart';
import 'import_recipe_screen.dart';
import 'recipe_detail_screen.dart';
import 'recipe_edit_screen.dart';
import 'recipe_photo.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final db = AppScope.of(context).db;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.recipeListTitle),
        actions: [
          IconButton(
            tooltip: l.recipeImportFromLink,
            icon: const Icon(Icons.add_link),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportRecipeScreen())),
          ),
          IconButton(
            tooltip: l.recipeCookbookPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CookbookScreen())),
          ),
          IconButton(
            tooltip: l.recipeUnitConverter,
            icon: const Icon(Icons.scale_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConverterScreen())),
          ),
          IconButton(
            tooltip: l.recipeIngredients,
            icon: const Icon(Icons.kitchen_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IngredientsScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipeEditScreen())),
        icon: const Icon(Icons.add),
        label: Text(l.recipeAdd),
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: db.watchRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final all = snapshot.data!;
          if (all.isEmpty) {
            return Center(child: Text(l.recipeListEmpty));
          }
          final query = _query.trim().toLowerCase();
          final recipes = query.isEmpty
              ? all
              : [
                  for (final r in all)
                    if (r.name.toLowerCase().contains(query)) r,
                ];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SearchBar(
                  hintText: l.recipeSearch,
                  leading: const Icon(Icons.search),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: recipes.length,
                  itemBuilder: (context, i) {
                    final recipe = recipes[i];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox.square(dimension: 48, child: RecipePhoto(recipe: recipe, cacheWidth: 144)),
                      ),
                      title: Text(recipe.name),
                      subtitle: Text(_subtitle(l, recipe)),
                      trailing: IconButton(
                        icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
                        color: recipe.isFavorite ? Theme.of(context).colorScheme.primary : null,
                        onPressed: () => db.setFavorite(recipe.id, !recipe.isFavorite),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: recipe.id)),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _subtitle(AppLocalizations l, Recipe recipe) {
    final total = (recipe.prepMinutes ?? 0) + (recipe.cookMinutes ?? 0);
    final parts = [l.recipePortionCount(recipe.portions), if (total > 0) l.recipeTotalMinutes(total)];
    return parts.join(' · ');
  }
}
