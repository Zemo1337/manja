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
}
