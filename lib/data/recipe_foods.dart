import 'package:nutrition_core/nutrition_core.dart';

import '../domain/units.dart';
import 'database.dart';
import 'nutrition_repository.dart';

String recipeFoodKey(int recipeId) => '${FoodSource.recipe.id}:$recipeId';

int? recipeIdOfFoodKey(String? key) {
  const prefix = 'recipe:';
  return key != null && key.startsWith(prefix) ? int.tryParse(key.substring(prefix.length)) : null;
}

/// The units a recipe used as an ingredient can be measured in.
const recipeUnits = [CookingUnit.portion, CookingUnit.g, CookingUnit.kg, CookingUnit.oz, CookingUnit.lb];

List<IngredientLine> ingredientLines(RecipeFull full, Map<String, Food> foods) => [
  for (final i in full.ingredients)
    IngredientLine(name: i.name, amount: i.amount, unit: CookingUnit.fromName(i.unit), food: foods[i.foodKey]),
];

/// Foods for [keys]. Recipes used as ingredients are worked out from their own ingredients; a recipe in
/// [visiting] is left out, so a recipe that ends up using itself cannot loop.
Future<Map<String, Food>> resolveFoods(AppDatabase db, Set<String> keys, {Set<int> visiting = const {}}) async {
  final foods = {for (final row in await db.foodRows(keys)) row.key: foodFromRow(row)};
  for (final key in keys) {
    final id = recipeIdOfFoodKey(key);
    if (id == null || visiting.contains(id)) continue;
    if (await recipeFood(db, id, visiting: visiting) case final food?) foods[key] = food;
  }
  return foods;
}

Future<RecipeNutrition> recipeNutrition(AppDatabase db, RecipeFull full, {Set<int> visiting = const {}}) async {
  final keys = {for (final i in full.ingredients) ?i.foodKey};
  final foods = await resolveFoods(db, keys, visiting: {...visiting, full.recipe.id});
  return RecipeNutrition.calculate(
    ingredientLines(full, foods),
    portions: full.recipe.portions,
    finishedWeightG: full.recipe.finishedWeightG,
  );
}

Future<Food?> recipeFood(AppDatabase db, int recipeId, {Set<int> visiting = const {}}) async {
  final full = await db.recipeFull(recipeId);
  if (full == null) return null;
  return recipeAsFood(full.recipe, await recipeNutrition(db, full, visiting: visiting));
}

/// A recipe as an ingredient: its nutrition per 100 g and one portion's weight, taken from the finished weight or
/// estimated from the raw ingredients.
Food recipeAsFood(Recipe recipe, RecipeNutrition nutrition) {
  final grams = nutrition.portionWeightG;
  final known = grams > 0;
  return Food(
    source: FoodSource.recipe,
    sourceId: '${recipe.id}',
    name: recipe.name,
    per100g: known ? nutrition.per100g : Nutrients.empty,
    portions: [if (known) FoodPortion(label: 'portion', grams: grams, unit: CookingUnit.portion)],
    detail: !known
        ? 'Weight of a portion unknown'
        : '1 portion ${nutrition.finishedWeightG == null ? '≈' : '='} ${formatAmount(grams)} g',
  );
}

/// Recipes that use [recipeId] as an ingredient, directly or through other recipes, and the recipe itself; none of
/// these can become its ingredient.
Future<Set<int>> recipesUsing(AppDatabase db, int recipeId) async {
  final usedBy = <int, Set<int>>{};
  for (final i in await db.allRecipeIngredients()) {
    if (recipeIdOfFoodKey(i.foodKey) case final used?) usedBy.putIfAbsent(used, () => {}).add(i.recipeId);
  }
  final found = {recipeId};
  final queue = [recipeId];
  while (queue.isNotEmpty) {
    for (final user in usedBy[queue.removeLast()] ?? const <int>{}) {
      if (found.add(user)) queue.add(user);
    }
  }
  return found;
}
