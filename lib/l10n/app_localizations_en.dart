// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

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
  String get unitGName => 'gram';

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
  String get unitKgName => 'kilogram';

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
  String get unitMgName => 'milligram';

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
  String get unitOzName => 'ounce';

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
  String get unitLbName => 'pound';

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
  String get unitMlName => 'millilitre';

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
  String get unitLName => 'litre';

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
  String get unitDlName => 'decilitre';

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
  String get unitClName => 'centilitre';

  @override
  String unitTsp(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tsp',
    );
    return '$_temp0';
  }

  @override
  String get unitTspName => 'teaspoon';

  @override
  String unitTbsp(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tbsp',
    );
    return '$_temp0';
  }

  @override
  String get unitTbspName => 'tablespoon';

  @override
  String unitCup(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cup',
    );
    return '$_temp0';
  }

  @override
  String get unitCupName => 'cup (US)';

  @override
  String unitMetricCup(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'cup (metric)',
    );
    return '$_temp0';
  }

  @override
  String get unitMetricCupName => 'cup (metric)';

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
  String get unitFlOzName => 'fluid ounce';

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
  String get unitPintName => 'pint (US)';

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
  String get unitQuartName => 'quart (US)';

  @override
  String unitPiece(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pc',
    );
    return '$_temp0';
  }

  @override
  String get unitPieceName => 'piece';

  @override
  String unitPinch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pinch',
    );
    return '$_temp0';
  }

  @override
  String get unitPinchName => 'pinch';

  @override
  String unitClove(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'clove',
    );
    return '$_temp0';
  }

  @override
  String get unitCloveName => 'clove';

  @override
  String unitSlice(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'slice',
    );
    return '$_temp0';
  }

  @override
  String get unitSliceName => 'slice';

  @override
  String unitCan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'can',
    );
    return '$_temp0';
  }

  @override
  String get unitCanName => 'can';

  @override
  String unitPortion(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'portions',
      one: 'portion',
    );
    return '$_temp0';
  }

  @override
  String get unitPortionName => 'portion';

  @override
  String get languageTitle => 'Language';

  @override
  String get languagePhone => 'Same as the phone';
}
