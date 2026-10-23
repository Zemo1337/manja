import 'package:nutrition_core/nutrition_core.dart' show CookingUnit;

export 'package:nutrition_core/nutrition_core.dart' show CookingUnit, UnitKind;

String formatAmount(double amount) {
  if (amount == amount.roundToDouble()) return amount.toInt().toString();
  return amount.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// The unit as written after [amount], e.g. "2 portions".
String unitText(CookingUnit unit, double amount) =>
    unit == CookingUnit.portion && amount != 1 ? 'portions' : unit.symbol;
