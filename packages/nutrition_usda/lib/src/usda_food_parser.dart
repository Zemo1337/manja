import 'package:nutrition_core/nutrition_core.dart';

const _nutrientIds = <Nutrient, List<int>>{
  Nutrient.energy: [1008, 2047, 2048],
  Nutrient.protein: [1003],
  Nutrient.fat: [1004],
  Nutrient.saturatedFat: [1258],
  Nutrient.carbohydrate: [1005],
  Nutrient.sugars: [2000, 1063],
  Nutrient.fiber: [1079],
  Nutrient.sodium: [1093],
};

const _unitWords = <String, CookingUnit>{
  'cup': CookingUnit.cup,
  'cups': CookingUnit.cup,
  'tbsp': CookingUnit.tbsp,
  'tablespoon': CookingUnit.tbsp,
  'tablespoons': CookingUnit.tbsp,
  'tsp': CookingUnit.tsp,
  'teaspoon': CookingUnit.tsp,
  'teaspoons': CookingUnit.tsp,
  'fl oz': CookingUnit.flOz,
  'fluid ounce': CookingUnit.flOz,
  'quart': CookingUnit.quart,
  'qt': CookingUnit.quart,
  'pint': CookingUnit.pint,
  'pt': CookingUnit.pint,
  'ml': CookingUnit.ml,
  'liter': CookingUnit.l,
  'litre': CookingUnit.l,
  'l': CookingUnit.l,
  'slice': CookingUnit.slice,
  'slices': CookingUnit.slice,
  'clove': CookingUnit.clove,
  'cloves': CookingUnit.clove,
  'piece': CookingUnit.piece,
  'pieces': CookingUnit.piece,
  'can': CookingUnit.can,
  'pinch': CookingUnit.pinch,
  'dash': CookingUnit.pinch,
};

const _skippedUnits = {'oz', 'lb', 'g', 'gram', 'kg', 'racc'};

Food parseUsdaFood(Map<String, dynamic> json) {
  final amounts = <int, double>{};
  for (final entry in (json['foodNutrients'] as List? ?? const [])) {
    final item = entry as Map<String, dynamic>;
    final nutrient = item['nutrient'] as Map<String, dynamic>?;
    final id = (nutrient?['id'] ?? item['nutrientId']) as int?;
    final amount = (item['amount'] ?? item['value']) as num?;
    if (id != null && amount != null) amounts[id] = amount.toDouble();
  }
  final values = <Nutrient, double>{};
  for (final e in _nutrientIds.entries) {
    for (final id in e.value) {
      final v = amounts[id];
      if (v != null) {
        values[e.key] = v;
        break;
      }
    }
  }
  final portions = [
    for (final p in (json['foodPortions'] as List? ?? const []))
      ?parseUsdaPortion(p as Map<String, dynamic>),
  ];
  return Food(
    source: FoodSource.usda,
    sourceId: '${json['fdcId']}',
    name: json['description'] as String,
    per100g: Nutrients(values),
    portions: portions,
    detail: [json['dataType'], _category(json['foodCategory'])].whereType<String>().join(' · '),
  );
}

FoodPortion? parseUsdaPortion(Map<String, dynamic> json) {
  final grams = (json['gramWeight'] as num?)?.toDouble();
  if (grams == null || grams <= 0) return null;
  final amount = (json['amount'] as num?)?.toDouble() ?? 1;
  if (amount <= 0) return null;
  final unitName = ((json['measureUnit'] as Map<String, dynamic>?)?['name'] as String?)?.trim().toLowerCase();
  final modifier = (json['modifier'] as String?)?.trim() ?? '';
  final description = (json['portionDescription'] as String?)?.trim() ?? '';
  final word = unitName == null || unitName == 'undetermined' || unitName.isEmpty ? _head(modifier) : unitName;
  if (_skippedUnits.contains(word)) return null;
  final text = [
    if (unitName != null && unitName != 'undetermined') unitName,
    if (modifier.isNotEmpty) modifier,
  ].join(' ');
  final label = description.isNotEmpty && description != 'Quantity not specified'
      ? description
      : '${_formatAmount(amount)} ${text.isEmpty ? 'serving' : text}';
  return FoodPortion(label: label, grams: grams, unit: _unitWords[word], amount: amount);
}

String _head(String modifier) {
  final lower = modifier.toLowerCase();
  if (lower.startsWith('fl oz')) return 'fl oz';
  return lower.split(RegExp(r'[\s,(]')).first;
}

String? _category(Object? category) => switch (category) {
      final String s => s,
      {'description': final String s} => s,
      _ => null,
    };

String _formatAmount(double v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';
