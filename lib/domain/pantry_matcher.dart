class AvailableIngredient {
  const AvailableIngredient(this.name, {this.foodKey});

  final String name;
  final String? foodKey;
}

class MatchIngredient {
  const MatchIngredient(this.name, {this.foodKey, this.foodName});

  final String name;
  final String? foodKey;
  final String? foodName;
}

class MatchRecipe<T> {
  const MatchRecipe(this.recipe, this.ingredients);

  final T recipe;
  final List<MatchIngredient> ingredients;
}

class RecipeMatch<T> {
  const RecipeMatch(this.recipe, {required this.missing, required this.used, required this.cravingsUsed});

  final T recipe;
  final List<MatchIngredient> missing;
  final List<MatchIngredient> used;
  final int cravingsUsed;

  bool get complete => missing.isEmpty;
}

const _alwaysAvailable = {'water', 'voda', 'vode', 'wasser'};

const _ignoredWords = {
  'of',
  'the',
  'and',
  'a',
  'an',
  'for',
  'to',
  'or',
  'with',
  'i',
  'za',
  'od',
  'sa',
  's',
  'u',
  'und',
  'oder',
};

final _split = RegExp(r"[^\p{L}\p{N}]+", unicode: true);
final _notes = RegExp(r'\([^)]*\)');
final _ending = RegExp(r'(es|s|a|e|i|o|u)$');

String stemWord(String word) {
  var w = word.toLowerCase();
  for (var i = 0; i < 2 && w.length > 3; i++) {
    final next = w.replaceFirst(_ending, '');
    if (next == w || next.length < 2) break;
    w = next;
  }
  return w;
}

Set<String> nameStems(String name) => {
  for (final word in name.replaceAll(_notes, ' ').split(',').first.toLowerCase().split(_split))
    if (word.isNotEmpty && !_ignoredWords.contains(word) && !RegExp(r'^\d+$').hasMatch(word)) stemWord(word),
};

Set<String> _allStems(String name) => {
  for (final word in name.replaceAll(_notes, ' ').toLowerCase().split(_split))
    if (word.isNotEmpty && !_ignoredWords.contains(word) && !RegExp(r'^\d+$').hasMatch(word)) stemWord(word),
};

bool ingredientMatches(MatchIngredient ingredient, AvailableIngredient item) {
  if (ingredient.foodKey != null && ingredient.foodKey == item.foodKey) return true;
  final wanted = nameStems(item.name);
  if (wanted.isEmpty) return false;
  if (_allStems(ingredient.name).containsAll(wanted)) return true;
  final food = ingredient.foodName;
  return food != null && nameStems(food).containsAll(wanted);
}

bool alwaysAvailable(MatchIngredient ingredient) {
  final stems = _allStems(ingredient.name);
  return stems.isNotEmpty && stems.every((s) => _alwaysAvailable.any((w) => stemWord(w) == s));
}

List<RecipeMatch<T>> matchRecipes<T>(
  List<MatchRecipe<T>> recipes, {
  required List<AvailableIngredient> pantry,
  List<AvailableIngredient> cravings = const [],
  int maxMissing = 2,
}) {
  final have = [...pantry, ...cravings];
  final matches = <RecipeMatch<T>>[];
  for (final r in recipes) {
    if (r.ingredients.isEmpty) continue;
    final missing = <MatchIngredient>[];
    final used = <MatchIngredient>[];
    var cravingsUsed = 0;
    for (final ingredient in r.ingredients) {
      if (alwaysAvailable(ingredient)) {
        used.add(ingredient);
        continue;
      }
      if (have.any((item) => ingredientMatches(ingredient, item))) {
        used.add(ingredient);
        if (cravings.any((item) => ingredientMatches(ingredient, item))) cravingsUsed++;
      } else {
        missing.add(ingredient);
      }
    }
    if (cravings.isNotEmpty && cravingsUsed == 0) continue;
    if (missing.length > maxMissing) continue;
    matches.add(RecipeMatch(r.recipe, missing: missing, used: used, cravingsUsed: cravingsUsed));
  }
  matches.sort((a, b) {
    final byMissing = a.missing.length.compareTo(b.missing.length);
    if (byMissing != 0) return byMissing;
    return b.cravingsUsed.compareTo(a.cravingsUsed);
  });
  return matches;
}
