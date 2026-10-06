import 'nutrients.dart';
import 'units.dart';

enum FoodSource {
  usda('usda', 'USDA FoodData Central'),
  openFoodFacts('off', 'Open Food Facts'),
  user('user', 'My ingredients');

  const FoodSource(this.id, this.label);

  final String id;
  final String label;

  static FoodSource fromId(String id) => FoodSource.values.firstWhere((s) => s.id == id);
}

class FoodPortion {
  const FoodPortion({required this.label, required this.grams, this.unit, this.amount = 1});

  factory FoodPortion.fromJson(Map<String, dynamic> json) => FoodPortion(
        label: json['label'] as String,
        grams: (json['grams'] as num).toDouble(),
        unit: CookingUnit.tryFromName(json['unit'] as String?),
        amount: (json['amount'] as num?)?.toDouble() ?? 1,
      );

  final String label;
  final double grams;
  final CookingUnit? unit;
  final double amount;

  double get gramsPerUnit => grams / amount;

  Map<String, dynamic> toJson() => {
        'label': label,
        'grams': grams,
        if (unit != null) 'unit': unit!.name,
        if (amount != 1) 'amount': amount,
      };
}

class FoodSummary {
  const FoodSummary({required this.source, required this.sourceId, required this.name, this.detail});

  final FoodSource source;
  final String sourceId;
  final String name;
  final String? detail;

  String get key => '${source.id}:$sourceId';
}

class Food {
  const Food({
    required this.source,
    required this.sourceId,
    required this.name,
    required this.per100g,
    this.portions = const [],
    this.densityGPerMl,
    this.detail,
  });

  final FoodSource source;
  final String sourceId;
  final String name;
  final Nutrients per100g;
  final List<FoodPortion> portions;
  final double? densityGPerMl;
  final String? detail;

  String get key => '${source.id}:$sourceId';

  FoodSummary get summary => FoodSummary(source: source, sourceId: sourceId, name: name, detail: detail);
}
