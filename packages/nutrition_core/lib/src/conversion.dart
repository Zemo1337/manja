import 'food.dart';
import 'units.dart';

double? densityOf(Food food) {
  if (food.densityGPerMl != null) return food.densityGPerMl;
  for (final p in food.portions) {
    final unit = p.unit;
    if (unit != null && unit.kind == UnitKind.volume && p.amount > 0) return p.grams / (p.amount * unit.toBase);
  }
  return null;
}

double? gramsPerCount(Food food, CookingUnit unit) {
  for (final p in food.portions) {
    if (p.unit == unit && p.amount > 0) return p.gramsPerUnit;
  }
  if (unit == CookingUnit.piece) {
    for (final p in food.portions) {
      if (p.unit == null && p.amount > 0) return p.gramsPerUnit;
    }
  }
  return null;
}

double? convertAmount(double amount, CookingUnit from, CookingUnit to, {Food? food}) {
  if (from.kind == to.kind && from.kind != UnitKind.count) return amount * from.toBase / to.toBase;
  if (from == to) return amount;
  if (food == null) return null;
  final grams = gramsFor(food, amount, from);
  if (grams == null) return null;
  final perUnit = gramsFor(food, 1, to);
  return perUnit == null || perUnit == 0 ? null : grams / perUnit;
}

double? gramsFor(Food food, double amount, CookingUnit unit) {
  switch (unit.kind) {
    case UnitKind.mass:
      return amount * unit.toBase;
    case UnitKind.volume:
      final density = densityOf(food);
      return density == null ? null : amount * unit.toBase * density;
    case UnitKind.count:
      final each = gramsPerCount(food, unit);
      return each == null ? null : amount * each;
  }
}
