import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bs'),
    Locale('de'),
    Locale('en'),
  ];

  /// The name of this language, written in this language; shown in the language picker.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// Short unit after an amount, e.g. "2 g".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{g}}'**
  String unitG(num count);

  /// No description provided for @unitGName.
  ///
  /// In en, this message translates to:
  /// **'gram'**
  String get unitGName;

  /// Short unit after an amount, e.g. "2 kg".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{kg}}'**
  String unitKg(num count);

  /// No description provided for @unitKgName.
  ///
  /// In en, this message translates to:
  /// **'kilogram'**
  String get unitKgName;

  /// Short unit after an amount, e.g. "2 mg".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{mg}}'**
  String unitMg(num count);

  /// No description provided for @unitMgName.
  ///
  /// In en, this message translates to:
  /// **'milligram'**
  String get unitMgName;

  /// Short unit after an amount, e.g. "2 oz".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{oz}}'**
  String unitOz(num count);

  /// No description provided for @unitOzName.
  ///
  /// In en, this message translates to:
  /// **'ounce'**
  String get unitOzName;

  /// Short unit after an amount, e.g. "2 lb".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{lb}}'**
  String unitLb(num count);

  /// No description provided for @unitLbName.
  ///
  /// In en, this message translates to:
  /// **'pound'**
  String get unitLbName;

  /// Short unit after an amount, e.g. "2 ml".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{ml}}'**
  String unitMl(num count);

  /// No description provided for @unitMlName.
  ///
  /// In en, this message translates to:
  /// **'millilitre'**
  String get unitMlName;

  /// Short unit after an amount, e.g. "2 l".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{l}}'**
  String unitL(num count);

  /// No description provided for @unitLName.
  ///
  /// In en, this message translates to:
  /// **'litre'**
  String get unitLName;

  /// Short unit after an amount, e.g. "2 dl".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{dl}}'**
  String unitDl(num count);

  /// No description provided for @unitDlName.
  ///
  /// In en, this message translates to:
  /// **'decilitre'**
  String get unitDlName;

  /// Short unit after an amount, e.g. "2 cl".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{cl}}'**
  String unitCl(num count);

  /// No description provided for @unitClName.
  ///
  /// In en, this message translates to:
  /// **'centilitre'**
  String get unitClName;

  /// Short unit after an amount, e.g. "2 tsp".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{tsp}}'**
  String unitTsp(num count);

  /// No description provided for @unitTspName.
  ///
  /// In en, this message translates to:
  /// **'teaspoon'**
  String get unitTspName;

  /// Short unit after an amount, e.g. "2 tbsp".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{tbsp}}'**
  String unitTbsp(num count);

  /// No description provided for @unitTbspName.
  ///
  /// In en, this message translates to:
  /// **'tablespoon'**
  String get unitTbspName;

  /// Short unit after an amount, e.g. "2 cup".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{cup}}'**
  String unitCup(num count);

  /// No description provided for @unitCupName.
  ///
  /// In en, this message translates to:
  /// **'cup (US)'**
  String get unitCupName;

  /// Short unit after an amount, e.g. "2 cup (metric)".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{cup (metric)}}'**
  String unitMetricCup(num count);

  /// No description provided for @unitMetricCupName.
  ///
  /// In en, this message translates to:
  /// **'cup (metric)'**
  String get unitMetricCupName;

  /// Short unit after an amount, e.g. "2 fl oz".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{fl oz}}'**
  String unitFlOz(num count);

  /// No description provided for @unitFlOzName.
  ///
  /// In en, this message translates to:
  /// **'fluid ounce'**
  String get unitFlOzName;

  /// Short unit after an amount, e.g. "2 pt".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{pt}}'**
  String unitPint(num count);

  /// No description provided for @unitPintName.
  ///
  /// In en, this message translates to:
  /// **'pint (US)'**
  String get unitPintName;

  /// Short unit after an amount, e.g. "2 qt".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{qt}}'**
  String unitQuart(num count);

  /// No description provided for @unitQuartName.
  ///
  /// In en, this message translates to:
  /// **'quart (US)'**
  String get unitQuartName;

  /// Short unit after an amount, e.g. "2 pc".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{pc}}'**
  String unitPiece(num count);

  /// No description provided for @unitPieceName.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get unitPieceName;

  /// Short unit after an amount, e.g. "2 pinch".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{pinch}}'**
  String unitPinch(num count);

  /// No description provided for @unitPinchName.
  ///
  /// In en, this message translates to:
  /// **'pinch'**
  String get unitPinchName;

  /// Short unit after an amount, e.g. "2 clove".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{clove}}'**
  String unitClove(num count);

  /// No description provided for @unitCloveName.
  ///
  /// In en, this message translates to:
  /// **'clove'**
  String get unitCloveName;

  /// Short unit after an amount, e.g. "2 slice".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{slice}}'**
  String unitSlice(num count);

  /// No description provided for @unitSliceName.
  ///
  /// In en, this message translates to:
  /// **'slice'**
  String get unitSliceName;

  /// Short unit after an amount, e.g. "2 can".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{can}}'**
  String unitCan(num count);

  /// No description provided for @unitCanName.
  ///
  /// In en, this message translates to:
  /// **'can'**
  String get unitCanName;

  /// Short unit after an amount, e.g. "2 portions".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{portion} other{portions}}'**
  String unitPortion(num count);

  /// No description provided for @unitPortionName.
  ///
  /// In en, this message translates to:
  /// **'portion'**
  String get unitPortionName;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languagePhone.
  ///
  /// In en, this message translates to:
  /// **'Same as the phone'**
  String get languagePhone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bs', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bs':
      return AppLocalizationsBs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
