import 'text_fold.dart';

/// An ingredient name used in recipes, with the food it is usually linked to.
class IngredientSuggestion {
  const IngredientSuggestion(this.name, this.recipes, {this.foodKey});

  final String name;
  final int recipes;
  final String? foodKey;
}

/// Joins spellings that differ only in case or accents, keeping the most used spelling and link.
List<IngredientSuggestion> ingredientSuggestions(List<({String name, String? foodKey, int recipes})> uses) {
  final byName = <String, List<({String name, String? foodKey, int recipes})>>{};
  for (final u in uses) {
    final name = u.name.trim();
    if (name.isNotEmpty) byName.putIfAbsent(foldText(name), () => []).add(u);
  }
  int mostUsed(({String name, String? foodKey, int recipes}) a, ({String name, String? foodKey, int recipes}) b) =>
      b.recipes.compareTo(a.recipes);
  return [
    for (final group in byName.values)
      IngredientSuggestion(
        (group.toList()..sort(mostUsed)).first.name.trim(),
        group.fold(0, (sum, u) => sum + u.recipes),
        foodKey: (group.where((u) => u.foodKey != null).toList()..sort(mostUsed)).firstOrNull?.foodKey,
      ),
  ];
}

/// Names starting with what was typed come first, then names with a word starting with it; the most used on top.
List<IngredientSuggestion> matchIngredientSuggestions(
  List<IngredientSuggestion> suggestions,
  String typed, {
  int limit = 6,
}) {
  final query = foldText(typed.trim());
  if (query.isEmpty) return const [];
  final matches = <(IngredientSuggestion, bool)>[];
  for (final s in suggestions) {
    final name = foldText(s.name);
    if (name == query) continue;
    if (name.startsWith(query)) {
      matches.add((s, true));
    } else if (name.split(RegExp(r'[\s,()-]+')).any((w) => w.startsWith(query))) {
      matches.add((s, false));
    }
  }
  matches.sort((a, b) {
    if (a.$2 != b.$2) return a.$2 ? -1 : 1;
    final byUse = b.$1.recipes.compareTo(a.$1.recipes);
    return byUse != 0 ? byUse : compareNames(a.$1.name, b.$1.name);
  });
  return [for (final (s, _) in matches.take(limit)) s];
}
