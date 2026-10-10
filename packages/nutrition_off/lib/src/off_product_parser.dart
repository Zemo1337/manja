import 'package:nutrition_core/nutrition_core.dart';

final _barcode = RegExp(r'^\d{8,14}$');

String? normalizeBarcode(String input) {
  final digits = input.replaceAll(RegExp(r'[\s-]'), '');
  return _barcode.hasMatch(digits) ? digits : null;
}

String offProductName(Map<String, dynamic> product) {
  for (final key in const ['product_name', 'product_name_en', 'generic_name']) {
    final value = (product[key] as String?)?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return 'Product ${product['code']}';
}

String? offProductDetail(Map<String, dynamic> product) {
  final brands = (product['brands'] as String?)?.split(',').map((b) => b.trim()).where((b) => b.isNotEmpty).toList();
  final parts = [
    if (brands != null && brands.isNotEmpty) brands.first,
    if ((product['quantity'] as String?)?.trim() case final q? when q.isNotEmpty) q,
  ];
  return parts.isEmpty ? null : parts.join(' · ');
}

double? _number(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s.replaceAll(',', '.')),
  _ => null,
};

Food? parseOffProduct(Map<String, dynamic> json) {
  final product = json['product'];
  if (json['status'] != 1 || product is! Map<String, dynamic>) return null;
  final code = (product['code'] ?? json['code'])?.toString();
  if (code == null || code.isEmpty) return null;
  final n = product['nutriments'] as Map<String, dynamic>? ?? const {};
  double? per100(String key) => _number(n['${key}_100g']);
  final kj = per100('energy-kj');
  final kcal = per100('energy-kcal') ?? (kj == null ? null : kj / 4.184);
  final salt = per100('salt');
  final sodium = salt != null ? salt / 2.5 : per100('sodium');
  final nutrients = Nutrients.of(
    energyKcal: kcal,
    protein: per100('proteins'),
    fat: per100('fat'),
    saturatedFat: per100('saturated-fat'),
    carbohydrate: per100('carbohydrates'),
    sugars: per100('sugars'),
    fiber: per100('fiber'),
    sodiumMg: sodium == null ? null : sodium * 1000,
  );
  final serving = _number(product['serving_quantity']);
  final servingUnit = (product['serving_quantity_unit'] as String?)?.toLowerCase();
  final package = _number(product['product_quantity']);
  final packageUnit = (product['product_quantity_unit'] as String?)?.toLowerCase();
  final servingText = (product['serving_size'] as String?)?.trim();
  return Food(
    source: FoodSource.openFoodFacts,
    sourceId: code,
    name: offProductName(product),
    detail: offProductDetail(product),
    per100g: nutrients,
    portions: [
      if (serving != null && serving > 0 && (servingUnit == null || servingUnit == 'g'))
        FoodPortion(
          label: servingText == null || servingText.isEmpty ? 'serving' : 'serving ($servingText)',
          grams: serving,
        ),
      if (package != null && package > 0 && (packageUnit == null || packageUnit == 'g'))
        FoodPortion(label: 'package (${_grams(package)} g)', grams: package),
    ],
  );
}

String _grams(double g) => g == g.roundToDouble() ? g.toInt().toString() : g.toStringAsFixed(1);
