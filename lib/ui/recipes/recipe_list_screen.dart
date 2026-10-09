import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../nutrition/ingredients_screen.dart';
import '../tools/converter_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            tooltip: 'Unit converter',
            icon: const Icon(Icons.scale_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConverterScreen())),
          ),
          IconButton(
            tooltip: 'Ingredients',
            icon: const Icon(Icons.kitchen_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IngredientsScreen())),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipeEditScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Add recipe'),
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: db.watchRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final all = snapshot.data!;
          if (all.isEmpty) {
            return const Center(child: Text('No recipes yet. Tap "Add recipe" to start.'));
          }
          final query = _query.trim().toLowerCase();
          final recipes = query.isEmpty ? all : [for (final r in all) if (r.name.toLowerCase().contains(query)) r];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SearchBar(
                  hintText: 'Search recipes',
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
                      subtitle: Text(_subtitle(recipe)),
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

  String _subtitle(Recipe recipe) {
    final total = (recipe.prepMinutes ?? 0) + (recipe.cookMinutes ?? 0);
    final parts = [
      '${recipe.portions} ${recipe.portions == 1 ? 'portion' : 'portions'}',
      if (total > 0) '$total min',
    ];
    return parts.join(' · ');
  }
}
