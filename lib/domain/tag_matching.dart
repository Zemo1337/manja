const _synonyms = {
  'Main': ['main', 'main course', 'main dish', 'mains', 'dinner', 'lunch', 'entree', 'glavno jelo', 'glavna jela', 'ručak', 'večera', 'hauptgericht', 'hauptspeise', 'hauptgerichte'],
  'Soup': ['soup', 'soups', 'stew', 'juha', 'juhe', 'čorba', 'čorbe', 'varivo', 'variva', 'suppe', 'suppen', 'eintopf'],
  'Side or salad': ['side', 'side dish', 'sides', 'salad', 'salads', 'salata', 'salate', 'prilog', 'prilozi', 'beilage', 'beilagen', 'salat'],
  'Breakfast': ['breakfast', 'brunch', 'doručak', 'frühstück'],
  'Dessert': ['dessert', 'desserts', 'sweet', 'sweets', 'cake', 'cakes', 'baking', 'kolač', 'kolači', 'slastice', 'deserti', 'desert', 'torta', 'torte', 'nachspeise', 'nachtisch', 'kuchen', 'süßspeise', 'mehlspeise'],
  'Snack': ['snack', 'snacks', 'appetizer', 'appetizers', 'starter', 'starters', 'predjelo', 'predjela', 'grickalice', 'vorspeise', 'vorspeisen'],
};

List<String> matchTagNames(Iterable<String> categories, Iterable<String> tagNames) {
  final byKey = {for (final t in tagNames) t.toLowerCase(): t};
  final result = <String>{};
  for (final raw in categories) {
    for (final part in raw.split(RegExp(r'[,;/|]'))) {
      final key = part.trim().toLowerCase();
      if (key.isEmpty) continue;
      if (byKey[key] case final name?) {
        result.add(name);
        continue;
      }
      for (final MapEntry(key: tag, value: words) in _synonyms.entries) {
        if (words.contains(key) && byKey[tag.toLowerCase()] != null) result.add(byKey[tag.toLowerCase()]!);
      }
    }
  }
  return result.toList();
}
