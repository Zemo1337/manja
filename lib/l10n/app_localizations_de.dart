// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get languageName => 'Deutsch';

  @override
  String unitG(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'g',
    );
    return '$_temp0';
  }

  @override
  String get unitGName => 'Gramm';

  @override
  String unitKg(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kg',
    );
    return '$_temp0';
  }

  @override
  String get unitKgName => 'Kilogramm';

  @override
  String unitMg(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mg',
    );
    return '$_temp0';
  }

  @override
  String get unitMgName => 'Milligramm';

  @override
  String unitOz(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'oz',
    );
    return '$_temp0';
  }

  @override
  String get unitOzName => 'Unze';

  @override
  String unitLb(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lb',
    );
    return '$_temp0';
  }

  @override
  String get unitLbName => 'Pfund (US)';

  @override
  String unitMl(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ml',
    );
    return '$_temp0';
  }

  @override
  String get unitMlName => 'Milliliter';

  @override
  String unitL(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'l',
    );
    return '$_temp0';
  }

  @override
  String get unitLName => 'Liter';

  @override
  String unitDl(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dl',
    );
    return '$_temp0';
  }

  @override
  String get unitDlName => 'Deziliter';

  @override
  String unitCl(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cl',
    );
    return '$_temp0';
  }

  @override
  String get unitClName => 'Zentiliter';

  @override
  String unitTsp(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TL',
    );
    return '$_temp0';
  }

  @override
  String get unitTspName => 'Teelöffel';

  @override
  String unitTbsp(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'EL',
    );
    return '$_temp0';
  }

  @override
  String get unitTbspName => 'Esslöffel';

  @override
  String unitCup(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tassen (US)',
      one: 'Tasse (US)',
    );
    return '$_temp0';
  }

  @override
  String get unitCupName => 'Tasse (US)';

  @override
  String unitMetricCup(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tassen',
      one: 'Tasse',
    );
    return '$_temp0';
  }

  @override
  String get unitMetricCupName => 'Tasse (metrisch)';

  @override
  String unitFlOz(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fl oz',
    );
    return '$_temp0';
  }

  @override
  String get unitFlOzName => 'Flüssigunze';

  @override
  String unitPint(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pt',
    );
    return '$_temp0';
  }

  @override
  String get unitPintName => 'Pint (US)';

  @override
  String unitQuart(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'qt',
    );
    return '$_temp0';
  }

  @override
  String get unitQuartName => 'Quart (US)';

  @override
  String unitPiece(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stk.',
    );
    return '$_temp0';
  }

  @override
  String get unitPieceName => 'Stück';

  @override
  String unitPinch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prisen',
      one: 'Prise',
    );
    return '$_temp0';
  }

  @override
  String get unitPinchName => 'Prise';

  @override
  String unitClove(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zehen',
      one: 'Zehe',
    );
    return '$_temp0';
  }

  @override
  String get unitCloveName => 'Zehe';

  @override
  String unitSlice(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scheiben',
      one: 'Scheibe',
    );
    return '$_temp0';
  }

  @override
  String get unitSliceName => 'Scheibe';

  @override
  String unitCan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dosen',
      one: 'Dose',
    );
    return '$_temp0';
  }

  @override
  String get unitCanName => 'Dose';

  @override
  String unitPortion(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Portionen',
      one: 'Portion',
    );
    return '$_temp0';
  }

  @override
  String get unitPortionName => 'Portion';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get languagePhone => 'Wie am Handy';
}
