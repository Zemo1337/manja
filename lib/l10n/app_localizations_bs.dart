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

  @override
  String recipeFoodPortion(String grams) {
    return '1 porcija = $grams g';
  }

  @override
  String recipeFoodPortionEstimate(String grams) {
    return '1 porcija ≈ $grams g';
  }

  @override
  String get recipeFoodWeightUnknown => 'Težina porcije nepoznata';

  @override
  String get recipeEditTitleNew => 'Novi recept';

  @override
  String get recipeEditTitleEdit => 'Uredi recept';

  @override
  String get recipeSave => 'Sačuvaj';

  @override
  String get recipeQty => 'Kol.';

  @override
  String get recipeUnit => 'Jedinica';

  @override
  String get recipeIngredient => 'Sastojak';

  @override
  String recipeSuggestionRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata',
      few: '$count recepta',
      one: '$count recept',
    );
    return '$_temp0';
  }

  @override
  String get recipeNewTag => 'Nova kategorija';

  @override
  String get recipeLinkNutrition => 'Poveži nutritivne vrijednosti';

  @override
  String get recipeLinkedRecipeDeleted => 'Povezani recept (obrisan)';

  @override
  String get recipeLinkedIngredientMissing =>
      'Povezani sastojak (nije na ovom uređaju)';

  @override
  String recipePortionWeightUnknown(String name) {
    return 'Težina porcije nije poznata. Poveži sastojke recepta „$name“ ili unesi težinu gotovog jela.';
  }

  @override
  String recipeNoGramWeight(String unit) {
    return 'Nema težine u gramima za „$unit“. Koristi g ili ml ili dodaj porciju sastojku.';
  }

  @override
  String get recipeChangeLink => 'Promijeni';

  @override
  String get recipeUnlink => 'Ukloni vezu';

  @override
  String recipePhotoLoadError(String error) {
    return 'Fotografija se nije mogla učitati: $error';
  }

  @override
  String get recipeCamera => 'Kamera';

  @override
  String get recipeGallery => 'Galerija';

  @override
  String get recipeChoosePhoto => 'Odaberi fotografiju';

  @override
  String get recipeRemove => 'Ukloni';

  @override
  String get recipeRequired => 'Obavezno';

  @override
  String get recipeWholeMinutes => 'Cijele minute';

  @override
  String get recipeName => 'Naziv';

  @override
  String get recipePortions => 'Porcije';

  @override
  String get recipeAtLeastOne => 'Najmanje 1';

  @override
  String get recipePrepMinutes => 'Priprema (min)';

  @override
  String get recipeCookMinutes => 'Kuhanje (min)';

  @override
  String get recipeTags => 'Kategorije';

  @override
  String get recipeIngredients => 'Sastojci';

  @override
  String get recipeAddIngredient => 'Dodaj sastojak';

  @override
  String get recipeAddHeading => 'Dodaj naslov';

  @override
  String get recipeFinishedWeight => 'Težina gotovog jela (neobavezno)';

  @override
  String get recipeFinishedWeightHelp =>
      'Kuhanje mijenja težinu. Izvaži jelo za tačne vrijednosti na 100 g.';

  @override
  String get recipeFinishedWeightInvalid => 'Grami, npr. 850';

  @override
  String get recipeCookingInfo => 'Upute za kuhanje';

  @override
  String get recipeCookingInfoHint =>
      'Temperatura rerne, veličina posude, savjeti…';

  @override
  String get recipePreparationSteps => 'Koraci pripreme';

  @override
  String get recipeAddStep => 'Dodaj korak';

  @override
  String get recipeDragToReorder => 'Povuci za premještanje';

  @override
  String get recipeHeading => 'Naslov';

  @override
  String get recipeHeadingHint => 'Tijesto, preljev, sos…';

  @override
  String get recipeDeleteTitle => 'Obrisati recept?';

  @override
  String recipeDeleteMessage(String name) {
    return '„$name“ i historija obroka bit će obrisani.';
  }

  @override
  String get recipeCancel => 'Otkaži';

  @override
  String get recipeDelete => 'Obriši';

  @override
  String get recipeEdit => 'Uredi';

  @override
  String get recipeNotFound => 'Recept nije pronađen';

  @override
  String recipePrepChip(int minutes) {
    return 'Priprema $minutes min';
  }

  @override
  String recipeCookChip(int minutes) {
    return 'Kuhanje $minutes min';
  }

  @override
  String get recipeNoIngredients => 'Nema dodanih sastojaka.';

  @override
  String get recipeNutrition => 'Nutritivne vrijednosti';

  @override
  String recipeSource(String host) {
    return 'Izvor: $host';
  }

  @override
  String get recipePreparation => 'Priprema';

  @override
  String get recipeNoSteps => 'Nema dodanih koraka.';

  @override
  String get recipeListTitle => 'Recepti';

  @override
  String get recipeImportFromLink => 'Uvezi preko linka';

  @override
  String get recipeCookbookPdf => 'Kuharica (PDF)';

  @override
  String get recipeUnitConverter => 'Pretvarač jedinica';

  @override
  String get recipeAdd => 'Dodaj recept';

  @override
  String get recipeListEmpty =>
      'Još nema recepata. Dodirni „Dodaj recept“ za početak.';

  @override
  String get recipeSearch => 'Pretraži recepte';

  @override
  String recipePortionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porcija',
      few: '$count porcije',
      one: '$count porcija',
    );
    return '$_temp0';
  }

  @override
  String recipeTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeImportTitle => 'Uvezi recept';

  @override
  String get recipeImportUrlLabel => 'Link na recept';

  @override
  String get recipePaste => 'Zalijepi';

  @override
  String get recipeImport => 'Uvezi';

  @override
  String get recipeImportInvalidUrl =>
      'Unesi link na stranicu s receptom, na primjer https://www.coolinarika.com/recept/…';

  @override
  String get recipeImportBotCheckTimeout =>
      'Stranica stalno provjerava preglednik. Pokušaj kasnije ili prepiši recept ručno.';

  @override
  String get recipeImportNoRecipe =>
      'Na ovoj stranici nema podataka o receptu. Stranica možda ne objavljuje recepte u čitljivom formatu.';

  @override
  String recipeImportReading(String host) {
    return 'Čitam recept sa $host…';
  }

  @override
  String get recipeImportReadingPage => 'Čitam recept sa stranice…';

  @override
  String get recipeImportChallenge =>
      'Stranica želi provjeriti da li si čovjek. Završi provjeru ispod.';

  @override
  String get recipeImportPhoto => 'Preuzimam fotografiju…';

  @override
  String get recipeImportHint =>
      'Radi s većinom stranica s receptima. Prije čuvanja možeš sve provjeriti i promijeniti.';

  @override
  String get recipeImportTimeout => 'Stranica se nije učitala na vrijeme.';

  @override
  String get recipeImportUnreachable =>
      'Stranica nije dostupna. Provjeri internetsku vezu.';

  @override
  String get recipeImportBlocked =>
      'Ova stranica blokira automatsko preuzimanje. Uvezi recept na telefonu, gdje se stranica otvara u pregledniku.';

  @override
  String recipeImportHttpError(int status) {
    return 'Stranica je odgovorila s HTTP $status.';
  }

  @override
  String get navWheel => 'Kolo';

  @override
  String get navRecipes => 'Recepti';

  @override
  String get navHistory => 'Historija';

  @override
  String get navSettings => 'Postavke';

  @override
  String wheelEnjoy(String recipe) {
    return '$recipe – prijatno!';
  }

  @override
  String get wheelResetTitle => 'Resetovati kolo?';

  @override
  String get wheelResetMessage =>
      'Svi recepti se vraćaju na kolo. Historija obroka ostaje sačuvana.';

  @override
  String get wheelCancel => 'Otkaži';

  @override
  String get wheelReset => 'Resetuj';

  @override
  String get wheelResetWheel => 'Resetuj kolo';

  @override
  String get wheelLook => 'Izgled kola';

  @override
  String get wheelShowAll => 'Prikaži sva jela';

  @override
  String get wheelNoFilterMatch => 'Nijedno jelo ne odgovara filterima';

  @override
  String wheelHiddenByFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jela je sakriveno filterima.',
      few: '$count jela su sakrivena filterima.',
      one: '$count jelo je sakriveno filterima.',
    );
    return '$_temp0';
  }

  @override
  String get wheelClearFilters => 'Poništi filtere';

  @override
  String wheelNothingTagged(String tag) {
    return 'Ništa u kategoriji $tag';
  }

  @override
  String get wheelNothingTaggedMessage =>
      'Dodaj kategoriju receptima u uređivaču recepata ili izaberi drugu.';

  @override
  String get wheelNoRecipes => 'Još nema recepata';

  @override
  String get wheelNoRecipesMessage =>
      'Dodaj omiljena jela u kartici Recepti i pojavit će se ovdje.';

  @override
  String get wheelAllEaten => 'Sve je pojedeno!';

  @override
  String wheelAllTagEaten(String tag) {
    return 'Sva jela iz kategorije $tag su pojedena';
  }

  @override
  String get wheelAllEatenMessage =>
      'Svako jelo na kolu je skuhano u ovom krugu.';

  @override
  String wheelAllTagEatenMessage(String tag) {
    return 'Svako jelo iz kategorije $tag je skuhano u ovom krugu.';
  }

  @override
  String wheelCanMakeNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jela možeš sad skuhati',
      few: '$count jela možeš sad skuhati',
      one: '$count jelo možeš sad skuhati',
    );
    return '$_temp0';
  }

  @override
  String wheelDishesLeft(int left, int total) {
    return 'Ostalo $left od $total jela';
  }

  @override
  String wheelFilterUpToKcal(int kcal) {
    return 'Do $kcal kcal';
  }

  @override
  String wheelFilterUpToMinutes(int minutes) {
    return 'do $minutes min';
  }

  @override
  String wheelFilterHidden(int count) {
    return 'skriveno: $count';
  }

  @override
  String get wheelSpin => 'Zavrti';

  @override
  String get wheelSpinning => 'Vrti se…';

  @override
  String get wheelTodayYouCook => 'Danas kuhaš';

  @override
  String get wheelSpinAgain => 'Zavrti ponovo';

  @override
  String get wheelLetsCook => 'Idemo kuhati';

  @override
  String get wheelFilters => 'Filteri';

  @override
  String get wheelAllTags => 'Sve';

  @override
  String wheelFilterKcalOn(int kcal) {
    return 'Do $kcal kcal po porciji';
  }

  @override
  String get wheelFilterKcalOff => 'Kalorije po porciji';

  @override
  String get wheelFilterKcalHelp => 'Iz povezanih sastojaka';

  @override
  String wheelMinutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String wheelFilterMinutesOn(int minutes) {
    return 'Gotovo za najviše $minutes min';
  }

  @override
  String get wheelFilterMinutesOff => 'Ukupno vrijeme';

  @override
  String get wheelFilterMinutesHelp => 'Priprema i kuhanje zajedno';

  @override
  String get wheelFilterUnknown => 'Uključi jela s nepoznatim vrijednostima';

  @override
  String get wheelFilterUnknownHelp =>
      'Recepti bez povezanih sastojaka ili vremena ostaju na kolu';

  @override
  String get wheelResetModeWhenEmpty => 'Kad se pojedu sva jela';

  @override
  String get wheelResetModeAfterDays => 'Nakon određenog broja dana';

  @override
  String get wheelResetModeManual => 'Samo ručno';

  @override
  String get wheelContentText => 'Tekst';

  @override
  String get wheelContentPhoto => 'Slika';

  @override
  String get wheelContentBoth => 'Oboje';

  @override
  String get wheelThemeClassic => 'Klasično';

  @override
  String get wheelThemePizza => 'Pizza';

  @override
  String get wheelThemeBurek => 'Burek';

  @override
  String get wheelThemeSacher => 'Sacher torta';

  @override
  String get wheelThemeBaklava => 'Baklava';

  @override
  String get themeManja => 'Manja';

  @override
  String get themeManjaDescription => 'Paprika, bosiljak i šafran';

  @override
  String get themeNeutral => 'Neutralna';

  @override
  String get themeNeutralDescription => 'Mirne sive nijanse';

  @override
  String get themeDev => 'Dev';

  @override
  String get themeDevDescription => 'Antracit i žuta, uvijek tamna';

  @override
  String get themeBrightnessSystem => 'Sistem';

  @override
  String get themeBrightnessLight => 'Svijetla';

  @override
  String get themeBrightnessDark => 'Tamna';

  @override
  String get historyTitle => 'Historija';

  @override
  String get historyRangeHelp => 'Obroci u periodu';

  @override
  String get historyRangeSave => 'Prikaži';

  @override
  String historyRemoved(String recipe) {
    return 'Uklonjeno iz historije: $recipe';
  }

  @override
  String get historyUndo => 'Poništi';

  @override
  String get historyEmpty => 'Još ništa nije skuhano. Zavrti kolo!';

  @override
  String historyMonthHeader(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obroka',
      few: '$count obroka',
      one: '$count obrok',
    );
    return '$month · $_temp0';
  }

  @override
  String get historySearchHint => 'Pretraži jela';

  @override
  String get historyClearSearch => 'Obriši pretragu';

  @override
  String get historyPickDates => 'Izaberi datume';

  @override
  String get historyNoMatch => 'Nema odgovarajućih obroka';

  @override
  String historyMatchSummary(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obroka, zadnji $date',
      few: '$count obroka, zadnji $date',
      one: '$count obrok, $date',
    );
    return '$_temp0';
  }

  @override
  String get pantryTitle => 'Šta mogu skuhati?';

  @override
  String pantrySpinWith(int count) {
    return 'Zavrti sa ovih $count';
  }

  @override
  String get pantrySwitchToWheel => 'Prebaci na „Na kolu“ da zavrtiš s ovima';

  @override
  String get pantryAlwaysAtHome => 'Uvijek kod kuće';

  @override
  String get pantryAddBasicHint =>
      'Dodaj osnovni sastojak, npr. maslinovo ulje';

  @override
  String get pantryAlwaysEmpty =>
      'Dodaj ono što uvijek imaš, npr. so, ulje ili brašno.';

  @override
  String get pantryStaples =>
      'So,Biber,Ulje,Brašno,Šećer,Jaja,Mlijeko,Puter,Luk,Bijeli luk,Riža';

  @override
  String get pantryInTheMood => 'Danas mi se jede';

  @override
  String get pantryAddCravingHint => 'Dodaj sastojak, npr. piletina';

  @override
  String get pantryCravingEmpty =>
      'Opcionalno. Izaberi šta ti se danas jede da vidiš samo jela s tim.';

  @override
  String get pantryOnWheel => 'Na kolu';

  @override
  String get pantryAllRecipes => 'Svi recepti';

  @override
  String pantryCanMake(int count) {
    return 'Možeš skuhati ($count)';
  }

  @override
  String get pantryEmptyHint =>
      'Dodaj šta imaš kod kuće da vidiš koja jela možeš skuhati.';

  @override
  String get pantryNothingYet => 'Još ništa s ovim sastojcima.';

  @override
  String pantryMissingFew(int count) {
    return 'Fali sastojak ili dva ($count)';
  }

  @override
  String get pantryAdd => 'Dodaj';

  @override
  String pantryHaveAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imaš svih $count sastojaka',
      few: 'Imaš sva $count sastojka',
      one: 'Imaš $count sastojak',
    );
    return '$_temp0';
  }

  @override
  String pantryMissing(String items) {
    return 'Fali: $items';
  }

  @override
  String get nutrientEnergy => 'Energetska vrijednost';

  @override
  String get nutrientProtein => 'Bjelančevine';

  @override
  String get nutrientFat => 'Masti';

  @override
  String get nutrientSaturatedFat => 'Zasićene masne kiseline';

  @override
  String get nutrientCarbohydrate => 'Ugljikohidrati';

  @override
  String get nutrientSugars => 'Šećeri';

  @override
  String get nutrientFiber => 'Vlakna';

  @override
  String get nutrientSodium => 'Natrij';

  @override
  String get nutrientCholesterol => 'Holesterol';

  @override
  String get nutrientCalcium => 'Kalcij';

  @override
  String get nutrientIron => 'Željezo';

  @override
  String get nutrientMagnesium => 'Magnezij';

  @override
  String get nutrientPotassium => 'Kalij';

  @override
  String get nutrientZinc => 'Cink';

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
  String get nutrientFolate => 'Folna kiselina';

  @override
  String get foodSourceUser => 'Moji sastojci';

  @override
  String get foodSourceRecipe => 'Moji recepti';

  @override
  String get nutritionCancel => 'Otkaži';

  @override
  String get nutritionSave => 'Sačuvaj';

  @override
  String get nutritionDelete => 'Obriši';

  @override
  String get nutritionEdit => 'Uredi';

  @override
  String get nutritionRetry => 'Pokušaj ponovo';

  @override
  String get nutritionNoLinks =>
      'Poveži sastojke s namirnicama u uređivaču recepta da vidiš nutritivne vrijednosti.';

  @override
  String get nutritionBasisPortion => 'Porcija';

  @override
  String get nutritionBasisCustom => 'Vlastito';

  @override
  String get nutritionAmount => 'Količina';

  @override
  String nutritionDishWeighed(String weight) {
    return 'Jelo $weight (izvagano)';
  }

  @override
  String nutritionDishSum(String weight) {
    return 'Jelo $weight (zbir sastojaka)';
  }

  @override
  String nutritionPortionsOfAbout(int count, String weight) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porcija od oko $weight',
      few: '$count porcije od oko $weight',
      one: '$count porcija od oko $weight',
    );
    return '$_temp0';
  }

  @override
  String get nutritionLowerBound =>
      '* Za neke povezane namirnice nema podataka za ovu vrijednost, pa je ona donja granica.';

  @override
  String get nutritionSalt => 'So';

  @override
  String get nutritionVitaminsMinerals => 'Vitamini i minerali';

  @override
  String get nutritionDailyReferenceHint =>
      '% EU referentnog dnevnog unosa za odrasle';

  @override
  String get nutritionNotCounted => 'Nije uračunato';

  @override
  String nutritionMissingNoFood(String name) {
    return '$name: nije povezana namirnica';
  }

  @override
  String nutritionMissingNoWeight(String name, String unit) {
    return '$name: nema težine u gramima za „$unit“';
  }

  @override
  String get nutritionOffUnreachable =>
      'Open Food Facts nije dostupan. Provjeri internet vezu.';

  @override
  String get nutritionUsdaUnreachable =>
      'USDA nije dostupan. Provjeri internet vezu.';

  @override
  String get nutritionIngredientsTitle => 'Sastojci';

  @override
  String get nutritionMyIngredientButton => 'Moj sastojak';

  @override
  String get nutritionBuiltIn => 'Ugrađeni sastojci';

  @override
  String nutritionBuiltInCount(int count) {
    return 'Ugrađeni sastojci: $count';
  }

  @override
  String get nutritionBuiltInSubtitle =>
      'USDA FoodData Central, radi bez interneta';

  @override
  String get nutritionUsdaOnline => 'USDA pretraga na internetu';

  @override
  String get apiKeyOriginDemo =>
      'Zajednički demo ključ, nekoliko pretraga na sat. Dodaj svoj besplatni ključ za više.';

  @override
  String get apiKeyOriginDeveloper => 'Razvojni ključ iz config/local.json';

  @override
  String get apiKeyOriginUser => 'Tvoj vlastiti API ključ';

  @override
  String get apiKeyChange => 'Promijeni';

  @override
  String get apiKeyAdd => 'Dodaj ključ';

  @override
  String get nutritionMyIngredients => 'Moji sastojci';

  @override
  String get nutritionMyIngredientsEmpty =>
      'Dodaj sastojke koje ne možeš pronaći, npr. s deklaracije na pakovanju.';

  @override
  String get nutritionOnlineInRecipes =>
      'Sastojci s interneta u tvojim receptima';

  @override
  String foodAskingLatest(String source) {
    return 'Tražim najnovije vrijednosti od $source…';
  }

  @override
  String get foodUsedInRecipes => 'koristi se u receptima';

  @override
  String foodDeleteTitle(String name) {
    return 'Obrisati „$name“?';
  }

  @override
  String get foodDeleteUsed =>
      'Neki recepti koriste ovaj sastojak. Tamo će pisati „nije povezana namirnica“ dok ne povežeš drugi.';

  @override
  String get foodDeleteUnused => 'Sastojak će biti uklonjen s ovog uređaja.';

  @override
  String foodGone(String source) {
    return '$source više nema ovu namirnicu';
  }

  @override
  String foodUpdated(String name) {
    return '„$name“ ažurirano';
  }

  @override
  String get nutritionPer100g => 'Na 100 g';

  @override
  String get nutritionPortions => 'Porcije';

  @override
  String get foodCopyToMine => 'Kopiraj u moje sastojke';

  @override
  String get foodUpdating => 'Ažuriram…';

  @override
  String foodUpdateFrom(String source) {
    return 'Ažuriraj s $source';
  }

  @override
  String get foodNewTitle => 'Novi sastojak';

  @override
  String get foodEditTitle => 'Uredi sastojak';

  @override
  String get foodName => 'Naziv';

  @override
  String get foodRequiredError => 'Obavezno';

  @override
  String get foodNumberError => 'Broj';

  @override
  String get foodNutritionPer100g => 'Nutritivne vrijednosti na 100 g';

  @override
  String get foodNutritionHint =>
      'Prepiši vrijednosti s deklaracije. Nepoznate vrijednosti ostavi prazne.';

  @override
  String get foodOfWhichSaturates => 'od kojih zasićene masne kiseline';

  @override
  String get foodOfWhichSugars => 'od kojih šećeri';

  @override
  String get foodMoreNutrients => 'Više nutrijenata';

  @override
  String get foodMoreNutrientsHint => 'Vitamini, minerali i holesterol';

  @override
  String get foodPortionsHint =>
      'Koliko teži jedna jedinica, da recepti mogu koristiti šolje, kašike ili komade.';

  @override
  String get foodQty => 'Kol.';

  @override
  String get foodUnit => 'Jedinica';

  @override
  String get foodWeight => 'Težina';

  @override
  String get foodRemovePortion => 'Ukloni';

  @override
  String get foodAddPortion => 'Dodaj porciju';

  @override
  String apiKeyOpenInBrowser(String url) {
    return 'Otvori $url u pregledniku';
  }

  @override
  String get apiKeyRateLimited =>
      'Dostigao si USDA ograničenje po satu za svoj ključ. Pokušaj ponovo kasnije.';

  @override
  String get apiKeyRejected =>
      'USDA nije prihvatio API ključ. Provjeri ga u Sastojci > USDA pretraga na internetu.';

  @override
  String get apiKeyDemoLimitTitle => 'Besplatne pretrage su potrošene';

  @override
  String get apiKeyDemoLimitIntro =>
      'Hej, druže, vidimo da si potrošio sve ugrađene USDA pretrage.';

  @override
  String get apiKeyDemoLimitSignupBefore =>
      'Ako ti treba više, možeš se prijaviti za svoj besplatni API ključ na ';

  @override
  String get apiKeyDemoLimitSignupAfter =>
      '. Kad se registruješ, dobit ćeš svoj API ključ e-mailom.';

  @override
  String get apiKeyDemoLimitEnterKey =>
      'Taj ključ onda možeš unijeti u aplikaciju i dobiti više pretraga.';

  @override
  String get apiKeyDemoLimitWarning =>
      'Ne zaboravi: ne dijeli svoj ključ javno.';

  @override
  String get apiKeyNotNow => 'Ne sada';

  @override
  String get apiKeyGetKey => 'Nabavi ključ';

  @override
  String get apiKeyEnterMine => 'Unesi svoj ključ';

  @override
  String get apiKeySaved => 'Tvoj API ključ je sačuvan';

  @override
  String get apiKeyRemoved => 'Tvoj API ključ je uklonjen';

  @override
  String get apiKeyDialogTitle => 'Tvoj USDA API ključ';

  @override
  String get apiKeyLabel => 'API ključ';

  @override
  String get apiKeyStoredLocally =>
      'Ključ se čuva samo na ovom uređaju. Ne dijeli ga javno.';

  @override
  String get apiKeyGetFreeKey => 'Nabavi besplatni ključ';

  @override
  String get apiKeyRemove => 'Ukloni ključ';

  @override
  String get pickerRecipeDetail => 'Recept';

  @override
  String get pickerNoLongerAvailable => 'Ovaj sastojak više nije dostupan';

  @override
  String get pickerProductNotFound => 'Proizvod nije pronađen';

  @override
  String pickerProductNotFoundBody(String code) {
    return 'Open Food Facts još ne poznaje barkod $code. Umjesto toga možeš unijeti vrijednosti s deklaracije.';
  }

  @override
  String get pickerCreateOwnButton => 'Napravi svoj';

  @override
  String get pickerSearchHint => 'Traži sastojke, npr. „brašno pšenično“';

  @override
  String get pickerCreateOwn => 'Napravi svoj sastojak';

  @override
  String get pickerCreateOwnSubtitle => 'Unesi vrijednosti s deklaracije';

  @override
  String get pickerScanBarcode => 'Skeniraj barkod s pakovanja';

  @override
  String get pickerEnterBarcode => 'Unesi barkod s pakovanja';

  @override
  String get pickerBarcodeSubtitle => 'Traži proizvod u Open Food Facts';

  @override
  String pickerBarcodeCode(String code) {
    return 'Barkod $code';
  }

  @override
  String get pickerNothingLocal => 'Ništa nije pronađeno na ovom uređaju';

  @override
  String get pickerSearchOnline => 'Traži na internetu';

  @override
  String pickerSearchOnlineFor(String query) {
    return 'Traži „$query“ na internetu';
  }

  @override
  String get pickerUsdaIngredients => 'USDA sastojci';

  @override
  String get pickerStoreProducts => 'Proizvodi iz trgovine';

  @override
  String get pickerAskingUsda =>
      'Pitam USDA, ovo može potrajati nekoliko sekundi…';

  @override
  String get pickerAskingOff => 'Pitam Open Food Facts…';

  @override
  String get pickerNoMoreOnline => 'Nema dodatnih rezultata s interneta';

  @override
  String pickerUses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'U $count recepata',
      few: 'U $count recepta',
      one: 'U $count receptu',
    );
    return '$_temp0';
  }

  @override
  String get pickerOffAttribution =>
      'Podaci o proizvodima s Open Food Facts, koje su napravili saradnici pod licencom Open Database License (ODbL).';

  @override
  String get scannerTitle => 'Skeniraj barkod';

  @override
  String get scannerTorch => 'Svjetiljka';

  @override
  String get scannerHint => 'Usmjeri kameru na barkod na pakovanju';

  @override
  String get scannerTypeNumber => 'Ukucaj broj';

  @override
  String get scannerPermissionDenied =>
      'Manja nema dozvolu za kameru. Dozvoli je u postavkama telefona ili ukucaj broj.';

  @override
  String get scannerCameraFailed => 'Kamera se nije mogla pokrenuti.';

  @override
  String get scannerInvalidBarcode => 'Barkod ima od 8 do 14 cifara';

  @override
  String get scannerDialogTitle => 'Barkod s pakovanja';

  @override
  String get scannerLookUp => 'Potraži';

  @override
  String get converterTitle => 'Pretvarač jedinica';

  @override
  String get converterSwap => 'Zamijeni jedinice';

  @override
  String get converterIngredient => 'Sastojak';

  @override
  String get converterIngredientHint =>
      'Šolje, kašike i mililitri imaju različitu težinu za svaki sastojak.';

  @override
  String get converterOther => 'Drugi…';

  @override
  String get converterPickIngredient =>
      'Odaberi sastojak da pretvaraš između zapremine i težine.';

  @override
  String converterNoWeight(String unit, String food) {
    return 'Za $food nema težine po „$unit“.';
  }

  @override
  String get converterNoVolumeWeights =>
      'Za ovaj sastojak nisu poznate težine po zapremini.';

  @override
  String get converterCommonEquivalents => 'Uobičajeni odnosi';

  @override
  String converterTeaspoons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kašičica',
      few: '$count kašičice',
      one: '$count kašičica',
    );
    return '$_temp0';
  }

  @override
  String converterTablespoons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kašika',
      few: '$count kašike',
      one: '$count kašika',
    );
    return '$_temp0';
  }

  @override
  String get converterFlour => 'Brašno';

  @override
  String get converterSugar => 'Šećer';

  @override
  String get converterPowderedSugar => 'Šećer u prahu';

  @override
  String get converterButter => 'Puter';

  @override
  String get converterWater => 'Voda';

  @override
  String get converterMilk => 'Mlijeko';

  @override
  String get converterOliveOil => 'Maslinovo ulje';

  @override
  String get converterRice => 'Riža';

  @override
  String get converterHoney => 'Med';

  @override
  String get converterSalt => 'So';

  @override
  String get converterOats => 'Zobene pahuljice';

  @override
  String get converterCocoa => 'Kakao';

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get settingsSectionApp => 'Aplikacija';

  @override
  String get settingsSectionWheel => 'Kolo';

  @override
  String get settingsSectionKitchen => 'Kuhinja';

  @override
  String get settingsSectionIngredients => 'Sastojci';

  @override
  String get settingsSectionAbout => 'O aplikaciji';

  @override
  String get settingsAppearanceSubtitle => 'Tema, svijetli i tamni način';

  @override
  String get settingsBackupSubtitle => 'Izvezi ili uvezi cijeli profil';

  @override
  String get settingsWheelLookSubtitle => 'Tema, fotografije, veličina, nazivi';

  @override
  String get settingsRoundsSubtitle => 'Kada se pojedena jela vraćaju';

  @override
  String get settingsTagsSubtitle => 'Vrste jela i tvoje vlastite grupe';

  @override
  String get settingsConverterTitle => 'Pretvarač jedinica';

  @override
  String get settingsConverterSubtitle => 'Šolje, kašike, grami i mililitri';

  @override
  String get settingsIngredientsTitle => 'Sastojci i USDA ključ';

  @override
  String get settingsIngredientsSubtitle =>
      'Vlastiti sastojci, ugrađeni podaci, pretraga na internetu';

  @override
  String get settingsAboutTitle => 'O aplikaciji Manja';

  @override
  String get settingsAboutSubtitle => 'Licenca, izvorni kod i zasluge';

  @override
  String get appearanceTitle => 'Izgled';

  @override
  String get appearanceAppTheme => 'Tema aplikacije';

  @override
  String get appearanceMode => 'Način';

  @override
  String get appearanceDevAlwaysDark => 'Dev tema je uvijek tamna.';

  @override
  String get appearanceSystemHint =>
      'Sistem prati svijetlu ili tamnu postavku tvog uređaja.';

  @override
  String get backupTitle => 'Sigurnosna kopija i prenos';

  @override
  String get backupPickTitle => 'Otvori Manja profil';

  @override
  String get backupSaveTitle => 'Sačuvaj profil';

  @override
  String get backupShareSubject => 'Manja profil';

  @override
  String get backupSaved => 'Profil sačuvan';

  @override
  String backupError(String error) {
    return 'Nešto nije u redu: $error';
  }

  @override
  String get backupNotAProfile => 'Ovo nije Manja profil.';

  @override
  String get backupNewerVersion =>
      'Ovaj profil je napravljen novijom verzijom aplikacije. Prvo ažuriraj aplikaciju.';

  @override
  String backupRecipesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata dodano',
      few: '$count recepta dodana',
      one: '$count recept dodan',
    );
    return '$_temp0';
  }

  @override
  String backupAddedSkipped(String added, int skipped) {
    return '$added, $skipped već postoji';
  }

  @override
  String get backupReplaceTitle => 'Zamijeniti sve?';

  @override
  String get backupReplaceText =>
      'Svi recepti, fotografije, historija obroka, vlastiti sastojci, ostava i postavke na ovom uređaju bit će zamijenjeni profilom. Tvoj USDA ključ ostaje.';

  @override
  String get backupReplaceEverything => 'Zamijeni sve';

  @override
  String get backupCancel => 'Otkaži';

  @override
  String get backupExport => 'Izvoz';

  @override
  String backupExportText(String extension) {
    return 'Sprema tvoje recepte, fotografije, vlastite sastojke, ostavu, historiju obroka i postavke u jednu $extension datoteku. Koristi je kao sigurnosnu kopiju ili za prenos na drugi uređaj. Tvoj USDA ključ nikad nije uključen.';
  }

  @override
  String get backupSaveToFile => 'Sačuvaj u datoteku';

  @override
  String get backupShare => 'Podijeli';

  @override
  String get backupImport => 'Uvoz';

  @override
  String backupImportText(String extension) {
    return 'Otvori $extension datoteku. Možeš dodati njene recepte svojima ili zamijeniti sve.';
  }

  @override
  String get backupOpenProfile => 'Otvori profil';

  @override
  String get backupImportTitle => 'Uvezi profil';

  @override
  String backupSavedOn(String date) {
    return 'Sačuvano $date';
  }

  @override
  String backupRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata',
      few: '$count recepta',
      one: '$count recept',
    );
    return '$_temp0';
  }

  @override
  String backupPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotografija',
      few: '$count fotografije',
      one: '$count fotografija',
    );
    return '$_temp0';
  }

  @override
  String backupMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obroka',
      few: '$count obroka',
      one: '$count obrok',
    );
    return '$_temp0';
  }

  @override
  String backupOwnIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vlastitih sastojaka',
      few: '$count vlastita sastojka',
      one: '$count vlastiti sastojak',
    );
    return '$_temp0';
  }

  @override
  String backupPantryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stavki iz ostave',
      few: '$count stavke iz ostave',
      one: '$count stavka iz ostave',
    );
    return '$_temp0';
  }

  @override
  String get backupSkipHint =>
      'Pri dodavanju se preskaču recepti s nazivom koji već imaš.';

  @override
  String get backupReplace => 'Zamijeni';

  @override
  String get backupAdd => 'Dodaj';

  @override
  String get wheelLookTitle => 'Izgled kola';

  @override
  String get wheelLookTheme => 'Tema';

  @override
  String get wheelLookShow => 'Prikaži na kolu';

  @override
  String get wheelLookSize => 'Veličina';

  @override
  String wheelLookMaxSlices(int count) {
    return 'Recepti na kolu: $count';
  }

  @override
  String get wheelLookMaxSlicesHint =>
      'Ako ima više recepata, jedno polje „+n“ predstavlja ostale. Svaki recept i dalje ima istu šansu.';

  @override
  String wheelLookWinnerPercent(int percent) {
    return 'Dobitno jelo zauzima $percent% kola';
  }

  @override
  String wheelLookPercent(int percent) {
    return '$percent%';
  }

  @override
  String get wheelLookSpin => 'Okretanje';

  @override
  String wheelLookSpinTime(String seconds) {
    return 'Trajanje okretanja: $seconds s';
  }

  @override
  String get wheelLookSpinTimeHint =>
      'Koliko dugo se kolo okreće prije nego što stane';

  @override
  String wheelLookReveal(String seconds) {
    return 'Otkrivanje dobitnika: $seconds s';
  }

  @override
  String get wheelLookRevealHint => 'Koliko dugo odabrano jelo raste na kolu';

  @override
  String wheelLookSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get wheelLookNames => 'Nazivi';

  @override
  String get wheelLookUpright => 'Nazivi uvijek uspravni';

  @override
  String get wheelLookUprightHint =>
      'Okreni nazive na lijevoj polovini da nikad ne budu naopako';

  @override
  String get roundsTitle => 'Krugovi kola';

  @override
  String get roundsPutBack => 'Vrati pojedena jela na kolo';

  @override
  String get roundsResetEvery => 'Novi krug svakih';

  @override
  String get roundsFewerDays => 'Manje dana';

  @override
  String get roundsMoreDays => 'Više dana';

  @override
  String roundsDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dana',
      few: 'dana',
      one: 'dan',
    );
    return '$_temp0';
  }

  @override
  String get roundsHistoryKept =>
      'Tvoja historija obroka se uvijek čuva. Novi krug samo vraća jela na kolo.';

  @override
  String get tagsTitle => 'Kategorije';

  @override
  String get tagsNew => 'Nova kategorija';

  @override
  String get tagsRenameTitle => 'Preimenuj kategoriju';

  @override
  String get tagsRename => 'Preimenuj';

  @override
  String get tagsAdd => 'Dodaj';

  @override
  String get tagsCancel => 'Otkaži';

  @override
  String get tagsDelete => 'Obriši';

  @override
  String tagsDeleteTitle(String name) {
    return 'Obrisati „$name“?';
  }

  @override
  String get tagsDeleteUnused => 'Nijedan recept ne koristi ovu kategoriju.';

  @override
  String tagsDeleteUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uklanja se iz $count recepata. Sami recepti ostaju.',
      few: 'Uklanja se iz $count recepta. Sami recepti ostaju.',
      one: 'Uklanja se iz $count recepta. Sami recepti ostaju.',
    );
    return '$_temp0';
  }

  @override
  String get tagsIntro =>
      'Kategorije grupišu tvoje recepte. Odaberi jednu iznad kola da vrtiš samo njih. Povuci da promijeniš redoslijed.';

  @override
  String tagsRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata',
      few: '$count recepta',
      one: '$count recept',
    );
    return '$_temp0';
  }

  @override
  String get tagsIngredientHint =>
      'može se koristiti kao sastojak, na kolu samo ako je odabrana';

  @override
  String get tagsNameHint => 'Brzo radnim danom';

  @override
  String get cookbookTitle => 'Kuharica (PDF)';

  @override
  String get cookbookDefaultTitle => 'Manja kuharica';

  @override
  String get cookbookFallbackTitle => 'Kuharica';

  @override
  String get cookbookNoneSelected => 'Nema odabranih recepata';

  @override
  String cookbookCreate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Napravi PDF s $count recepata',
      few: 'Napravi PDF s $count recepta',
      one: 'Napravi PDF s $count receptom',
    );
    return '$_temp0';
  }

  @override
  String get cookbookTitleField => 'Naslov';

  @override
  String get cookbookLayout => 'Raspored';

  @override
  String get cookbookRecipes => 'Recepti';

  @override
  String cookbookAll(int count) {
    return 'Svi recepti ($count)';
  }

  @override
  String cookbookFavorites(int count) {
    return 'Omiljeni ($count)';
  }

  @override
  String get cookbookTagged => 'Po kategoriji';

  @override
  String cookbookChosen(int count) {
    return 'Odabrani ($count)';
  }

  @override
  String get cookbookChoose => 'Odaberi';

  @override
  String get cookbookInclude => 'Uključi';

  @override
  String get cookbookCover => 'Naslovna stranica';

  @override
  String get cookbookContents => 'Sadržaj';

  @override
  String get cookbookPhotos => 'Fotografije';

  @override
  String get cookbookNutrition => 'Nutritivne vrijednosti po porciji';

  @override
  String get cookbookNutritionHint => 'Samo za recepte s povezanim sastojcima';

  @override
  String cookbookChosenCount(int count) {
    return 'Odabrano: $count';
  }

  @override
  String get cookbookSelectNone => 'Nijedan';

  @override
  String get cookbookSelectAll => 'Sve';

  @override
  String get cookbookDone => 'Gotovo';

  @override
  String get cookbookPreview => 'Pregled';

  @override
  String get cookbookLayingOut => 'Slažem tvoju kuharicu…';

  @override
  String get cookbookLayoutClassic => 'Klasično';

  @override
  String get cookbookLayoutClassicHint =>
      'A4, jedan recept po stranici s velikom fotografijom';

  @override
  String get cookbookLayoutCompact => 'Kompaktno';

  @override
  String get cookbookLayoutCompactHint =>
      'A4, recepti jedan za drugim, štedi papir';

  @override
  String get cookbookLayoutCards => 'Kartice';

  @override
  String get cookbookLayoutCardsHint =>
      'A6 kartice, po jedan recept, lako se izrežu';

  @override
  String get pdfNoRecipes => 'Još nema recepata';

  @override
  String pdfRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recepata',
      few: '$count recepta',
      one: '$count recept',
    );
    return '$_temp0';
  }

  @override
  String get pdfMonths =>
      'januar,februar,mart,april,maj,juni,juli,august,septembar,oktobar,novembar,decembar';

  @override
  String get pdfMadeWith => 'Napravljeno u aplikaciji Manja';

  @override
  String get pdfContents => 'Sadržaj';

  @override
  String get pdfPerPortion => 'Po porciji';

  @override
  String get pdfPerPortionAtLeast => 'Po porciji, najmanje';

  @override
  String get pdfIngredients => 'Sastojci';

  @override
  String get pdfPreparation => 'Priprema';

  @override
  String get pdfNotes => 'Bilješke';

  @override
  String pdfSource(String host) {
    return 'Izvor: $host';
  }

  @override
  String pdfPage(String page) {
    return 'str. $page';
  }

  @override
  String pdfPortions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count porcija',
      few: '$count porcije',
      one: '$count porcija',
    );
    return '$_temp0';
  }

  @override
  String pdfPrep(String time) {
    return 'Priprema $time';
  }

  @override
  String pdfCook(String time) {
    return 'Kuhanje $time';
  }

  @override
  String pdfMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String pdfHours(int hours) {
    return '$hours h';
  }

  @override
  String pdfHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get pdfProtein => 'bjelančevine';

  @override
  String get pdfFat => 'masti';

  @override
  String get pdfCarbohydrate => 'ugljikohidrati';

  @override
  String get pdfFiber => 'vlakna';

  @override
  String get aboutLicense =>
      'Slobodan softver pod licencom GNU Affero General Public License v3.0.';

  @override
  String aboutSource(String url) {
    return 'Izvorni kod: $url';
  }

  @override
  String get aboutTrademark => 'Naziv „Manja“ i logo nisu obuhvaćeni licencom.';
}
