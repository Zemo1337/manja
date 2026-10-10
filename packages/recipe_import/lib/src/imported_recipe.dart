import 'package:nutrition_core/nutrition_core.dart';

class ImportedRecipe {
  const ImportedRecipe({
    required this.name,
    this.description,
    this.imageUrl,
    this.portions,
    this.prepMinutes,
    this.cookMinutes,
    this.totalMinutes,
    this.ingredients = const [],
    this.steps = const [],
    this.sourceUrl,
    this.categories = const [],
  });

  final String name;
  final String? description;
  final Uri? imageUrl;
  final int? portions;
  final int? prepMinutes;
  final int? cookMinutes;
  final int? totalMinutes;
  final List<ParsedIngredient> ingredients;
  final List<String> steps;
  final Uri? sourceUrl;
  final List<String> categories;

  ImportedRecipe withImage(Uri? image) => image == null || imageUrl != null
      ? this
      : ImportedRecipe(
          name: name,
          description: description,
          imageUrl: image,
          portions: portions,
          prepMinutes: prepMinutes,
          cookMinutes: cookMinutes,
          totalMinutes: totalMinutes,
          ingredients: ingredients,
          steps: steps,
          sourceUrl: sourceUrl,
          categories: categories,
        );
}
