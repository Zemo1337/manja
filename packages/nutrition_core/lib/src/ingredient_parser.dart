import 'units.dart';

class ParsedIngredient {
  const ParsedIngredient({required this.name, this.amount, this.unit, this.note});

  final String name;
  final double? amount;
  final CookingUnit? unit;
  final String? note;

  @override
  String toString() => 'ParsedIngredient($amount ${unit?.symbol} $name${note == null ? '' : ' ($note)'})';
}

const _vulgar = {
  '½': 0.5,
  '⅓': 1 / 3,
  '⅔': 2 / 3,
  '¼': 0.25,
  '¾': 0.75,
  '⅕': 0.2,
  '⅖': 0.4,
  '⅗': 0.6,
  '⅘': 0.8,
  '⅙': 1 / 6,
  '⅚': 5 / 6,
  '⅛': 0.125,
  '⅜': 0.375,
  '⅝': 0.625,
  '⅞': 0.875,
};

const _unitWords = <String, (CookingUnit, double)>{
  'g': (CookingUnit.g, 1),
  'gr': (CookingUnit.g, 1),
  'gram': (CookingUnit.g, 1),
  'grams': (CookingUnit.g, 1),
  'grama': (CookingUnit.g, 1),
  'grame': (CookingUnit.g, 1),
  'gramm': (CookingUnit.g, 1),
  'dag': (CookingUnit.g, 10),
  'dkg': (CookingUnit.g, 10),
  'kg': (CookingUnit.kg, 1),
  'kilogram': (CookingUnit.kg, 1),
  'kilograms': (CookingUnit.kg, 1),
  'mg': (CookingUnit.mg, 1),
  'oz': (CookingUnit.oz, 1),
  'ounce': (CookingUnit.oz, 1),
  'ounces': (CookingUnit.oz, 1),
  'lb': (CookingUnit.lb, 1),
  'lbs': (CookingUnit.lb, 1),
  'pound': (CookingUnit.lb, 1),
  'pounds': (CookingUnit.lb, 1),
  'ml': (CookingUnit.ml, 1),
  'millilitre': (CookingUnit.ml, 1),
  'milliliter': (CookingUnit.ml, 1),
  'millilitres': (CookingUnit.ml, 1),
  'milliliters': (CookingUnit.ml, 1),
  'l': (CookingUnit.l, 1),
  'litre': (CookingUnit.l, 1),
  'liter': (CookingUnit.l, 1),
  'litres': (CookingUnit.l, 1),
  'liters': (CookingUnit.l, 1),
  'litra': (CookingUnit.l, 1),
  'dl': (CookingUnit.dl, 1),
  'cl': (CookingUnit.cl, 1),
  'tsp': (CookingUnit.tsp, 1),
  'teaspoon': (CookingUnit.tsp, 1),
  'teaspoons': (CookingUnit.tsp, 1),
  'žličica': (CookingUnit.tsp, 1),
  'žličice': (CookingUnit.tsp, 1),
  'žličicu': (CookingUnit.tsp, 1),
  'kašičica': (CookingUnit.tsp, 1),
  'kašičice': (CookingUnit.tsp, 1),
  'kašičicu': (CookingUnit.tsp, 1),
  'tl': (CookingUnit.tsp, 1),
  'kl': (CookingUnit.tsp, 1),
  'tbsp': (CookingUnit.tbsp, 1),
  'tbs': (CookingUnit.tbsp, 1),
  'tablespoon': (CookingUnit.tbsp, 1),
  'tablespoons': (CookingUnit.tbsp, 1),
  'žlica': (CookingUnit.tbsp, 1),
  'žlice': (CookingUnit.tbsp, 1),
  'žlicu': (CookingUnit.tbsp, 1),
  'kašika': (CookingUnit.tbsp, 1),
  'kašike': (CookingUnit.tbsp, 1),
  'kašiku': (CookingUnit.tbsp, 1),
  'el': (CookingUnit.tbsp, 1),
  'vk': (CookingUnit.tbsp, 1),
  'cup': (CookingUnit.cup, 1),
  'cups': (CookingUnit.cup, 1),
  'c': (CookingUnit.cup, 1),
  'šalica': (CookingUnit.cup, 1),
  'šalice': (CookingUnit.cup, 1),
  'šalicu': (CookingUnit.cup, 1),
  'šolja': (CookingUnit.cup, 1),
  'šolje': (CookingUnit.cup, 1),
  'šolju': (CookingUnit.cup, 1),
  'pint': (CookingUnit.pint, 1),
  'pints': (CookingUnit.pint, 1),
  'pt': (CookingUnit.pint, 1),
  'quart': (CookingUnit.quart, 1),
  'quarts': (CookingUnit.quart, 1),
  'qt': (CookingUnit.quart, 1),
  'pinch': (CookingUnit.pinch, 1),
  'pinches': (CookingUnit.pinch, 1),
  'prstohvat': (CookingUnit.pinch, 1),
  'prise': (CookingUnit.pinch, 1),
  'clove': (CookingUnit.clove, 1),
  'cloves': (CookingUnit.clove, 1),
  'češanj': (CookingUnit.clove, 1),
  'češnja': (CookingUnit.clove, 1),
  'češnjeva': (CookingUnit.clove, 1),
  'čen': (CookingUnit.clove, 1),
  'čena': (CookingUnit.clove, 1),
  'zehe': (CookingUnit.clove, 1),
  'zehen': (CookingUnit.clove, 1),
  'slice': (CookingUnit.slice, 1),
  'slices': (CookingUnit.slice, 1),
  'kriška': (CookingUnit.slice, 1),
  'kriške': (CookingUnit.slice, 1),
  'kriški': (CookingUnit.slice, 1),
  'scheibe': (CookingUnit.slice, 1),
  'scheiben': (CookingUnit.slice, 1),
  'can': (CookingUnit.can, 1),
  'cans': (CookingUnit.can, 1),
  'konzerva': (CookingUnit.can, 1),
  'konzerve': (CookingUnit.can, 1),
  'limenka': (CookingUnit.can, 1),
  'limenke': (CookingUnit.can, 1),
  'dose': (CookingUnit.can, 1),
  'piece': (CookingUnit.piece, 1),
  'pieces': (CookingUnit.piece, 1),
  'pc': (CookingUnit.piece, 1),
  'pcs': (CookingUnit.piece, 1),
  'kom': (CookingUnit.piece, 1),
  'komad': (CookingUnit.piece, 1),
  'komada': (CookingUnit.piece, 1),
  'stück': (CookingUnit.piece, 1),
  'stk': (CookingUnit.piece, 1),
};

const _twoWordUnits = <String, (CookingUnit, double)>{
  'fl oz': (CookingUnit.flOz, 1),
  'fluid ounce': (CookingUnit.flOz, 1),
  'fluid ounces': (CookingUnit.flOz, 1),
};

final _number = RegExp(r'^(\d+(?:[.,]\d+)?)');
final _fraction = RegExp(r'^(\d+)\s*/\s*(\d+)');
final _mixed = RegExp(r'^(\d+)(?:\s+|\s*-\s*)(\d+)\s*/\s*(\d+)');
final _range = RegExp(r'^\s*(?:-|–|to|do)\s*\d+(?:[.,/]\d+)?');
final _note = RegExp(r'\s*\(([^()]*(?:\([^()]*\)[^()]*)*)\)');

ParsedIngredient parseIngredientLine(String line) {
  var text = line.replaceAll(RegExp(r'\s+'), ' ').trim();
  final notes = <String>[];
  text = text.replaceAllMapped(_note, (m) {
    final inner = m.group(1)!.replaceAll(RegExp(r'^\(|\)$'), '').trim();
    if (inner.isNotEmpty) notes.add(inner);
    return '';
  }).trim();
  final comma = text.indexOf(',');
  final amount = _readAmount(text);
  var rest = amount?.$2 ?? text;
  rest = rest.replaceFirst(_range, '').trim();
  CookingUnit? unit;
  var factor = 1.0;
  final lower = rest.toLowerCase();
  for (final e in _twoWordUnits.entries) {
    if (lower.startsWith('${e.key} ') || lower == e.key) {
      (unit, factor) = e.value;
      rest = rest.substring(e.key.length).trim();
      break;
    }
  }
  if (unit == null) {
    final word = RegExp(r'^([^\s\d.,]+)\.?(?=\s|$)').firstMatch(rest);
    final candidate = word?.group(1);
    if (candidate != null) {
      final found =
          _unitWords[candidate.toLowerCase()] ??
          (candidate == 'T' ? (CookingUnit.tbsp, 1.0) : null) ??
          (candidate == 't' ? (CookingUnit.tsp, 1.0) : null);
      if (found != null && amount != null) {
        (unit, factor) = found;
        rest = rest.substring(word!.end).trim();
      }
    }
  }
  rest = rest.replaceFirst(RegExp(r'^(of|od)\s+', caseSensitive: false), '').trim();
  if (comma >= 0 && amount == null && unit == null) {
    final after = text.substring(comma + 1).trim();
    if (after.isNotEmpty) notes.add(after);
    rest = text.substring(0, comma).trim();
  } else {
    final inRest = rest.indexOf(',');
    if (inRest >= 0) {
      final after = rest.substring(inRest + 1).trim();
      if (after.isNotEmpty) notes.add(after);
      rest = rest.substring(0, inRest).trim();
    }
  }
  final value = amount == null ? null : amount.$1 * factor;
  return ParsedIngredient(
    name: rest.isEmpty ? line.trim() : rest,
    amount: value,
    unit: unit ?? (value == null ? null : CookingUnit.piece),
    note: notes.isEmpty ? null : notes.join('; '),
  );
}

(double, String)? _readAmount(String text) {
  final s = text.trimLeft();
  final mixed = _mixed.firstMatch(s);
  if (mixed != null) {
    final whole = double.parse(mixed.group(1)!);
    final den = double.parse(mixed.group(3)!);
    if (den != 0) return (whole + double.parse(mixed.group(2)!) / den, s.substring(mixed.end).trim());
  }
  final fraction = _fraction.firstMatch(s);
  if (fraction != null) {
    final den = double.parse(fraction.group(2)!);
    if (den != 0) return (double.parse(fraction.group(1)!) / den, s.substring(fraction.end).trim());
  }
  final number = _number.firstMatch(s);
  var value = number == null ? null : double.parse(number.group(1)!.replaceAll(',', '.'));
  var rest = number == null ? s : s.substring(number.end);
  final vulgar = rest.trimLeft().isEmpty ? null : _vulgar[rest.trimLeft()[0]];
  if (vulgar != null) {
    value = (value ?? 0) + vulgar;
    rest = rest.trimLeft().substring(1);
  }
  if (value == null) return null;
  return (value, rest.trim());
}
