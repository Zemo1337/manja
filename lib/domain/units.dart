import 'package:intl/intl.dart';

export 'package:nutrition_core/nutrition_core.dart' show CookingUnit, UnitKind;

/// The decimal separator of the app's language: "." in English, "," in German and Bosnian.
String get decimalSeparator {
  try {
    return NumberFormat.decimalPattern().symbols.DECIMAL_SEP;
  } on Object {
    return '.';
  }
}

String formatAmount(double amount) {
  if (amount == amount.roundToDouble()) return amount.toInt().toString();
  final text = amount.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  return text.replaceFirst('.', decimalSeparator);
}
