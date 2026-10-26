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

  @override
  String recipeFoodPortion(String grams) {
    return '1 portion = $grams g';
  }

  @override
  String recipeFoodPortionEstimate(String grams) {
    return '1 portion ≈ $grams g';
  }

  @override
  String get recipeFoodWeightUnknown => 'Weight of a portion unknown';

  @override
  String get recipeEditTitleNew => 'New recipe';

  @override
  String get recipeEditTitleEdit => 'Edit recipe';

  @override
  String get recipeSave => 'Save';

  @override
  String get recipeQty => 'Qty';

  @override
  String get recipeUnit => 'Unit';

  @override
  String get recipeIngredient => 'Ingredient';

  @override
  String recipeSuggestionRecipes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get recipeNewTag => 'New tag';

  @override
  String get recipeLinkNutrition => 'Link nutrition';

  @override
  String get recipeLinkedRecipeDeleted => 'Linked recipe (deleted)';

  @override
  String get recipeLinkedIngredientMissing =>
      'Linked ingredient (not on this device)';

  @override
  String recipePortionWeightUnknown(String name) {
    return 'The weight of a portion is unknown. Link the ingredients of \"$name\" or enter its finished weight.';
  }

  @override
  String recipeNoGramWeight(String unit) {
    return 'No gram weight for \"$unit\". Use g or ml, or add a portion to the ingredient.';
  }

  @override
  String get recipeChangeLink => 'Change';

  @override
  String get recipeUnlink => 'Unlink';

  @override
  String recipePhotoLoadError(String error) {
    return 'Could not load the photo: $error';
  }

  @override
  String get recipeCamera => 'Camera';

  @override
  String get recipeGallery => 'Gallery';

  @override
  String get recipeChoosePhoto => 'Choose photo';

  @override
  String get recipeRemove => 'Remove';

  @override
  String get recipeRequired => 'Required';

  @override
  String get recipeWholeMinutes => 'Whole minutes';

  @override
  String get recipeName => 'Name';

  @override
  String get recipePortions => 'Portions';

  @override
  String get recipeAtLeastOne => 'At least 1';

  @override
  String get recipePrepMinutes => 'Prep (min)';

  @override
  String get recipeCookMinutes => 'Cook (min)';

  @override
  String get recipeTags => 'Tags';

  @override
  String get recipeIngredients => 'Ingredients';

  @override
  String get recipeAddIngredient => 'Add ingredient';

  @override
  String get recipeAddHeading => 'Add heading';

  @override
  String get recipeFinishedWeight => 'Weight of the finished dish (optional)';

  @override
  String get recipeFinishedWeightHelp =>
      'Cooking changes the weight. Weigh the dish for accurate per 100 g values.';

  @override
  String get recipeFinishedWeightInvalid => 'Grams, e.g. 850';

  @override
  String get recipeCookingInfo => 'Cooking info';

  @override
  String get recipeCookingInfoHint => 'Oven temperature, pan size, tips…';

  @override
  String get recipePreparationSteps => 'Preparation steps';

  @override
  String get recipeAddStep => 'Add step';

  @override
  String get recipeDragToReorder => 'Drag to reorder';

  @override
  String get recipeHeading => 'Heading';

  @override
  String get recipeHeadingHint => 'Dough, Topping, Sauce…';

  @override
  String get recipeDeleteTitle => 'Delete recipe?';

  @override
  String recipeDeleteMessage(String name) {
    return '\"$name\" and its meal history will be removed.';
  }

  @override
  String get recipeCancel => 'Cancel';

  @override
  String get recipeDelete => 'Delete';

  @override
  String get recipeEdit => 'Edit';

  @override
  String get recipeNotFound => 'Recipe not found';

  @override
  String recipePrepChip(int minutes) {
    return 'Prep $minutes min';
  }

  @override
  String recipeCookChip(int minutes) {
    return 'Cook $minutes min';
  }

  @override
  String get recipeNoIngredients => 'No ingredients added.';

  @override
  String get recipeNutrition => 'Nutrition';

  @override
  String recipeSource(String host) {
    return 'Source: $host';
  }

  @override
  String get recipePreparation => 'Preparation';

  @override
  String get recipeNoSteps => 'No steps added.';

  @override
  String get recipeListTitle => 'Recipes';

  @override
  String get recipeImportFromLink => 'Import from link';

  @override
  String get recipeCookbookPdf => 'Cookbook PDF';

  @override
  String get recipeUnitConverter => 'Unit converter';

  @override
  String get recipeAdd => 'Add recipe';

  @override
  String get recipeListEmpty => 'No recipes yet. Tap \"Add recipe\" to start.';

  @override
  String get recipeSearch => 'Search recipes';

  @override
  String recipePortionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count portions',
      one: '1 portion',
    );
    return '$_temp0';
  }

  @override
  String recipeTotalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeImportTitle => 'Import recipe';

  @override
  String get recipeImportUrlLabel => 'Link to the recipe';

  @override
  String get recipePaste => 'Paste';

  @override
  String get recipeImport => 'Import';

  @override
  String get recipeImportInvalidUrl =>
      'Enter a link to a recipe page, for example https://www.coolinarika.com/recept/…';

  @override
  String get recipeImportBotCheckTimeout =>
      'The site kept checking the browser. Try again later, or copy the recipe by hand.';

  @override
  String get recipeImportNoRecipe =>
      'No recipe data found on this page. The site may not publish its recipes in a readable format.';

  @override
  String recipeImportReading(String host) {
    return 'Reading the recipe from $host…';
  }

  @override
  String get recipeImportReadingPage => 'Reading the recipe from the page…';

  @override
  String get recipeImportChallenge =>
      'The site wants to check that you are a person. Complete the check below.';

  @override
  String get recipeImportPhoto => 'Downloading the photo…';

  @override
  String get recipeImportHint =>
      'Works with most recipe sites. You can check and change everything before saving.';

  @override
  String get recipeImportTimeout => 'The page did not load in time.';

  @override
  String get recipeImportUnreachable =>
      'The page could not be reached. Check your internet connection.';

  @override
  String get recipeImportBlocked =>
      'This site blocks automatic downloads. Import it on your phone, where the page opens in a browser view.';

  @override
  String recipeImportHttpError(int status) {
    return 'The page answered with HTTP $status.';
  }

  @override
  String get navWheel => 'Wheel';

  @override
  String get navRecipes => 'Recipes';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String wheelEnjoy(String recipe) {
    return 'Enjoy your $recipe!';
  }

  @override
  String get wheelResetTitle => 'Reset the wheel?';

  @override
  String get wheelResetMessage =>
      'All recipes will be back on the wheel. Your meal history is kept.';

  @override
  String get wheelCancel => 'Cancel';

  @override
  String get wheelReset => 'Reset';

  @override
  String get wheelResetWheel => 'Reset wheel';

  @override
  String get wheelLook => 'Wheel look';

  @override
  String get wheelShowAll => 'Show all dishes';

  @override
  String get wheelNoFilterMatch => 'No dishes match your filters';

  @override
  String wheelHiddenByFilters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dishes are hidden by the filters.',
      one: '1 dish is hidden by the filters.',
    );
    return '$_temp0';
  }

  @override
  String get wheelClearFilters => 'Clear filters';

  @override
  String wheelNothingTagged(String tag) {
    return 'Nothing tagged $tag';
  }

  @override
  String get wheelNothingTaggedMessage =>
      'Add the tag to recipes in the recipe editor, or pick another tag.';

  @override
  String get wheelNoRecipes => 'No recipes yet';

  @override
  String get wheelNoRecipesMessage =>
      'Add your favourite dishes in the Recipes tab and they will show up here.';

  @override
  String get wheelAllEaten => 'You ate everything!';

  @override
  String wheelAllTagEaten(String tag) {
    return 'All $tag dishes eaten';
  }

  @override
  String get wheelAllEatenMessage =>
      'Every dish on the wheel has been cooked this round.';

  @override
  String wheelAllTagEatenMessage(String tag) {
    return 'Every dish tagged $tag has been cooked this round.';
  }

  @override
  String wheelCanMakeNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dishes you can make now',
      one: '1 dish you can make now',
    );
    return '$_temp0';
  }

  @override
  String wheelDishesLeft(int left, int total) {
    return '$left of $total dishes left';
  }

  @override
  String wheelFilterUpToKcal(int kcal) {
    return 'Up to $kcal kcal';
  }

  @override
  String wheelFilterUpToMinutes(int minutes) {
    return 'up to $minutes min';
  }

  @override
  String wheelFilterHidden(int count) {
    return '$count hidden';
  }

  @override
  String get wheelSpin => 'Spin';

  @override
  String get wheelSpinning => 'Spinning…';

  @override
  String get wheelTodayYouCook => 'Today you cook';

  @override
  String get wheelSpinAgain => 'Spin again';

  @override
  String get wheelLetsCook => 'Let\'s cook it';

  @override
  String get wheelFilters => 'Filters';

  @override
  String get wheelAllTags => 'All';

  @override
  String wheelFilterKcalOn(int kcal) {
    return 'Up to $kcal kcal per portion';
  }

  @override
  String get wheelFilterKcalOff => 'Calories per portion';

  @override
  String get wheelFilterKcalHelp => 'From the linked ingredients';

  @override
  String wheelMinutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String wheelFilterMinutesOn(int minutes) {
    return 'Ready in up to $minutes min';
  }

  @override
  String get wheelFilterMinutesOff => 'Total time';

  @override
  String get wheelFilterMinutesHelp => 'Prep and cooking together';

  @override
  String get wheelFilterUnknown => 'Include dishes with unknown values';

  @override
  String get wheelFilterUnknownHelp =>
      'Recipes without linked ingredients or times stay on the wheel';

  @override
  String get wheelResetModeWhenEmpty => 'When every dish was eaten';

  @override
  String get wheelResetModeAfterDays => 'After a number of days';

  @override
  String get wheelResetModeManual => 'Only manually';

  @override
  String get wheelContentText => 'Text';

  @override
  String get wheelContentPhoto => 'Photo';

  @override
  String get wheelContentBoth => 'Both';

  @override
  String get wheelThemeClassic => 'Classic';

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
  String get themeManjaDescription => 'Paprika, basil and saffron';

  @override
  String get themeNeutral => 'Neutral';

  @override
  String get themeNeutralDescription => 'Calm slate and grey';

  @override
  String get themeDev => 'Dev';

  @override
  String get themeDevDescription => 'Charcoal and yellow, always dark';

  @override
  String get themeBrightnessSystem => 'System';

  @override
  String get themeBrightnessLight => 'Light';

  @override
  String get themeBrightnessDark => 'Dark';

  @override
  String get historyTitle => 'History';

  @override
  String get historyRangeHelp => 'Show meals from';

  @override
  String get historyRangeSave => 'Show';

  @override
  String historyRemoved(String recipe) {
    return '$recipe removed from the history';
  }

  @override
  String get historyUndo => 'Undo';

  @override
  String get historyEmpty => 'Nothing cooked yet. Spin the wheel!';

  @override
  String historyMonthHeader(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meals',
      one: '1 meal',
    );
    return '$month · $_temp0';
  }

  @override
  String get historySearchHint => 'Search dishes';

  @override
  String get historyClearSearch => 'Clear search';

  @override
  String get historyPickDates => 'Pick dates';

  @override
  String get historyNoMatch => 'No meals match';

  @override
  String historyMatchSummary(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meals, last on $date',
      one: '1 meal on $date',
    );
    return '$_temp0';
  }

  @override
  String get pantryTitle => 'What can I cook?';

  @override
  String pantrySpinWith(int count) {
    return 'Spin with these $count';
  }

  @override
  String get pantrySwitchToWheel =>
      'Switch to \"On the wheel\" to spin with these';

  @override
  String get pantryAlwaysAtHome => 'Always at home';

  @override
  String get pantryAddBasicHint => 'Add a basic, e.g. olive oil';

  @override
  String get pantryAlwaysEmpty =>
      'Add what you always have, like salt, oil or flour.';

  @override
  String get pantryStaples =>
      'Salt,Pepper,Oil,Flour,Sugar,Eggs,Milk,Butter,Onion,Garlic,Rice';

  @override
  String get pantryInTheMood => 'In the mood for';

  @override
  String get pantryAddCravingHint => 'Add an ingredient, e.g. chicken';

  @override
  String get pantryCravingEmpty =>
      'Optional. Pick what you feel like today to only see dishes with it.';

  @override
  String get pantryOnWheel => 'On the wheel';

  @override
  String get pantryAllRecipes => 'All recipes';

  @override
  String pantryCanMake(int count) {
    return 'You can make ($count)';
  }

  @override
  String get pantryEmptyHint =>
      'Add what you have at home to see which dishes you can make.';

  @override
  String get pantryNothingYet => 'Nothing yet with these ingredients.';

  @override
  String pantryMissingFew(int count) {
    return 'Missing one or two ($count)';
  }

  @override
  String get pantryAdd => 'Add';

  @override
  String pantryHaveAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have all $count ingredients',
    );
    return '$_temp0';
  }

  @override
  String pantryMissing(String items) {
    return 'Missing: $items';
  }

  @override
  String get nutrientEnergy => 'Energy';

  @override
  String get nutrientProtein => 'Protein';

  @override
  String get nutrientFat => 'Fat';

  @override
  String get nutrientSaturatedFat => 'Saturated fat';

  @override
  String get nutrientCarbohydrate => 'Carbohydrate';

  @override
  String get nutrientSugars => 'Sugars';

  @override
  String get nutrientFiber => 'Fiber';

  @override
  String get nutrientSodium => 'Sodium';

  @override
  String get nutrientCholesterol => 'Cholesterol';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Iron';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientPotassium => 'Potassium';

  @override
  String get nutrientZinc => 'Zinc';

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
  String get nutrientFolate => 'Folate';

  @override
  String get foodSourceUser => 'My ingredients';

  @override
  String get foodSourceRecipe => 'My recipes';

  @override
  String get nutritionCancel => 'Cancel';

  @override
  String get nutritionSave => 'Save';

  @override
  String get nutritionDelete => 'Delete';

  @override
  String get nutritionEdit => 'Edit';

  @override
  String get nutritionRetry => 'Retry';

  @override
  String get nutritionNoLinks =>
      'Link ingredients to foods in the recipe editor to see nutrition values.';

  @override
  String get nutritionBasisPortion => 'Portion';

  @override
  String get nutritionBasisCustom => 'Custom';

  @override
  String get nutritionAmount => 'Amount';

  @override
  String nutritionDishWeighed(String weight) {
    return 'Dish $weight (weighed)';
  }

  @override
  String nutritionDishSum(String weight) {
    return 'Dish $weight (sum of ingredients)';
  }

  @override
  String nutritionPortionsOfAbout(int count, String weight) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count portions of about $weight',
      one: '1 portion of about $weight',
    );
    return '$_temp0';
  }

  @override
  String get nutritionLowerBound =>
      '* Some linked foods have no data for this value, so it is a lower bound.';

  @override
  String get nutritionSalt => 'Salt';

  @override
  String get nutritionVitaminsMinerals => 'Vitamins and minerals';

  @override
  String get nutritionDailyReferenceHint =>
      '% of the EU daily reference intake for adults';

  @override
  String get nutritionNotCounted => 'Not counted';

  @override
  String nutritionMissingNoFood(String name) {
    return '$name: no food linked';
  }

  @override
  String nutritionMissingNoWeight(String name, String unit) {
    return '$name: no gram weight for \"$unit\"';
  }

  @override
  String get nutritionOffUnreachable =>
      'Open Food Facts could not be reached. Check your internet connection.';

  @override
  String get nutritionUsdaUnreachable =>
      'USDA could not be reached. Check your internet connection.';

  @override
  String get nutritionIngredientsTitle => 'Ingredients';

  @override
  String get nutritionMyIngredientButton => 'My ingredient';

  @override
  String get nutritionBuiltIn => 'Built-in ingredients';

  @override
  String nutritionBuiltInCount(int count) {
    return 'Built-in ingredients: $count';
  }

  @override
  String get nutritionBuiltInSubtitle => 'USDA FoodData Central, works offline';

  @override
  String get nutritionUsdaOnline => 'USDA online lookup';

  @override
  String get apiKeyOriginDemo =>
      'Shared demo key, a few lookups per hour. Add your own free key for more.';

  @override
  String get apiKeyOriginDeveloper => 'Developer key from config/local.json';

  @override
  String get apiKeyOriginUser => 'Your own API key';

  @override
  String get apiKeyChange => 'Change';

  @override
  String get apiKeyAdd => 'Add key';

  @override
  String get nutritionMyIngredients => 'My ingredients';

  @override
  String get nutritionMyIngredientsEmpty =>
      'Add ingredients you cannot find, e.g. from a package label.';

  @override
  String get nutritionOnlineInRecipes => 'Online ingredients in your recipes';

  @override
  String foodAskingLatest(String source) {
    return 'Asking $source for the latest values…';
  }

  @override
  String get foodUsedInRecipes => 'used in recipes';

  @override
  String foodDeleteTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get foodDeleteUsed =>
      'Some recipes use this ingredient. They will show it as \"no food linked\" until you link another one.';

  @override
  String get foodDeleteUnused =>
      'The ingredient will be removed from this device.';

  @override
  String foodGone(String source) {
    return '$source no longer has this food';
  }

  @override
  String foodUpdated(String name) {
    return 'Updated \"$name\"';
  }

  @override
  String get nutritionPer100g => 'Per 100 g';

  @override
  String get nutritionPortions => 'Portions';

  @override
  String get foodCopyToMine => 'Copy to my ingredients';

  @override
  String get foodUpdating => 'Updating…';

  @override
  String foodUpdateFrom(String source) {
    return 'Update from $source';
  }

  @override
  String get foodNewTitle => 'New ingredient';

  @override
  String get foodEditTitle => 'Edit ingredient';

  @override
  String get foodName => 'Name';

  @override
  String get foodRequiredError => 'Required';

  @override
  String get foodNumberError => 'Number';

  @override
  String get foodNutritionPer100g => 'Nutrition per 100 g';

  @override
  String get foodNutritionHint =>
      'Copy the values from the package label. Leave unknown values empty.';

  @override
  String get foodOfWhichSaturates => 'of which saturates';

  @override
  String get foodOfWhichSugars => 'of which sugars';

  @override
  String get foodMoreNutrients => 'More nutrients';

  @override
  String get foodMoreNutrientsHint => 'Vitamins, minerals and cholesterol';

  @override
  String get foodPortionsHint =>
      'How much one unit weighs, so recipes can use cups, spoons or pieces.';

  @override
  String get foodQty => 'Qty';

  @override
  String get foodUnit => 'Unit';

  @override
  String get foodWeight => 'Weight';

  @override
  String get foodRemovePortion => 'Remove';

  @override
  String get foodAddPortion => 'Add portion';

  @override
  String apiKeyOpenInBrowser(String url) {
    return 'Open $url in your browser';
  }

  @override
  String get apiKeyRateLimited =>
      'You reached the hourly USDA limit for your key. Please try again later.';

  @override
  String get apiKeyRejected =>
      'USDA did not accept the API key. Check it in Ingredients > USDA online lookup.';

  @override
  String get apiKeyDemoLimitTitle => 'Out of free lookups';

  @override
  String get apiKeyDemoLimitIntro =>
      'Oh, hey there buddy, we see that you used up all the built-in USDA requests.';

  @override
  String get apiKeyDemoLimitSignupBefore =>
      'If you need more, you can sign up for your own free API key at ';

  @override
  String get apiKeyDemoLimitSignupAfter =>
      '. Once you register, you will receive your very own API key by email.';

  @override
  String get apiKeyDemoLimitEnterKey =>
      'You can then enter this key in the app to get more lookups.';

  @override
  String get apiKeyDemoLimitWarning =>
      'Do not forget: do not share your key publicly.';

  @override
  String get apiKeyNotNow => 'Not now';

  @override
  String get apiKeyGetKey => 'Get a key';

  @override
  String get apiKeyEnterMine => 'Enter my key';

  @override
  String get apiKeySaved => 'Your API key is saved';

  @override
  String get apiKeyRemoved => 'Your API key was removed';

  @override
  String get apiKeyDialogTitle => 'Your USDA API key';

  @override
  String get apiKeyLabel => 'API key';

  @override
  String get apiKeyStoredLocally =>
      'The key is stored only on this device. Do not share it publicly.';

  @override
  String get apiKeyGetFreeKey => 'Get a free key';

  @override
  String get apiKeyRemove => 'Remove key';

  @override
  String get pickerRecipeDetail => 'Recipe';

  @override
  String get pickerNoLongerAvailable =>
      'This ingredient is no longer available';

  @override
  String get pickerProductNotFound => 'Product not found';

  @override
  String pickerProductNotFoundBody(String code) {
    return 'Open Food Facts does not know the barcode $code yet. You can enter the values from the label instead.';
  }

  @override
  String get pickerCreateOwnButton => 'Create my own';

  @override
  String get pickerSearchHint => 'Search ingredients, e.g. \"flour wheat\"';

  @override
  String get pickerCreateOwn => 'Create my own ingredient';

  @override
  String get pickerCreateOwnSubtitle => 'Enter values from a package label';

  @override
  String get pickerScanBarcode => 'Scan a package barcode';

  @override
  String get pickerEnterBarcode => 'Enter a package barcode';

  @override
  String get pickerBarcodeSubtitle => 'Looks the product up in Open Food Facts';

  @override
  String pickerBarcodeCode(String code) {
    return 'Barcode $code';
  }

  @override
  String get pickerNothingLocal => 'Nothing found on this device';

  @override
  String get pickerSearchOnline => 'Search online';

  @override
  String pickerSearchOnlineFor(String query) {
    return 'Search online for \"$query\"';
  }

  @override
  String get pickerUsdaIngredients => 'USDA ingredients';

  @override
  String get pickerStoreProducts => 'Store products';

  @override
  String get pickerAskingUsda => 'Asking USDA, this can take a few seconds…';

  @override
  String get pickerAskingOff => 'Asking Open Food Facts…';

  @override
  String get pickerNoMoreOnline => 'No additional online results';

  @override
  String pickerUses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count recipes',
      one: 'In 1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get pickerOffAttribution =>
      'Product data from Open Food Facts, made by its contributors under the Open Database License (ODbL).';

  @override
  String get scannerTitle => 'Scan barcode';

  @override
  String get scannerTorch => 'Torch';

  @override
  String get scannerHint => 'Point the camera at the barcode on the package';

  @override
  String get scannerTypeNumber => 'Type the number';

  @override
  String get scannerPermissionDenied =>
      'Manja may not use the camera. Allow it in the phone settings, or type the number.';

  @override
  String get scannerCameraFailed => 'The camera could not be started.';

  @override
  String get scannerInvalidBarcode => 'A barcode has 8 to 14 digits';

  @override
  String get scannerDialogTitle => 'Package barcode';

  @override
  String get scannerLookUp => 'Look up';

  @override
  String get converterTitle => 'Unit converter';

  @override
  String get converterSwap => 'Swap units';

  @override
  String get converterIngredient => 'Ingredient';

  @override
  String get converterIngredientHint =>
      'Cups, spoons and millilitres weigh differently for every ingredient.';

  @override
  String get converterOther => 'Other…';

  @override
  String get converterPickIngredient =>
      'Pick an ingredient to convert between volume and weight.';

  @override
  String converterNoWeight(String unit, String food) {
    return 'There is no weight for \"$unit\" of $food.';
  }

  @override
  String get converterNoVolumeWeights =>
      'No volume weights known for this ingredient.';

  @override
  String get converterCommonEquivalents => 'Common equivalents';

  @override
  String converterTeaspoons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count teaspoons',
      one: '1 teaspoon',
    );
    return '$_temp0';
  }

  @override
  String converterTablespoons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tablespoons',
      one: '1 tablespoon',
    );
    return '$_temp0';
  }

  @override
  String get converterFlour => 'Flour';

  @override
  String get converterSugar => 'Sugar';

  @override
  String get converterPowderedSugar => 'Powdered sugar';

  @override
  String get converterButter => 'Butter';

  @override
  String get converterWater => 'Water';

  @override
  String get converterMilk => 'Milk';

  @override
  String get converterOliveOil => 'Olive oil';

  @override
  String get converterRice => 'Rice';

  @override
  String get converterHoney => 'Honey';

  @override
  String get converterSalt => 'Salt';

  @override
  String get converterOats => 'Oats';

  @override
  String get converterCocoa => 'Cocoa';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionApp => 'App';

  @override
  String get settingsSectionWheel => 'Wheel';

  @override
  String get settingsSectionKitchen => 'Kitchen';

  @override
  String get settingsSectionIngredients => 'Ingredients';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsAppearanceSubtitle => 'Theme, light and dark mode';

  @override
  String get settingsBackupSubtitle => 'Export or import your whole profile';

  @override
  String get settingsWheelLookSubtitle => 'Theme, photos, size, names';

  @override
  String get settingsRoundsSubtitle => 'When eaten dishes come back';

  @override
  String get settingsTagsSubtitle => 'Courses and your own groups of dishes';

  @override
  String get settingsConverterTitle => 'Unit converter';

  @override
  String get settingsConverterSubtitle => 'Cups, spoons, grams and millilitres';

  @override
  String get settingsIngredientsTitle => 'Ingredients & USDA key';

  @override
  String get settingsIngredientsSubtitle =>
      'Own ingredients, built-in data, online lookup';

  @override
  String get settingsAboutTitle => 'About Manja';

  @override
  String get settingsAboutSubtitle => 'License, source code and credits';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceAppTheme => 'App theme';

  @override
  String get appearanceMode => 'Mode';

  @override
  String get appearanceDevAlwaysDark => 'The Dev theme is always dark.';

  @override
  String get appearanceSystemHint =>
      'System follows the light or dark setting of your device.';

  @override
  String get backupTitle => 'Backup & move';

  @override
  String get backupPickTitle => 'Open a Manja profile';

  @override
  String get backupSaveTitle => 'Save your profile';

  @override
  String get backupShareSubject => 'Manja profile';

  @override
  String get backupSaved => 'Profile saved';

  @override
  String backupError(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String get backupNotAProfile => 'This is not a Manja profile.';

  @override
  String get backupNewerVersion =>
      'This profile was made by a newer version of the app. Please update first.';

  @override
  String backupRecipesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes added',
      one: '1 recipe added',
    );
    return '$_temp0';
  }

  @override
  String backupAddedSkipped(String added, int skipped) {
    return '$added, $skipped already there';
  }

  @override
  String get backupReplaceTitle => 'Replace everything?';

  @override
  String get backupReplaceText =>
      'All recipes, photos, meal history, own ingredients, pantry and settings on this device will be replaced by the profile. Your USDA key stays.';

  @override
  String get backupReplaceEverything => 'Replace everything';

  @override
  String get backupCancel => 'Cancel';

  @override
  String get backupExport => 'Export';

  @override
  String backupExportText(String extension) {
    return 'Puts your recipes, photos, own ingredients, pantry, meal history and settings into one $extension file. Use it as a backup or to move to another device. Your USDA key is never included.';
  }

  @override
  String get backupSaveToFile => 'Save to file';

  @override
  String get backupShare => 'Share';

  @override
  String get backupImport => 'Import';

  @override
  String backupImportText(String extension) {
    return 'Open a $extension file. You can add its recipes to yours or replace everything.';
  }

  @override
  String get backupOpenProfile => 'Open a profile';

  @override
  String get backupImportTitle => 'Import profile';

  @override
  String backupSavedOn(String date) {
    return 'Saved on $date';
  }

  @override
  String backupRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
    );
    return '$_temp0';
  }

  @override
  String backupPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String backupMealCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meals',
      one: '1 meal',
    );
    return '$_temp0';
  }

  @override
  String backupOwnIngredientCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count own ingredients',
      one: '1 own ingredient',
    );
    return '$_temp0';
  }

  @override
  String backupPantryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pantry items',
      one: '1 pantry item',
    );
    return '$_temp0';
  }

  @override
  String get backupSkipHint =>
      'When adding, recipes with a name you already have are skipped.';

  @override
  String get backupReplace => 'Replace';

  @override
  String get backupAdd => 'Add';

  @override
  String get wheelLookTitle => 'Wheel look';

  @override
  String get wheelLookTheme => 'Theme';

  @override
  String get wheelLookShow => 'Show on the wheel';

  @override
  String get wheelLookSize => 'Size';

  @override
  String wheelLookMaxSlices(int count) {
    return 'Recipes shown on the wheel: $count';
  }

  @override
  String get wheelLookMaxSlicesHint =>
      'With more recipes, one \"+n\" slice stands for the rest. Every recipe still has the same chance.';

  @override
  String wheelLookWinnerPercent(int percent) {
    return 'Winning dish takes $percent% of the wheel';
  }

  @override
  String wheelLookPercent(int percent) {
    return '$percent%';
  }

  @override
  String get wheelLookSpin => 'Spin';

  @override
  String wheelLookSpinTime(String seconds) {
    return 'Spin time: $seconds s';
  }

  @override
  String get wheelLookSpinTimeHint =>
      'How long the wheel turns before it stops';

  @override
  String wheelLookReveal(String seconds) {
    return 'Winner reveal: $seconds s';
  }

  @override
  String get wheelLookRevealHint =>
      'How long the chosen dish takes to grow on the wheel';

  @override
  String wheelLookSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get wheelLookNames => 'Names';

  @override
  String get wheelLookUpright => 'Keep names upright';

  @override
  String get wheelLookUprightHint =>
      'Turn names on the left half so they are never upside down';

  @override
  String get roundsTitle => 'Wheel rounds';

  @override
  String get roundsPutBack => 'Put eaten dishes back on the wheel';

  @override
  String roundsResetEvery(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reset every',
      one: 'Reset every',
    );
    return '$_temp0';
  }

  @override
  String get roundsFewerDays => 'Fewer days';

  @override
  String get roundsMoreDays => 'More days';

  @override
  String roundsDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String get roundsHistoryKept =>
      'Your meal history is always kept. A new round only puts the dishes back on the wheel.';

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsNew => 'New tag';

  @override
  String get tagsRenameTitle => 'Rename tag';

  @override
  String get tagsRename => 'Rename';

  @override
  String get tagsAdd => 'Add';

  @override
  String get tagsCancel => 'Cancel';

  @override
  String get tagsDelete => 'Delete';

  @override
  String tagsDeleteTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get tagsDeleteUnused => 'No recipe uses this tag.';

  @override
  String tagsDeleteUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'It is removed from $count recipes. The recipes themselves stay.',
      one: 'It is removed from 1 recipe. The recipes themselves stay.',
    );
    return '$_temp0';
  }

  @override
  String get tagsIntro =>
      'Tags group your recipes. Pick one above the wheel to spin only those. Drag to change the order.';

  @override
  String tagsRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get tagsIngredientHint =>
      'usable as ingredients, not on the wheel unless chosen';

  @override
  String get tagsNameHint => 'Quick weekday';

  @override
  String get cookbookTitle => 'Cookbook PDF';

  @override
  String get cookbookDefaultTitle => 'Manja cookbook';

  @override
  String get cookbookFallbackTitle => 'Cookbook';

  @override
  String get cookbookNoneSelected => 'No recipes selected';

  @override
  String cookbookCreate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Create PDF with $count recipes',
      one: 'Create PDF with 1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get cookbookTitleField => 'Title';

  @override
  String get cookbookLayout => 'Layout';

  @override
  String get cookbookRecipes => 'Recipes';

  @override
  String cookbookAll(int count) {
    return 'All recipes ($count)';
  }

  @override
  String cookbookFavorites(int count) {
    return 'Favorites ($count)';
  }

  @override
  String get cookbookTagged => 'Tagged';

  @override
  String cookbookChosen(int count) {
    return 'Chosen ($count)';
  }

  @override
  String get cookbookChoose => 'Choose';

  @override
  String get cookbookInclude => 'Include';

  @override
  String get cookbookCover => 'Cover page';

  @override
  String get cookbookContents => 'Table of contents';

  @override
  String get cookbookPhotos => 'Photos';

  @override
  String get cookbookNutrition => 'Nutrition per portion';

  @override
  String get cookbookNutritionHint =>
      'Only for recipes with linked ingredients';

  @override
  String cookbookChosenCount(int count) {
    return '$count chosen';
  }

  @override
  String get cookbookSelectNone => 'None';

  @override
  String get cookbookSelectAll => 'All';

  @override
  String get cookbookDone => 'Done';

  @override
  String get cookbookPreview => 'Preview';

  @override
  String get cookbookLayingOut => 'Laying out your cookbook…';

  @override
  String get cookbookLayoutClassic => 'Classic';

  @override
  String get cookbookLayoutClassicHint =>
      'A4, one recipe per page with a big photo';

  @override
  String get cookbookLayoutCompact => 'Compact';

  @override
  String get cookbookLayoutCompactHint =>
      'A4, recipes one after another, saves paper';

  @override
  String get cookbookLayoutCards => 'Recipe cards';

  @override
  String get cookbookLayoutCardsHint =>
      'A6 cards, one recipe each, easy to cut out';

  @override
  String get pdfNoRecipes => 'No recipes yet';

  @override
  String pdfRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get pdfMonths =>
      'January,February,March,April,May,June,July,August,September,October,November,December';

  @override
  String get pdfMadeWith => 'Made with Manja';

  @override
  String get pdfContents => 'Contents';

  @override
  String get pdfPerPortion => 'Per portion';

  @override
  String get pdfPerPortionAtLeast => 'Per portion, at least';

  @override
  String get pdfIngredients => 'Ingredients';

  @override
  String get pdfPreparation => 'Preparation';

  @override
  String get pdfNotes => 'Notes';

  @override
  String pdfSource(String host) {
    return 'Source: $host';
  }

  @override
  String pdfPage(String page) {
    return 'p. $page';
  }

  @override
  String pdfPortions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count portions',
      one: '1 portion',
    );
    return '$_temp0';
  }

  @override
  String pdfPrep(String time) {
    return 'Prep $time';
  }

  @override
  String pdfCook(String time) {
    return 'Cook $time';
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
  String get pdfProtein => 'protein';

  @override
  String get pdfFat => 'fat';

  @override
  String get pdfCarbohydrate => 'carbohydrate';

  @override
  String get pdfFiber => 'fiber';

  @override
  String get aboutLicense =>
      'Free software under the GNU Affero General Public License v3.0.';

  @override
  String aboutSource(String url) {
    return 'Source code: $url';
  }

  @override
  String get aboutTrademark =>
      'The name \"Manja\" and its logo are not covered by the license.';

  @override
  String get tagNameMain => 'Main';

  @override
  String get tagNameSoup => 'Soup';

  @override
  String get tagNameSide => 'Side or salad';

  @override
  String get tagNameBreakfast => 'Breakfast';

  @override
  String get tagNameDessert => 'Dessert';

  @override
  String get tagNameSnack => 'Snack';

  @override
  String get tagNameIngredient => 'Ingredient';
}
