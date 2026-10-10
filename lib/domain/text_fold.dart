const _folded = {'č': 'c', 'ć': 'c', 'š': 's', 'ž': 'z', 'đ': 'd', 'ä': 'a', 'ö': 'o', 'ü': 'u', 'ß': 'ss'};

String foldText(String text) => text.toLowerCase().split('').map((c) => _folded[c] ?? c).join();

int compareNames(String a, String b) {
  final byKey = foldText(a).compareTo(foldText(b));
  return byKey != 0 ? byKey : a.toLowerCase().compareTo(b.toLowerCase());
}
