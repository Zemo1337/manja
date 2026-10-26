import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_core/nutrition_core.dart' show CookingUnit;

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  /// The app's texts; English where no translations are set up, as in widget tests with a bare MaterialApp.
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ?? lookupAppLocalizations(const Locale('en'));
}

/// The texts of the app's current language, for code that has no BuildContext.
AppLocalizations appLocalizationsNow() {
  final code = Intl.defaultLocale?.split(RegExp('[-_]')).first;
  final supported = AppLocalizations.supportedLocales.any((l) => l.languageCode == code);
  return lookupAppLocalizations(Locale(supported ? code! : 'en'));
}

extension CookingUnitL10n on CookingUnit {
  /// The short unit written after [amount], e.g. "2 tbsp" or "2 EL".
  String symbolIn(AppLocalizations l, [num amount = 1]) => switch (this) {
    CookingUnit.g => l.unitG(amount),
    CookingUnit.kg => l.unitKg(amount),
    CookingUnit.mg => l.unitMg(amount),
    CookingUnit.oz => l.unitOz(amount),
    CookingUnit.lb => l.unitLb(amount),
    CookingUnit.ml => l.unitMl(amount),
    CookingUnit.l => l.unitL(amount),
    CookingUnit.dl => l.unitDl(amount),
    CookingUnit.cl => l.unitCl(amount),
    CookingUnit.tsp => l.unitTsp(amount),
    CookingUnit.tbsp => l.unitTbsp(amount),
    CookingUnit.cup => l.unitCup(amount),
    CookingUnit.metricCup => l.unitMetricCup(amount),
    CookingUnit.flOz => l.unitFlOz(amount),
    CookingUnit.pint => l.unitPint(amount),
    CookingUnit.quart => l.unitQuart(amount),
    CookingUnit.piece => l.unitPiece(amount),
    CookingUnit.pinch => l.unitPinch(amount),
    CookingUnit.clove => l.unitClove(amount),
    CookingUnit.slice => l.unitSlice(amount),
    CookingUnit.can => l.unitCan(amount),
    CookingUnit.portion => l.unitPortion(amount),
  };

  /// The full name, e.g. "tablespoon", for unit pickers.
  String labelIn(AppLocalizations l) => switch (this) {
    CookingUnit.g => l.unitGName,
    CookingUnit.kg => l.unitKgName,
    CookingUnit.mg => l.unitMgName,
    CookingUnit.oz => l.unitOzName,
    CookingUnit.lb => l.unitLbName,
    CookingUnit.ml => l.unitMlName,
    CookingUnit.l => l.unitLName,
    CookingUnit.dl => l.unitDlName,
    CookingUnit.cl => l.unitClName,
    CookingUnit.tsp => l.unitTspName,
    CookingUnit.tbsp => l.unitTbspName,
    CookingUnit.cup => l.unitCupName,
    CookingUnit.metricCup => l.unitMetricCupName,
    CookingUnit.flOz => l.unitFlOzName,
    CookingUnit.pint => l.unitPintName,
    CookingUnit.quart => l.unitQuartName,
    CookingUnit.piece => l.unitPieceName,
    CookingUnit.pinch => l.unitPinchName,
    CookingUnit.clove => l.unitCloveName,
    CookingUnit.slice => l.unitSliceName,
    CookingUnit.can => l.unitCanName,
    CookingUnit.portion => l.unitPortionName,
  };
}
