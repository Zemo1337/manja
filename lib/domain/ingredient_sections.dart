import '../data/database.dart';

/// Ingredients in their order, split wherever the section heading changes.
List<({String? section, List<RecipeIngredient> items})> ingredientSections(List<RecipeIngredient> ingredients) {
  final groups = <({String? section, List<RecipeIngredient> items})>[];
  for (final i in ingredients) {
    if (groups.isEmpty || groups.last.section != i.section) groups.add((section: i.section, items: []));
    groups.last.items.add(i);
  }
  return groups;
}
