enum Nutrient {
  energy('Energy', 'kcal'),
  protein('Protein', 'g'),
  fat('Fat', 'g'),
  saturatedFat('Saturated fat', 'g'),
  carbohydrate('Carbohydrate', 'g'),
  sugars('Sugars', 'g'),
  fiber('Fiber', 'g'),
  sodium('Sodium', 'mg'),
  cholesterol('Cholesterol', 'mg', detailed: true),
  calcium('Calcium', 'mg', detailed: true, dailyReference: 800),
  iron('Iron', 'mg', detailed: true, dailyReference: 14),
  magnesium('Magnesium', 'mg', detailed: true, dailyReference: 375),
  potassium('Potassium', 'mg', detailed: true, dailyReference: 2000),
  zinc('Zinc', 'mg', detailed: true, dailyReference: 10),
  vitaminA('Vitamin A', 'µg', detailed: true, dailyReference: 800),
  vitaminC('Vitamin C', 'mg', detailed: true, dailyReference: 80),
  vitaminD('Vitamin D', 'µg', detailed: true, dailyReference: 5),
  vitaminE('Vitamin E', 'mg', detailed: true, dailyReference: 12),
  vitaminB12('Vitamin B12', 'µg', detailed: true, dailyReference: 2.5),
  folate('Folate', 'µg', detailed: true, dailyReference: 200);

  const Nutrient(this.label, this.unit, {this.detailed = false, this.dailyReference});

  final String label;
  final String unit;
  final bool detailed;

  /// EU nutrient reference value for adults (Regulation (EU) No 1169/2011, Annex XIII).
  final double? dailyReference;

  static final basic = [for (final n in values) if (!n.detailed) n];
  static final vitaminsAndMinerals = [for (final n in values) if (n.detailed) n];
}

class Nutrients {
  const Nutrients(this.values);

  factory Nutrients.of({
    double? energyKcal,
    double? protein,
    double? fat,
    double? saturatedFat,
    double? carbohydrate,
    double? sugars,
    double? fiber,
    double? sodiumMg,
  }) =>
      Nutrients({
        Nutrient.energy: ?energyKcal,
        Nutrient.protein: ?protein,
        Nutrient.fat: ?fat,
        Nutrient.saturatedFat: ?saturatedFat,
        Nutrient.carbohydrate: ?carbohydrate,
        Nutrient.sugars: ?sugars,
        Nutrient.fiber: ?fiber,
        Nutrient.sodium: ?sodiumMg,
      });

  factory Nutrients.fromJson(Map<String, dynamic> json) => Nutrients({
        for (final n in Nutrient.values)
          if (json[n.name] is num) n: (json[n.name] as num).toDouble(),
      });

  static const empty = Nutrients({});

  final Map<Nutrient, double> values;

  double? operator [](Nutrient n) => values[n];

  bool has(Nutrient n) => values.containsKey(n);

  double? get saltG {
    final sodium = values[Nutrient.sodium];
    return sodium == null ? null : sodium * 2.5 / 1000;
  }

  Nutrients scaled(double factor) => Nutrients({for (final e in values.entries) e.key: e.value * factor});

  Nutrients operator +(Nutrients other) => Nutrients({
        for (final n in Nutrient.values)
          if (has(n) || other.has(n)) n: (values[n] ?? 0) + (other.values[n] ?? 0),
      });

  Map<String, double> toJson() => {for (final e in values.entries) e.key.name: e.value};

  @override
  bool operator ==(Object other) =>
      other is Nutrients &&
      other.values.length == values.length &&
      values.entries.every((e) => other.values[e.key] == e.value);

  @override
  int get hashCode => Object.hashAllUnordered(values.entries.map((e) => Object.hash(e.key, e.value)));

  @override
  String toString() => 'Nutrients(${toJson()})';
}
