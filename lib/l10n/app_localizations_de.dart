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

  @override
  String recipeFoodPortion(String grams) {
    return '1 Portion = $grams g';
  }

  @override
  String recipeFoodPortionEstimate(String grams) {
    return '1 Portion ≈ $grams g';
  }

  @override
  String get recipeFoodWeightUnknown => 'Gewicht einer Portion unbekannt';

  @override
  String get recipeEditTitleNew => 'Neues Rezept';

  @override
  String get recipeEditTitleEdit => 'Rezept bearbeiten';

  @override
  String get recipeSave => 'Speichern';

  @override
  String get recipeQty => 'Menge';

  @override
  String get recipeUnit => 'Einheit';

  @override
  String get recipeIngredient => 'Zutat';

  @override
  String recipeSuggestionRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezepte',
      one: '1 Rezept',
    );
    return '$_temp0';
  }

  @override
  String get recipeNewTag => 'Neue Kategorie';

  @override
  String get recipeLinkNutrition => 'Nährwerte verknüpfen';

  @override
  String get recipeLinkedRecipeDeleted => 'Verknüpftes Rezept (gelöscht)';

  @override
  String get recipeLinkedIngredientMissing =>
      'Verknüpfte Zutat (nicht auf diesem Gerät)';

  @override
  String recipePortionWeightUnknown(String name) {
    return 'Das Gewicht einer Portion ist unbekannt. Verknüpfe die Zutaten von „$name“ oder gib das Gewicht des fertigen Gerichts ein.';
  }

  @override
  String recipeNoGramWeight(String unit) {
    return 'Kein Grammgewicht für „$unit“. Nutze g oder ml oder füge der Zutat eine Portion hinzu.';
  }

  @override
  String get recipeChangeLink => 'Ändern';

  @override
  String get recipeUnlink => 'Verknüpfung lösen';

  @override
  String recipePhotoLoadError(String error) {
    return 'Das Foto konnte nicht geladen werden: $error';
  }

  @override
  String get recipeCamera => 'Kamera';

  @override
  String get recipeGallery => 'Galerie';

  @override
  String get recipeChoosePhoto => 'Foto auswählen';

  @override
  String get recipeRemove => 'Entfernen';

  @override
  String get recipeRequired => 'Pflichtfeld';

  @override
  String get recipeWholeMinutes => 'Ganze Minuten';

  @override
  String get recipeName => 'Name';

  @override
  String get recipePortions => 'Portionen';

  @override
  String get recipeAtLeastOne => 'Mindestens 1';

  @override
  String get recipePrepMinutes => 'Vorb. (min)';

  @override
  String get recipeCookMinutes => 'Kochzeit (min)';

  @override
  String get recipeTags => 'Kategorien';

  @override
  String get recipeIngredients => 'Zutaten';

  @override
  String get recipeAddIngredient => 'Zutat hinzufügen';

  @override
  String get recipeAddHeading => 'Überschrift hinzufügen';

  @override
  String get recipeFinishedWeight => 'Gewicht des fertigen Gerichts (optional)';

  @override
  String get recipeFinishedWeightHelp =>
      'Kochen verändert das Gewicht. Wiege das Gericht für genaue Werte pro 100 g.';

  @override
  String get recipeFinishedWeightInvalid => 'Gramm, z. B. 850';

  @override
  String get recipeCookingInfo => 'Kochhinweise';

  @override
  String get recipeCookingInfoHint => 'Ofentemperatur, Formgröße, Tipps…';

  @override
  String get recipePreparationSteps => 'Zubereitungsschritte';

  @override
  String get recipeAddStep => 'Schritt hinzufügen';

  @override
  String get recipeDragToReorder => 'Zum Verschieben ziehen';

  @override
  String get recipeHeading => 'Überschrift';

  @override
  String get recipeHeadingHint => 'Teig, Belag, Soße…';

  @override
  String get recipeDeleteTitle => 'Rezept löschen?';

  @override
  String recipeDeleteMessage(String name) {
    return '„$name“ und der zugehörige Verlauf werden gelöscht.';
  }

  @override
  String get recipeCancel => 'Abbrechen';

  @override
  String get recipeDelete => 'Löschen';

  @override
  String get recipeEdit => 'Bearbeiten';

  @override
  String get recipeNotFound => 'Rezept nicht gefunden';

  @override
  String recipePrepChip(int minutes) {
    return 'Vorbereitung $minutes min';
  }

  @override
  String recipeCookChip(int minutes) {
    return 'Kochzeit $minutes min';
  }

  @override
  String get recipeNoIngredients => 'Keine Zutaten eingetragen.';

  @override
  String get recipeNutrition => 'Nährwerte';

  @override
  String recipeSource(String host) {
    return 'Quelle: $host';
  }

  @override
  String get recipePreparation => 'Zubereitung';

  @override
  String get recipeNoSteps => 'Keine Schritte eingetragen.';

  @override
  String get recipeListTitle => 'Rezepte';

  @override
  String get recipeImportFromLink => 'Über Link importieren';

  @override
  String get recipeCookbookPdf => 'Kochbuch-PDF';

  @override
  String get recipeUnitConverter => 'Einheitenrechner';

  @override
  String get recipeAdd => 'Rezept hinzufügen';

  @override
  String get recipeListEmpty =>
      'Noch keine Rezepte. Tippe auf „Rezept hinzufügen“, um loszulegen.';

  @override
  String get recipeSearch => 'Rezepte suchen';

  @override
  String recipePortionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Portionen',
      one: '1 Portion',
    );
    return '$_temp0';
  }

  @override
  String recipeTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeImportTitle => 'Rezept importieren';

  @override
  String get recipeImportUrlLabel => 'Link zum Rezept';

  @override
  String get recipePaste => 'Einfügen';

  @override
  String get recipeImport => 'Importieren';

  @override
  String get recipeImportInvalidUrl =>
      'Gib einen Link zu einer Rezeptseite ein, zum Beispiel https://www.coolinarika.com/recept/…';

  @override
  String get recipeImportBotCheckTimeout =>
      'Die Seite hat den Browser immer wieder geprüft. Versuch es später erneut oder übertrag das Rezept von Hand.';

  @override
  String get recipeImportNoRecipe =>
      'Auf dieser Seite wurden keine Rezeptdaten gefunden. Die Seite stellt ihre Rezepte vielleicht nicht in einem lesbaren Format bereit.';

  @override
  String recipeImportReading(String host) {
    return 'Rezept wird von $host gelesen…';
  }

  @override
  String get recipeImportReadingPage => 'Rezept wird von der Seite gelesen…';

  @override
  String get recipeImportChallenge =>
      'Die Seite will prüfen, ob du ein Mensch bist. Schließ die Prüfung unten ab.';

  @override
  String get recipeImportPhoto => 'Foto wird heruntergeladen…';

  @override
  String get recipeImportHint =>
      'Funktioniert mit den meisten Rezeptseiten. Vor dem Speichern kannst du alles prüfen und ändern.';

  @override
  String get recipeImportTimeout => 'Die Seite hat nicht rechtzeitig geladen.';

  @override
  String get recipeImportUnreachable =>
      'Die Seite ist nicht erreichbar. Prüfe deine Internetverbindung.';

  @override
  String get recipeImportBlocked =>
      'Diese Seite blockiert automatische Downloads. Importiere das Rezept auf deinem Handy, dort öffnet sich die Seite in einer Browseransicht.';

  @override
  String recipeImportHttpError(int status) {
    return 'Die Seite antwortete mit HTTP $status.';
  }

  @override
  String get navWheel => 'Rad';

  @override
  String get navRecipes => 'Rezepte';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String wheelEnjoy(String recipe) {
    return '$recipe – guten Appetit!';
  }

  @override
  String get wheelResetTitle => 'Rad zurücksetzen?';

  @override
  String get wheelResetMessage =>
      'Alle Rezepte kommen zurück aufs Rad. Dein Verlauf bleibt erhalten.';

  @override
  String get wheelCancel => 'Abbrechen';

  @override
  String get wheelReset => 'Zurücksetzen';

  @override
  String get wheelResetWheel => 'Rad zurücksetzen';

  @override
  String get wheelLook => 'Aussehen des Rads';

  @override
  String get wheelShowAll => 'Alle Gerichte zeigen';

  @override
  String get wheelNoFilterMatch => 'Keine Gerichte passen zu deinen Filtern';

  @override
  String wheelHiddenByFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gerichte sind durch die Filter ausgeblendet.',
      one: '1 Gericht ist durch die Filter ausgeblendet.',
    );
    return '$_temp0';
  }

  @override
  String get wheelClearFilters => 'Filter zurücksetzen';

  @override
  String wheelNothingTagged(String tag) {
    return 'Nichts in der Kategorie $tag';
  }

  @override
  String get wheelNothingTaggedMessage =>
      'Füge die Kategorie im Rezepteditor zu Rezepten hinzu oder wähle eine andere.';

  @override
  String get wheelNoRecipes => 'Noch keine Rezepte';

  @override
  String get wheelNoRecipesMessage =>
      'Füge deine Lieblingsgerichte unter „Rezepte“ hinzu, dann erscheinen sie hier.';

  @override
  String get wheelAllEaten => 'Du hast alles gegessen!';

  @override
  String wheelAllTagEaten(String tag) {
    return 'Alle Gerichte aus $tag gegessen';
  }

  @override
  String get wheelAllEatenMessage =>
      'Jedes Gericht auf dem Rad wurde in dieser Runde gekocht.';

  @override
  String wheelAllTagEatenMessage(String tag) {
    return 'Jedes Gericht der Kategorie $tag wurde in dieser Runde gekocht.';
  }

  @override
  String wheelCanMakeNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gerichte kannst du jetzt kochen',
      one: '1 Gericht kannst du jetzt kochen',
    );
    return '$_temp0';
  }

  @override
  String wheelDishesLeft(int left, int total) {
    return '$left von $total Gerichten übrig';
  }

  @override
  String wheelFilterUpToKcal(int kcal) {
    return 'Bis $kcal kcal';
  }

  @override
  String wheelFilterUpToMinutes(int minutes) {
    return 'bis $minutes Min.';
  }

  @override
  String wheelFilterHidden(int count) {
    return '$count ausgeblendet';
  }

  @override
  String get wheelSpin => 'Drehen';

  @override
  String get wheelSpinning => 'Dreht…';

  @override
  String get wheelTodayYouCook => 'Heute kochst du';

  @override
  String get wheelSpinAgain => 'Nochmal drehen';

  @override
  String get wheelLetsCook => 'Wird gekocht';

  @override
  String get wheelFilters => 'Filter';

  @override
  String get wheelAllTags => 'Alle';

  @override
  String wheelFilterKcalOn(int kcal) {
    return 'Bis $kcal kcal pro Portion';
  }

  @override
  String get wheelFilterKcalOff => 'Kalorien pro Portion';

  @override
  String get wheelFilterKcalHelp => 'Aus den verknüpften Zutaten';

  @override
  String wheelMinutesValue(int minutes) {
    return '$minutes Min.';
  }

  @override
  String wheelFilterMinutesOn(int minutes) {
    return 'Fertig in bis zu $minutes Min.';
  }

  @override
  String get wheelFilterMinutesOff => 'Gesamtzeit';

  @override
  String get wheelFilterMinutesHelp => 'Vorbereitung und Kochzeit zusammen';

  @override
  String get wheelFilterUnknown =>
      'Gerichte mit unbekannten Werten einbeziehen';

  @override
  String get wheelFilterUnknownHelp =>
      'Rezepte ohne verknüpfte Zutaten oder Zeiten bleiben auf dem Rad';

  @override
  String get wheelResetModeWhenEmpty => 'Wenn jedes Gericht gegessen wurde';

  @override
  String get wheelResetModeAfterDays => 'Nach einer Anzahl von Tagen';

  @override
  String get wheelResetModeManual => 'Nur manuell';

  @override
  String get wheelContentText => 'Text';

  @override
  String get wheelContentPhoto => 'Foto';

  @override
  String get wheelContentBoth => 'Beides';

  @override
  String get wheelThemeClassic => 'Klassisch';

  @override
  String get wheelThemePizza => 'Pizza';

  @override
  String get wheelThemeBurek => 'Burek';

  @override
  String get wheelThemeSacher => 'Sachertorte';

  @override
  String get wheelThemeBaklava => 'Baklava';

  @override
  String get themeManja => 'Manja';

  @override
  String get themeManjaDescription => 'Paprika, Basilikum und Safran';

  @override
  String get themeNeutral => 'Neutral';

  @override
  String get themeNeutralDescription => 'Ruhiges Schiefergrau';

  @override
  String get themeDev => 'Dev';

  @override
  String get themeDevDescription => 'Anthrazit und Gelb, immer dunkel';

  @override
  String get themeBrightnessSystem => 'System';

  @override
  String get themeBrightnessLight => 'Hell';

  @override
  String get themeBrightnessDark => 'Dunkel';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historyRangeHelp => 'Mahlzeiten im Zeitraum';

  @override
  String get historyRangeSave => 'Zeigen';

  @override
  String historyRemoved(String recipe) {
    return '$recipe aus dem Verlauf entfernt';
  }

  @override
  String get historyUndo => 'Rückgängig';

  @override
  String get historyEmpty => 'Noch nichts gekocht. Dreh am Rad!';

  @override
  String historyMonthHeader(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mahlzeiten',
      one: '1 Mahlzeit',
    );
    return '$month · $_temp0';
  }

  @override
  String get historySearchHint => 'Gerichte suchen';

  @override
  String get historyClearSearch => 'Suche löschen';

  @override
  String get historyPickDates => 'Zeitraum wählen';

  @override
  String get historyNoMatch => 'Keine passenden Mahlzeiten';

  @override
  String historyMatchSummary(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mahlzeiten, zuletzt am $date',
      one: '1 Mahlzeit am $date',
    );
    return '$_temp0';
  }

  @override
  String get pantryTitle => 'Was kann ich kochen?';

  @override
  String pantrySpinWith(int count) {
    return 'Mit diesen $count drehen';
  }

  @override
  String get pantrySwitchToWheel =>
      'Wechsle zu „Auf dem Rad“, um mit diesen zu drehen';

  @override
  String get pantryAlwaysAtHome => 'Immer zu Hause';

  @override
  String get pantryAddBasicHint => 'Grundzutat hinzufügen, z. B. Olivenöl';

  @override
  String get pantryAlwaysEmpty =>
      'Füge hinzu, was du immer da hast, z. B. Salz, Öl oder Mehl.';

  @override
  String get pantryStaples =>
      'Salz,Pfeffer,Öl,Mehl,Zucker,Eier,Milch,Butter,Zwiebel,Knoblauch,Reis';

  @override
  String get pantryInTheMood => 'Lust auf';

  @override
  String get pantryAddCravingHint => 'Zutat hinzufügen, z. B. Hähnchen';

  @override
  String get pantryCravingEmpty =>
      'Optional. Wähle, worauf du heute Lust hast, um nur Gerichte damit zu sehen.';

  @override
  String get pantryOnWheel => 'Auf dem Rad';

  @override
  String get pantryAllRecipes => 'Alle Rezepte';

  @override
  String pantryCanMake(int count) {
    return 'Kannst du kochen ($count)';
  }

  @override
  String get pantryEmptyHint =>
      'Füge hinzu, was du zu Hause hast, um zu sehen, was du kochen kannst.';

  @override
  String get pantryNothingYet => 'Noch nichts mit diesen Zutaten.';

  @override
  String pantryMissingFew(int count) {
    return 'Es fehlt nur wenig ($count)';
  }

  @override
  String get pantryAdd => 'Hinzufügen';

  @override
  String pantryHaveAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Du hast alle $count Zutaten',
      one: 'Du hast die Zutat',
    );
    return '$_temp0';
  }

  @override
  String pantryMissing(String items) {
    return 'Fehlt: $items';
  }

  @override
  String get nutrientEnergy => 'Brennwert';

  @override
  String get nutrientProtein => 'Eiweiß';

  @override
  String get nutrientFat => 'Fett';

  @override
  String get nutrientSaturatedFat => 'Gesättigte Fettsäuren';

  @override
  String get nutrientCarbohydrate => 'Kohlenhydrate';

  @override
  String get nutrientSugars => 'Zucker';

  @override
  String get nutrientFiber => 'Ballaststoffe';

  @override
  String get nutrientSodium => 'Natrium';

  @override
  String get nutrientCholesterol => 'Cholesterin';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Eisen';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Kalium';

  @override
  String get nutrientZinc => 'Zink';

  @override
  String get nutrientVitaminA => 'Vitamin A';

  @override
  String get nutrientVitaminC => 'Vitamin C';

  @override
  String get nutrientVitaminD => 'Vitamin D';

  @override
  String get nutrientVitaminE => 'Vitamin E';

  @override
  String get nutrientVitaminB12 => 'Vitamin B12';

  @override
  String get nutrientFolate => 'Folsäure';

  @override
  String get foodSourceUser => 'Meine Zutaten';

  @override
  String get foodSourceRecipe => 'Meine Rezepte';

  @override
  String get nutritionCancel => 'Abbrechen';

  @override
  String get nutritionSave => 'Speichern';

  @override
  String get nutritionDelete => 'Löschen';

  @override
  String get nutritionEdit => 'Bearbeiten';

  @override
  String get nutritionRetry => 'Erneut versuchen';

  @override
  String get nutritionNoLinks =>
      'Verknüpfe im Rezepteditor Zutaten mit Lebensmitteln, um die Nährwerte zu sehen.';

  @override
  String get nutritionBasisPortion => 'Portion';

  @override
  String get nutritionBasisCustom => 'Eigene';

  @override
  String get nutritionAmount => 'Menge';

  @override
  String nutritionDishWeighed(String weight) {
    return 'Gericht $weight (gewogen)';
  }

  @override
  String nutritionDishSum(String weight) {
    return 'Gericht $weight (Summe der Zutaten)';
  }

  @override
  String nutritionPortionsOfAbout(int count, String weight) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Portionen zu je etwa $weight',
      one: '1 Portion zu etwa $weight',
    );
    return '$_temp0';
  }

  @override
  String get nutritionLowerBound =>
      '* Für einige verknüpfte Lebensmittel fehlt dieser Wert, er ist also eine Untergrenze.';

  @override
  String get nutritionSalt => 'Salz';

  @override
  String get nutritionVitaminsMinerals => 'Vitamine und Mineralstoffe';

  @override
  String get nutritionDailyReferenceHint =>
      '% der EU-Referenzmenge für Erwachsene';

  @override
  String get nutritionNotCounted => 'Nicht berücksichtigt';

  @override
  String nutritionMissingNoFood(String name) {
    return '$name: kein Lebensmittel verknüpft';
  }

  @override
  String nutritionMissingNoWeight(String name, String unit) {
    return '$name: kein Gewicht in Gramm für „$unit“';
  }

  @override
  String get nutritionOffUnreachable =>
      'Open Food Facts ist nicht erreichbar. Prüfe deine Internetverbindung.';

  @override
  String get nutritionUsdaUnreachable =>
      'USDA ist nicht erreichbar. Prüfe deine Internetverbindung.';

  @override
  String get nutritionIngredientsTitle => 'Zutaten';

  @override
  String get nutritionMyIngredientButton => 'Eigene Zutat';

  @override
  String get nutritionBuiltIn => 'Integrierte Zutaten';

  @override
  String nutritionBuiltInCount(int count) {
    return 'Integrierte Zutaten: $count';
  }

  @override
  String get nutritionBuiltInSubtitle =>
      'USDA FoodData Central, funktioniert offline';

  @override
  String get nutritionUsdaOnline => 'USDA-Onlinesuche';

  @override
  String get apiKeyOriginDemo =>
      'Geteilter Demo-Schlüssel, ein paar Abfragen pro Stunde. Füge deinen eigenen kostenlosen Schlüssel hinzu für mehr.';

  @override
  String get apiKeyOriginDeveloper =>
      'Entwicklerschlüssel aus config/local.json';

  @override
  String get apiKeyOriginUser => 'Dein eigener API-Schlüssel';

  @override
  String get apiKeyChange => 'Ändern';

  @override
  String get apiKeyAdd => 'Schlüssel hinzufügen';

  @override
  String get nutritionMyIngredients => 'Meine Zutaten';

  @override
  String get nutritionMyIngredientsEmpty =>
      'Füge Zutaten hinzu, die du nicht findest, z. B. von einer Verpackung.';

  @override
  String get nutritionOnlineInRecipes => 'Online-Zutaten in deinen Rezepten';

  @override
  String foodAskingLatest(String source) {
    return 'Frage $source nach aktuellen Werten…';
  }

  @override
  String get foodUsedInRecipes => 'in Rezepten verwendet';

  @override
  String foodDeleteTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get foodDeleteUsed =>
      'Einige Rezepte verwenden diese Zutat. Dort steht dann „kein Lebensmittel verknüpft“, bis du eine andere verknüpfst.';

  @override
  String get foodDeleteUnused => 'Die Zutat wird von diesem Gerät entfernt.';

  @override
  String foodGone(String source) {
    return '$source hat dieses Lebensmittel nicht mehr';
  }

  @override
  String foodUpdated(String name) {
    return '„$name“ aktualisiert';
  }

  @override
  String get nutritionPer100g => 'Pro 100 g';

  @override
  String get nutritionPortions => 'Portionen';

  @override
  String get foodCopyToMine => 'In meine Zutaten kopieren';

  @override
  String get foodUpdating => 'Wird aktualisiert…';

  @override
  String foodUpdateFrom(String source) {
    return 'Von $source aktualisieren';
  }

  @override
  String get foodNewTitle => 'Neue Zutat';

  @override
  String get foodEditTitle => 'Zutat bearbeiten';

  @override
  String get foodName => 'Name';

  @override
  String get foodRequiredError => 'Pflichtfeld';

  @override
  String get foodNumberError => 'Zahl';

  @override
  String get foodNutritionPer100g => 'Nährwerte pro 100 g';

  @override
  String get foodNutritionHint =>
      'Übernimm die Werte von der Verpackung. Lass unbekannte Werte leer.';

  @override
  String get foodOfWhichSaturates => 'davon gesättigte Fettsäuren';

  @override
  String get foodOfWhichSugars => 'davon Zucker';

  @override
  String get foodMoreNutrients => 'Weitere Nährstoffe';

  @override
  String get foodMoreNutrientsHint => 'Vitamine, Mineralstoffe und Cholesterin';

  @override
  String get foodPortionsHint =>
      'Wie viel eine Einheit wiegt, damit Rezepte Tassen, Löffel oder Stück verwenden können.';

  @override
  String get foodQty => 'Menge';

  @override
  String get foodUnit => 'Einheit';

  @override
  String get foodWeight => 'Gewicht';

  @override
  String get foodRemovePortion => 'Entfernen';

  @override
  String get foodAddPortion => 'Portion hinzufügen';

  @override
  String apiKeyOpenInBrowser(String url) {
    return 'Öffne $url in deinem Browser';
  }

  @override
  String get apiKeyRateLimited =>
      'Du hast das stündliche USDA-Limit für deinen Schlüssel erreicht. Versuch es später noch einmal.';

  @override
  String get apiKeyRejected =>
      'USDA hat den API-Schlüssel nicht akzeptiert. Prüfe ihn unter Zutaten > USDA-Onlinesuche.';

  @override
  String get apiKeyDemoLimitTitle => 'Keine freien Abfragen mehr';

  @override
  String get apiKeyDemoLimitIntro =>
      'Hey du, wie es aussieht, hast du alle eingebauten USDA-Abfragen aufgebraucht.';

  @override
  String get apiKeyDemoLimitSignupBefore =>
      'Wenn du mehr brauchst, kannst du dir unter ';

  @override
  String get apiKeyDemoLimitSignupAfter =>
      ' einen eigenen kostenlosen API-Schlüssel holen. Nach der Registrierung bekommst du ihn per E-Mail.';

  @override
  String get apiKeyDemoLimitEnterKey =>
      'Diesen Schlüssel kannst du dann in der App eingeben, um mehr Abfragen zu bekommen.';

  @override
  String get apiKeyDemoLimitWarning =>
      'Und denk dran: Teile deinen Schlüssel nicht öffentlich.';

  @override
  String get apiKeyNotNow => 'Nicht jetzt';

  @override
  String get apiKeyGetKey => 'Schlüssel holen';

  @override
  String get apiKeyEnterMine => 'Meinen Schlüssel eingeben';

  @override
  String get apiKeySaved => 'Dein API-Schlüssel ist gespeichert';

  @override
  String get apiKeyRemoved => 'Dein API-Schlüssel wurde entfernt';

  @override
  String get apiKeyDialogTitle => 'Dein USDA-API-Schlüssel';

  @override
  String get apiKeyLabel => 'API-Schlüssel';

  @override
  String get apiKeyStoredLocally =>
      'Der Schlüssel wird nur auf diesem Gerät gespeichert. Teile ihn nicht öffentlich.';

  @override
  String get apiKeyGetFreeKey => 'Kostenlosen Schlüssel holen';

  @override
  String get apiKeyRemove => 'Schlüssel entfernen';

  @override
  String get pickerRecipeDetail => 'Rezept';

  @override
  String get pickerNoLongerAvailable => 'Diese Zutat ist nicht mehr verfügbar';

  @override
  String get pickerProductNotFound => 'Produkt nicht gefunden';

  @override
  String pickerProductNotFoundBody(String code) {
    return 'Open Food Facts kennt den Barcode $code noch nicht. Du kannst die Werte stattdessen von der Verpackung eingeben.';
  }

  @override
  String get pickerCreateOwnButton => 'Selbst anlegen';

  @override
  String get pickerSearchHint => 'Zutaten suchen, z. B. „Mehl Weizen“';

  @override
  String get pickerCreateOwn => 'Eigene Zutat anlegen';

  @override
  String get pickerCreateOwnSubtitle => 'Werte von einer Verpackung eingeben';

  @override
  String get pickerScanBarcode => 'Barcode einer Verpackung scannen';

  @override
  String get pickerEnterBarcode => 'Barcode einer Verpackung eingeben';

  @override
  String get pickerBarcodeSubtitle => 'Sucht das Produkt in Open Food Facts';

  @override
  String pickerBarcodeCode(String code) {
    return 'Barcode $code';
  }

  @override
  String get pickerNothingLocal => 'Nichts auf diesem Gerät gefunden';

  @override
  String get pickerSearchOnline => 'Online suchen';

  @override
  String pickerSearchOnlineFor(String query) {
    return 'Online nach „$query“ suchen';
  }

  @override
  String get pickerUsdaIngredients => 'USDA-Zutaten';

  @override
  String get pickerStoreProducts => 'Produkte aus dem Handel';

  @override
  String get pickerAskingUsda =>
      'Frage USDA, das kann ein paar Sekunden dauern…';

  @override
  String get pickerAskingOff => 'Frage Open Food Facts…';

  @override
  String get pickerNoMoreOnline => 'Keine weiteren Online-Ergebnisse';

  @override
  String pickerUses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count Rezepten',
      one: 'In 1 Rezept',
    );
    return '$_temp0';
  }

  @override
  String get pickerOffAttribution =>
      'Produktdaten von Open Food Facts, erstellt von den Mitwirkenden unter der Open Database License (ODbL).';

  @override
  String get scannerTitle => 'Barcode scannen';

  @override
  String get scannerTorch => 'Taschenlampe';

  @override
  String get scannerHint => 'Richte die Kamera auf den Barcode der Verpackung';

  @override
  String get scannerTypeNumber => 'Nummer eintippen';

  @override
  String get scannerPermissionDenied =>
      'Manja darf die Kamera nicht verwenden. Erlaube es in den Handy-Einstellungen oder tippe die Nummer ein.';

  @override
  String get scannerCameraFailed => 'Die Kamera konnte nicht gestartet werden.';

  @override
  String get scannerInvalidBarcode => 'Ein Barcode hat 8 bis 14 Ziffern';

  @override
  String get scannerDialogTitle => 'Barcode der Verpackung';

  @override
  String get scannerLookUp => 'Suchen';

  @override
  String get converterTitle => 'Einheitenrechner';

  @override
  String get converterSwap => 'Einheiten tauschen';

  @override
  String get converterIngredient => 'Zutat';

  @override
  String get converterIngredientHint =>
      'Tassen, Löffel und Milliliter wiegen bei jeder Zutat anders.';

  @override
  String get converterOther => 'Andere…';

  @override
  String get converterPickIngredient =>
      'Wähle eine Zutat, um zwischen Volumen und Gewicht umzurechnen.';

  @override
  String converterNoWeight(String unit, String food) {
    return 'Für $food ist kein Gewicht pro „$unit“ bekannt.';
  }

  @override
  String get converterNoVolumeWeights =>
      'Für diese Zutat sind keine Volumengewichte bekannt.';

  @override
  String get converterCommonEquivalents => 'Gängige Umrechnungen';

  @override
  String converterTeaspoons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teelöffel',
      one: '1 Teelöffel',
    );
    return '$_temp0';
  }

  @override
  String converterTablespoons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Esslöffel',
      one: '1 Esslöffel',
    );
    return '$_temp0';
  }

  @override
  String get converterFlour => 'Mehl';

  @override
  String get converterSugar => 'Zucker';

  @override
  String get converterPowderedSugar => 'Puderzucker';

  @override
  String get converterButter => 'Butter';

  @override
  String get converterWater => 'Wasser';

  @override
  String get converterMilk => 'Milch';

  @override
  String get converterOliveOil => 'Olivenöl';

  @override
  String get converterRice => 'Reis';

  @override
  String get converterHoney => 'Honig';

  @override
  String get converterSalt => 'Salz';

  @override
  String get converterOats => 'Haferflocken';

  @override
  String get converterCocoa => 'Kakao';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionWheel => 'Rad';

  @override
  String get settingsSectionKitchen => 'Küche';

  @override
  String get settingsSectionIngredients => 'Zutaten';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsAppearanceSubtitle => 'Design, heller und dunkler Modus';

  @override
  String get settingsBackupSubtitle =>
      'Dein ganzes Profil exportieren oder importieren';

  @override
  String get settingsWheelLookSubtitle => 'Design, Fotos, Größe, Namen';

  @override
  String get settingsRoundsSubtitle => 'Wann gegessene Gerichte zurückkommen';

  @override
  String get settingsTagsSubtitle => 'Gänge und eigene Gruppen von Gerichten';

  @override
  String get settingsConverterTitle => 'Einheitenrechner';

  @override
  String get settingsConverterSubtitle =>
      'Tassen, Löffel, Gramm und Milliliter';

  @override
  String get settingsIngredientsTitle => 'Zutaten & USDA-Schlüssel';

  @override
  String get settingsIngredientsSubtitle =>
      'Eigene Zutaten, eingebaute Daten, Online-Suche';

  @override
  String get settingsAboutTitle => 'Über Manja';

  @override
  String get settingsAboutSubtitle => 'Lizenz, Quellcode und Danksagungen';

  @override
  String get appearanceTitle => 'Darstellung';

  @override
  String get appearanceAppTheme => 'App-Design';

  @override
  String get appearanceMode => 'Modus';

  @override
  String get appearanceDevAlwaysDark => 'Das Dev-Design ist immer dunkel.';

  @override
  String get appearanceSystemHint =>
      'System folgt der Hell-/Dunkel-Einstellung deines Geräts.';

  @override
  String get backupTitle => 'Sichern & Umziehen';

  @override
  String get backupPickTitle => 'Manja-Profil öffnen';

  @override
  String get backupSaveTitle => 'Profil speichern';

  @override
  String get backupShareSubject => 'Manja-Profil';

  @override
  String get backupSaved => 'Profil gespeichert';

  @override
  String backupError(String error) {
    return 'Etwas ist schiefgelaufen: $error';
  }

  @override
  String get backupNotAProfile => 'Das ist kein Manja-Profil.';

  @override
  String get backupNewerVersion =>
      'Dieses Profil stammt aus einer neueren App-Version. Bitte aktualisiere zuerst.';

  @override
  String backupRecipesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezepte hinzugefügt',
      one: '1 Rezept hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String backupAddedSkipped(String added, int skipped) {
    return '$added, $skipped schon vorhanden';
  }

  @override
  String get backupReplaceTitle => 'Alles ersetzen?';

  @override
  String get backupReplaceText =>
      'Alle Rezepte, Fotos, der Verlauf, eigene Zutaten, Vorrat und Einstellungen auf diesem Gerät werden durch das Profil ersetzt. Dein USDA-Schlüssel bleibt.';

  @override
  String get backupReplaceEverything => 'Alles ersetzen';

  @override
  String get backupCancel => 'Abbrechen';

  @override
  String get backupExport => 'Export';

  @override
  String backupExportText(String extension) {
    return 'Packt deine Rezepte, Fotos, eigenen Zutaten, Vorrat, Verlauf und Einstellungen in eine $extension-Datei. Nutze sie als Sicherung oder für den Umzug auf ein anderes Gerät. Dein USDA-Schlüssel ist nie enthalten.';
  }

  @override
  String get backupSaveToFile => 'In Datei speichern';

  @override
  String get backupShare => 'Teilen';

  @override
  String get backupImport => 'Import';

  @override
  String backupImportText(String extension) {
    return 'Öffne eine $extension-Datei. Du kannst ihre Rezepte zu deinen hinzufügen oder alles ersetzen.';
  }

  @override
  String get backupOpenProfile => 'Profil öffnen';

  @override
  String get backupImportTitle => 'Profil importieren';

  @override
  String backupSavedOn(String date) {
    return 'Gespeichert am $date';
  }

  @override
  String backupRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezepte',
      one: '1 Rezept',
    );
    return '$_temp0';
  }

  @override
  String backupPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos',
      one: '1 Foto',
    );
    return '$_temp0';
  }

  @override
  String backupMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mahlzeiten',
      one: '1 Mahlzeit',
    );
    return '$_temp0';
  }

  @override
  String backupOwnIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eigene Zutaten',
      one: '1 eigene Zutat',
    );
    return '$_temp0';
  }

  @override
  String backupPantryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Vorratsartikel',
      one: '1 Vorratsartikel',
    );
    return '$_temp0';
  }

  @override
  String get backupSkipHint =>
      'Beim Hinzufügen werden Rezepte übersprungen, deren Namen du schon hast.';

  @override
  String get backupReplace => 'Ersetzen';

  @override
  String get backupAdd => 'Hinzufügen';

  @override
  String get wheelLookTitle => 'Aussehen des Rads';

  @override
  String get wheelLookTheme => 'Design';

  @override
  String get wheelLookShow => 'Auf dem Rad zeigen';

  @override
  String get wheelLookSize => 'Größe';

  @override
  String wheelLookMaxSlices(int count) {
    return 'Rezepte auf dem Rad: $count';
  }

  @override
  String get wheelLookMaxSlicesHint =>
      'Bei mehr Rezepten steht ein „+n“-Feld für den Rest. Jedes Rezept hat trotzdem die gleiche Chance.';

  @override
  String wheelLookWinnerPercent(int percent) {
    return 'Gewinnergericht nimmt $percent % des Rads ein';
  }

  @override
  String wheelLookPercent(int percent) {
    return '$percent %';
  }

  @override
  String get wheelLookSpin => 'Drehen';

  @override
  String wheelLookSpinTime(String seconds) {
    return 'Drehzeit: $seconds s';
  }

  @override
  String get wheelLookSpinTimeHint =>
      'Wie lange sich das Rad dreht, bevor es stoppt';

  @override
  String wheelLookReveal(String seconds) {
    return 'Gewinner-Anzeige: $seconds s';
  }

  @override
  String get wheelLookRevealHint =>
      'Wie lange das gewählte Gericht braucht, um auf dem Rad zu wachsen';

  @override
  String wheelLookSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get wheelLookNames => 'Namen';

  @override
  String get wheelLookUpright => 'Namen aufrecht halten';

  @override
  String get wheelLookUprightHint =>
      'Namen auf der linken Hälfte drehen, damit sie nie kopfstehen';

  @override
  String get roundsTitle => 'Runden';

  @override
  String get roundsPutBack => 'Gegessene Gerichte zurück aufs Rad';

  @override
  String get roundsResetEvery => 'Neue Runde alle';

  @override
  String get roundsFewerDays => 'Weniger Tage';

  @override
  String get roundsMoreDays => 'Mehr Tage';

  @override
  String roundsDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String get roundsHistoryKept =>
      'Dein Verlauf bleibt immer erhalten. Eine neue Runde legt nur die Gerichte zurück aufs Rad.';

  @override
  String get tagsTitle => 'Kategorien';

  @override
  String get tagsNew => 'Neue Kategorie';

  @override
  String get tagsRenameTitle => 'Kategorie umbenennen';

  @override
  String get tagsRename => 'Umbenennen';

  @override
  String get tagsAdd => 'Hinzufügen';

  @override
  String get tagsCancel => 'Abbrechen';

  @override
  String get tagsDelete => 'Löschen';

  @override
  String tagsDeleteTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get tagsDeleteUnused => 'Kein Rezept nutzt diese Kategorie.';

  @override
  String tagsDeleteUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Sie wird aus $count Rezepten entfernt. Die Rezepte selbst bleiben.',
      one: 'Sie wird aus 1 Rezept entfernt. Die Rezepte selbst bleiben.',
    );
    return '$_temp0';
  }

  @override
  String get tagsIntro =>
      'Kategorien gruppieren deine Rezepte. Wähle eine über dem Rad, um nur diese zu drehen. Ziehen ändert die Reihenfolge.';

  @override
  String tagsRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezepte',
      one: '1 Rezept',
    );
    return '$_temp0';
  }

  @override
  String get tagsIngredientHint =>
      'als Zutat nutzbar, nur auf dem Rad, wenn ausgewählt';

  @override
  String get tagsNameHint => 'Schnell unter der Woche';

  @override
  String get cookbookTitle => 'Kochbuch-PDF';

  @override
  String get cookbookDefaultTitle => 'Manja-Kochbuch';

  @override
  String get cookbookFallbackTitle => 'Kochbuch';

  @override
  String get cookbookNoneSelected => 'Keine Rezepte ausgewählt';

  @override
  String cookbookCreate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PDF mit $count Rezepten erstellen',
      one: 'PDF mit 1 Rezept erstellen',
    );
    return '$_temp0';
  }

  @override
  String get cookbookTitleField => 'Titel';

  @override
  String get cookbookLayout => 'Layout';

  @override
  String get cookbookRecipes => 'Rezepte';

  @override
  String cookbookAll(int count) {
    return 'Alle Rezepte ($count)';
  }

  @override
  String cookbookFavorites(int count) {
    return 'Favoriten ($count)';
  }

  @override
  String get cookbookTagged => 'Mit Kategorie';

  @override
  String cookbookChosen(int count) {
    return 'Ausgewählt ($count)';
  }

  @override
  String get cookbookChoose => 'Auswählen';

  @override
  String get cookbookInclude => 'Enthalten';

  @override
  String get cookbookCover => 'Titelseite';

  @override
  String get cookbookContents => 'Inhaltsverzeichnis';

  @override
  String get cookbookPhotos => 'Fotos';

  @override
  String get cookbookNutrition => 'Nährwerte pro Portion';

  @override
  String get cookbookNutritionHint => 'Nur für Rezepte mit verknüpften Zutaten';

  @override
  String cookbookChosenCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get cookbookSelectNone => 'Keine';

  @override
  String get cookbookSelectAll => 'Alle';

  @override
  String get cookbookDone => 'Fertig';

  @override
  String get cookbookPreview => 'Vorschau';

  @override
  String get cookbookLayingOut => 'Dein Kochbuch wird gesetzt…';

  @override
  String get cookbookLayoutClassic => 'Klassisch';

  @override
  String get cookbookLayoutClassicHint =>
      'A4, ein Rezept pro Seite mit großem Foto';

  @override
  String get cookbookLayoutCompact => 'Kompakt';

  @override
  String get cookbookLayoutCompactHint =>
      'A4, Rezepte hintereinander, spart Papier';

  @override
  String get cookbookLayoutCards => 'Rezeptkarten';

  @override
  String get cookbookLayoutCardsHint =>
      'A6-Karten, je ein Rezept, leicht auszuschneiden';

  @override
  String get pdfNoRecipes => 'Noch keine Rezepte';

  @override
  String pdfRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rezepte',
      one: '1 Rezept',
    );
    return '$_temp0';
  }

  @override
  String get pdfMonths =>
      'Januar,Februar,März,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember';

  @override
  String get pdfMadeWith => 'Erstellt mit Manja';

  @override
  String get pdfContents => 'Inhalt';

  @override
  String get pdfPerPortion => 'Pro Portion';

  @override
  String get pdfPerPortionAtLeast => 'Pro Portion, mindestens';

  @override
  String get pdfIngredients => 'Zutaten';

  @override
  String get pdfPreparation => 'Zubereitung';

  @override
  String get pdfNotes => 'Notizen';

  @override
  String pdfSource(String host) {
    return 'Quelle: $host';
  }

  @override
  String pdfPage(String page) {
    return 'S. $page';
  }

  @override
  String pdfPortions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Portionen',
      one: '1 Portion',
    );
    return '$_temp0';
  }

  @override
  String pdfPrep(String time) {
    return 'Vorbereitung $time';
  }

  @override
  String pdfCook(String time) {
    return 'Kochzeit $time';
  }

  @override
  String pdfMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String pdfHours(int hours) {
    return '$hours Std.';
  }

  @override
  String pdfHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String get pdfProtein => 'Eiweiß';

  @override
  String get pdfFat => 'Fett';

  @override
  String get pdfCarbohydrate => 'Kohlenhydrate';

  @override
  String get pdfFiber => 'Ballaststoffe';

  @override
  String get aboutLicense =>
      'Freie Software unter der GNU Affero General Public License v3.0.';

  @override
  String aboutSource(String url) {
    return 'Quellcode: $url';
  }

  @override
  String get aboutTrademark =>
      'Der Name „Manja“ und das Logo fallen nicht unter die Lizenz.';

  @override
  String get tagNameMain => 'Hauptgericht';

  @override
  String get tagNameSoup => 'Suppe';

  @override
  String get tagNameSide => 'Beilage & Salat';

  @override
  String get tagNameBreakfast => 'Frühstück';

  @override
  String get tagNameDessert => 'Dessert';

  @override
  String get tagNameSnack => 'Snack';

  @override
  String get tagNameIngredient => 'Zutat';
}
