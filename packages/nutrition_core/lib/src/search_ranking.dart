final _wordSplit = RegExp(r'[^a-z0-9%.]+');
final _brand = RegExp(r'\b[A-Z]{3,}\b');

List<String> searchWords(String query) =>
    query.toLowerCase().split(_wordSplit).where((w) => w.isNotEmpty).toList();

bool _sameWord(String word, String query) =>
    word == query || word == '${query}s' || word == '${query}es' || (query.endsWith('s') && word == query.substring(0, query.length - 1));

double searchScore(String query, String name, {bool hasPortions = false}) {
  final words = searchWords(query);
  if (words.isEmpty) return 0;
  final lower = name.toLowerCase();
  final head = searchWords(lower.split(',').first);
  final nameWords = searchWords(lower);
  var score = 0.0;
  if (head.isNotEmpty && head.every((h) => words.any((q) => _sameWord(h, q)))) score += 100;
  if (nameWords.isNotEmpty && _sameWord(nameWords.first, words.first)) score += 10;
  for (final q in words) {
    if (nameWords.any((w) => _sameWord(w, q))) {
      score += 15;
    } else if (nameWords.any((w) => w.startsWith(q))) {
      score += 5;
    }
  }
  if (hasPortions) score += 20;
  if (nameWords.contains('raw')) score += 4;
  if (_brand.hasMatch(name)) score -= 30;
  return score - name.length / 20;
}
