enum UnitKind { mass, volume, count }

enum CookingUnit {
  g('g', 'gram', UnitKind.mass, 1),
  kg('kg', 'kilogram', UnitKind.mass, 1000),
  mg('mg', 'milligram', UnitKind.mass, 0.001),
  oz('oz', 'ounce', UnitKind.mass, 28.349523125),
  lb('lb', 'pound', UnitKind.mass, 453.59237),
  ml('ml', 'millilitre', UnitKind.volume, 1),
  l('l', 'litre', UnitKind.volume, 1000),
  tsp('tsp', 'teaspoon', UnitKind.volume, 4.92892159375),
  tbsp('tbsp', 'tablespoon', UnitKind.volume, 14.78676478125),
  cup('cup', 'cup (US)', UnitKind.volume, 236.5882365),
  metricCup('cup (metric)', 'cup (metric)', UnitKind.volume, 250),
  flOz('fl oz', 'fluid ounce', UnitKind.volume, 29.5735295625),
  pint('pt', 'pint (US)', UnitKind.volume, 473.176473),
  quart('qt', 'quart (US)', UnitKind.volume, 946.352946),
  piece('pc', 'piece', UnitKind.count, 1),
  pinch('pinch', 'pinch', UnitKind.count, 1),
  clove('clove', 'clove', UnitKind.count, 1),
  slice('slice', 'slice', UnitKind.count, 1),
  can('can', 'can', UnitKind.count, 1);

  const CookingUnit(this.symbol, this.label, this.kind, this.toBase);

  final String symbol;
  final String label;
  final UnitKind kind;
  final double toBase;

  static CookingUnit fromName(String name) =>
      CookingUnit.values.firstWhere((u) => u.name == name, orElse: () => CookingUnit.g);

  double? toGrams(double amount, {double? densityGPerMl, double? gramsPerPiece}) {
    switch (kind) {
      case UnitKind.mass:
        return amount * toBase;
      case UnitKind.volume:
        return densityGPerMl == null ? null : amount * toBase * densityGPerMl;
      case UnitKind.count:
        return gramsPerPiece == null ? null : amount * gramsPerPiece;
    }
  }
}

String formatAmount(double amount) {
  if (amount == amount.roundToDouble()) return amount.toInt().toString();
  return amount.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}
