// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

  @override
  String get languageName => 'Bosanski';

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
  String get unitMgName => 'miligram';

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
  String get unitOzName => 'unca';

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
  String get unitLbName => 'funta';

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
  String get unitMlName => 'mililitar';

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
  String get unitLName => 'litar';

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
  String get unitDlName => 'decilitar';

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
  String get unitClName => 'centilitar';

  @override
  String unitTsp(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kašičica',
      few: 'kašičice',
      one: 'kašičica',
    );
    return '$_temp0';
  }

  @override
  String get unitTspName => 'kašičica';

  @override
  String unitTbsp(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kašika',
      few: 'kašike',
      one: 'kašika',
    );
    return '$_temp0';
  }

  @override
  String get unitTbspName => 'kašika';

  @override
  String unitCup(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'šolja (US)',
      few: 'šolje (US)',
      one: 'šolja (US)',
    );
    return '$_temp0';
  }

  @override
  String get unitCupName => 'šolja (US)';

  @override
  String unitMetricCup(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'šolja',
      few: 'šolje',
      one: 'šolja',
    );
    return '$_temp0';
  }

  @override
  String get unitMetricCupName => 'šolja (metrička)';

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
  String get unitFlOzName => 'tečna unca';

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
  String get unitPintName => 'pinta (US)';

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
  String get unitQuartName => 'kvart (US)';

  @override
  String unitPiece(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kom',
    );
    return '$_temp0';
  }

  @override
  String get unitPieceName => 'komad';

  @override
  String unitPinch(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'prstohvata',
      few: 'prstohvata',
      one: 'prstohvat',
    );
    return '$_temp0';
  }

  @override
  String get unitPinchName => 'prstohvat';

  @override
  String unitClove(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'čenova',
      few: 'čena',
      one: 'čen',
    );
    return '$_temp0';
  }

  @override
  String get unitCloveName => 'čen';

  @override
  String unitSlice(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kriški',
      few: 'kriške',
      one: 'kriška',
    );
    return '$_temp0';
  }

  @override
  String get unitSliceName => 'kriška';

  @override
  String unitCan(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'konzervi',
      few: 'konzerve',
      one: 'konzerva',
    );
    return '$_temp0';
  }

  @override
  String get unitCanName => 'konzerva';

  @override
  String unitPortion(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'porcija',
      few: 'porcije',
      one: 'porcija',
    );
    return '$_temp0';
  }

  @override
  String get unitPortionName => 'porcija';

  @override
  String get languageTitle => 'Jezik';

  @override
  String get languagePhone => 'Kao na telefonu';
}
