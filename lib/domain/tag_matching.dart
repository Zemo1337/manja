import '../data/database.dart';

const _synonyms = {
  TagKind.main: [
    'main',
    'main course',
    'main dish',
    'mains',
    'dinner',
    'lunch',
    'entree',
    'glavno jelo',
    'glavna jela',
    'ručak',
    'večera',
    'hauptgericht',
    'hauptspeise',
    'hauptgerichte',
  ],
  TagKind.soup: [
    'soup',
    'soups',
    'stew',
    'juha',
    'juhe',
    'čorba',
    'čorbe',
    'varivo',
    'variva',
    'suppe',
    'suppen',
    'eintopf',
    'supa',
    'supe',
  ],
  TagKind.side: [
    'side',
    'side dish',
    'sides',
    'salad',
    'salads',
    'salata',
    'salate',
    'prilog',
    'prilozi',
    'beilage',
    'beilagen',
    'salat',
  ],
  TagKind.breakfast: ['breakfast', 'brunch', 'doručak', 'frühstück'],
  TagKind.dessert: [
    'dessert',
    'desserts',
    'sweet',
    'sweets',
    'cake',
    'cakes',
    'baking',
    'kolač',
    'kolači',
    'slastice',
    'deserti',
    'desert',
    'torta',
    'torte',
    'nachspeise',
    'nachtisch',
    'kuchen',
    'süßspeise',
    'mehlspeise',
    'slatko',
    'slatkiši',
  ],
  TagKind.snack: [
    'snack',
    'snacks',
    'appetizer',
    'appetizers',
    'starter',
    'starters',
    'predjelo',
    'predjela',
    'grickalice',
    'vorspeise',
    'vorspeisen',
    'užina',
    'meze',
  ],
};

/// Tags for the categories of an imported recipe: tags of the same name, and built-in course tags by their usual
/// names in several languages, whatever they are called on this phone.
List<Tag> matchTags(Iterable<String> categories, List<Tag> tags) {
  final byName = {for (final t in tags) t.name.toLowerCase(): t};
  final byKind = {for (final t in tags) ?t.kind: t};
  final result = <Tag>{};
  for (final raw in categories) {
    for (final part in raw.split(RegExp(r'[,;/|]'))) {
      final key = part.trim().toLowerCase();
      if (key.isEmpty) continue;
      if (byName[key] case final tag?) {
        result.add(tag);
        continue;
      }
      for (final MapEntry(key: kind, value: words) in _synonyms.entries) {
        if (words.contains(key) && byKind[kind] != null) result.add(byKind[kind]!);
      }
    }
  }
  return result.toList();
}
