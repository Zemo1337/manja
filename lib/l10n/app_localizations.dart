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

  /// Under a recipe used as an ingredient: weight of one portion, from the finished weight.
  ///
  /// In en, this message translates to:
  /// **'1 portion = {grams} g'**
  String recipeFoodPortion(String grams);

  /// Same, estimated from the raw ingredients.
  ///
  /// In en, this message translates to:
  /// **'1 portion ≈ {grams} g'**
  String recipeFoodPortionEstimate(String grams);

  /// A recipe used as an ingredient whose portion weight is unknown.
  ///
  /// In en, this message translates to:
  /// **'Weight of a portion unknown'**
  String get recipeFoodWeightUnknown;

  /// App bar title when creating a recipe.
  ///
  /// In en, this message translates to:
  /// **'New recipe'**
  String get recipeEditTitleNew;

  /// App bar title when editing a recipe.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get recipeEditTitleEdit;

  /// Button saving the recipe.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get recipeSave;

  /// Short label of the narrow ingredient amount field.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get recipeQty;

  /// Label of the ingredient unit dropdown (narrow).
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get recipeUnit;

  /// Label of the ingredient name field.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get recipeIngredient;

  /// How many recipes use a suggested ingredient name.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipe} other{{count} recipes}}'**
  String recipeSuggestionRecipes(int count);

  /// Chip that creates a new tag (category).
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get recipeNewTag;

  /// Button linking an ingredient to a nutrition database entry.
  ///
  /// In en, this message translates to:
  /// **'Link nutrition'**
  String get recipeLinkNutrition;

  /// Shown when the recipe linked as an ingredient was deleted.
  ///
  /// In en, this message translates to:
  /// **'Linked recipe (deleted)'**
  String get recipeLinkedRecipeDeleted;

  /// Shown when the linked food is not in the local database.
  ///
  /// In en, this message translates to:
  /// **'Linked ingredient (not on this device)'**
  String get recipeLinkedIngredientMissing;

  /// Warning when a recipe used as ingredient has no known portion weight.
  ///
  /// In en, this message translates to:
  /// **'The weight of a portion is unknown. Link the ingredients of \"{name}\" or enter its finished weight.'**
  String recipePortionWeightUnknown(String name);

  /// Warning when the chosen unit cannot be converted to grams for the linked food.
  ///
  /// In en, this message translates to:
  /// **'No gram weight for \"{unit}\". Use g or ml, or add a portion to the ingredient.'**
  String recipeNoGramWeight(String unit);

  /// Tooltip: pick a different linked food.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get recipeChangeLink;

  /// Tooltip: remove the nutrition link of an ingredient.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get recipeUnlink;

  /// Snackbar when picking a photo failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the photo: {error}'**
  String recipePhotoLoadError(String error);

  /// Button taking a recipe photo with the camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get recipeCamera;

  /// Button picking a recipe photo from the gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get recipeGallery;

  /// Button picking a recipe photo when there is no camera.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get recipeChoosePhoto;

  /// Button/tooltip removing a photo, ingredient, heading or step.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get recipeRemove;

  /// Validation error for an empty required field.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get recipeRequired;

  /// Validation error for a minutes field.
  ///
  /// In en, this message translates to:
  /// **'Whole minutes'**
  String get recipeWholeMinutes;

  /// Label of the recipe name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get recipeName;

  /// Label of the portions field and the portions stepper.
  ///
  /// In en, this message translates to:
  /// **'Portions'**
  String get recipePortions;

  /// Validation error for the portions field.
  ///
  /// In en, this message translates to:
  /// **'At least 1'**
  String get recipeAtLeastOne;

  /// Label of the narrow preparation time field (a third of the screen width).
  ///
  /// In en, this message translates to:
  /// **'Prep (min)'**
  String get recipePrepMinutes;

  /// Label of the narrow cooking time field (a third of the screen width).
  ///
  /// In en, this message translates to:
  /// **'Cook (min)'**
  String get recipeCookMinutes;

  /// Section title for the recipe's tags (categories).
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get recipeTags;

  /// Section title for the ingredient list; also tooltip opening the ingredients screen.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeIngredients;

  /// Button adding an ingredient row.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get recipeAddIngredient;

  /// Button adding an ingredient section heading.
  ///
  /// In en, this message translates to:
  /// **'Add heading'**
  String get recipeAddHeading;

  /// Label of the finished weight field.
  ///
  /// In en, this message translates to:
  /// **'Weight of the finished dish (optional)'**
  String get recipeFinishedWeight;

  /// Helper text of the finished weight field.
  ///
  /// In en, this message translates to:
  /// **'Cooking changes the weight. Weigh the dish for accurate per 100 g values.'**
  String get recipeFinishedWeightHelp;

  /// Validation error of the finished weight field.
  ///
  /// In en, this message translates to:
  /// **'Grams, e.g. 850'**
  String get recipeFinishedWeightInvalid;

  /// Label/section title for free cooking notes.
  ///
  /// In en, this message translates to:
  /// **'Cooking info'**
  String get recipeCookingInfo;

  /// Hint of the cooking info field.
  ///
  /// In en, this message translates to:
  /// **'Oven temperature, pan size, tips…'**
  String get recipeCookingInfoHint;

  /// Section title of the step list in the editor.
  ///
  /// In en, this message translates to:
  /// **'Preparation steps'**
  String get recipePreparationSteps;

  /// Button adding a preparation step.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get recipeAddStep;

  /// Semantics label of the drag handle.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get recipeDragToReorder;

  /// Label of an ingredient section heading field.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get recipeHeading;

  /// Hint with example ingredient section headings.
  ///
  /// In en, this message translates to:
  /// **'Dough, Topping, Sauce…'**
  String get recipeHeadingHint;

  /// Title of the delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe?'**
  String get recipeDeleteTitle;

  /// Body of the delete confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" and its meal history will be removed.'**
  String recipeDeleteMessage(String name);

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recipeCancel;

  /// Dialog button / tooltip deleting the recipe.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get recipeDelete;

  /// Tooltip editing the recipe.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get recipeEdit;

  /// Shown when the recipe no longer exists.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get recipeNotFound;

  /// Chip with the preparation time.
  ///
  /// In en, this message translates to:
  /// **'Prep {minutes} min'**
  String recipePrepChip(int minutes);

  /// Chip with the cooking time.
  ///
  /// In en, this message translates to:
  /// **'Cook {minutes} min'**
  String recipeCookChip(int minutes);

  /// Shown when a recipe has no ingredients.
  ///
  /// In en, this message translates to:
  /// **'No ingredients added.'**
  String get recipeNoIngredients;

  /// Section title of the nutrition values.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get recipeNutrition;

  /// Link to the website the recipe was imported from.
  ///
  /// In en, this message translates to:
  /// **'Source: {host}'**
  String recipeSource(String host);

  /// Section title of the steps on the recipe page.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get recipePreparation;

  /// Shown when a recipe has no steps.
  ///
  /// In en, this message translates to:
  /// **'No steps added.'**
  String get recipeNoSteps;

  /// Title of the recipe list.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipeListTitle;

  /// Tooltip opening the recipe import.
  ///
  /// In en, this message translates to:
  /// **'Import from link'**
  String get recipeImportFromLink;

  /// Tooltip opening the cookbook PDF export.
  ///
  /// In en, this message translates to:
  /// **'Cookbook PDF'**
  String get recipeCookbookPdf;

  /// Tooltip opening the unit converter.
  ///
  /// In en, this message translates to:
  /// **'Unit converter'**
  String get recipeUnitConverter;

  /// Button creating a new recipe.
  ///
  /// In en, this message translates to:
  /// **'Add recipe'**
  String get recipeAdd;

  /// Shown when there are no recipes; quotes the add button.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet. Tap \"Add recipe\" to start.'**
  String get recipeListEmpty;

  /// Hint of the recipe search bar.
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get recipeSearch;

  /// Number of portions in the recipe list.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 portion} other{{count} portions}}'**
  String recipePortionCount(int count);

  /// Total time in the recipe list.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeTotalMinutes(int minutes);

  /// Title of the import screen.
  ///
  /// In en, this message translates to:
  /// **'Import recipe'**
  String get recipeImportTitle;

  /// Label of the URL field.
  ///
  /// In en, this message translates to:
  /// **'Link to the recipe'**
  String get recipeImportUrlLabel;

  /// Tooltip pasting the link from the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get recipePaste;

  /// Button starting the import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get recipeImport;

  /// Error for an empty or invalid link.
  ///
  /// In en, this message translates to:
  /// **'Enter a link to a recipe page, for example https://www.coolinarika.com/recept/…'**
  String get recipeImportInvalidUrl;

  /// Error when the site's bot check never finished.
  ///
  /// In en, this message translates to:
  /// **'The site kept checking the browser. Try again later, or copy the recipe by hand.'**
  String get recipeImportBotCheckTimeout;

  /// Error when the page has no recipe data.
  ///
  /// In en, this message translates to:
  /// **'No recipe data found on this page. The site may not publish its recipes in a readable format.'**
  String get recipeImportNoRecipe;

  /// Progress while loading the page.
  ///
  /// In en, this message translates to:
  /// **'Reading the recipe from {host}…'**
  String recipeImportReading(String host);

  /// Progress while loading the page when the host is unknown.
  ///
  /// In en, this message translates to:
  /// **'Reading the recipe from the page…'**
  String get recipeImportReadingPage;

  /// Shown while the site shows a bot check.
  ///
  /// In en, this message translates to:
  /// **'The site wants to check that you are a person. Complete the check below.'**
  String get recipeImportChallenge;

  /// Progress while downloading the recipe photo.
  ///
  /// In en, this message translates to:
  /// **'Downloading the photo…'**
  String get recipeImportPhoto;

  /// Explanation below the import button.
  ///
  /// In en, this message translates to:
  /// **'Works with most recipe sites. You can check and change everything before saving.'**
  String get recipeImportHint;

  /// Import error.
  ///
  /// In en, this message translates to:
  /// **'The page did not load in time.'**
  String get recipeImportTimeout;

  /// Import error.
  ///
  /// In en, this message translates to:
  /// **'The page could not be reached. Check your internet connection.'**
  String get recipeImportUnreachable;

  /// Import error when the site refuses the download (desktop/tests).
  ///
  /// In en, this message translates to:
  /// **'This site blocks automatic downloads. Import it on your phone, where the page opens in a browser view.'**
  String get recipeImportBlocked;

  /// Import error with the HTTP status code.
  ///
  /// In en, this message translates to:
  /// **'The page answered with HTTP {status}.'**
  String recipeImportHttpError(int status);

  /// Bottom navigation label of the wheel tab.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get navWheel;

  /// Bottom navigation label of the recipes tab.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get navRecipes;

  /// Bottom navigation label of the history tab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Bottom navigation label of the settings tab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Snackbar after confirming the picked recipe.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your {recipe}!'**
  String wheelEnjoy(String recipe);

  /// Title of the dialog confirming a wheel reset.
  ///
  /// In en, this message translates to:
  /// **'Reset the wheel?'**
  String get wheelResetTitle;

  /// Body of the dialog confirming a wheel reset.
  ///
  /// In en, this message translates to:
  /// **'All recipes will be back on the wheel. Your meal history is kept.'**
  String get wheelResetMessage;

  /// Cancel button of the wheel reset dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get wheelCancel;

  /// Confirm button of the wheel reset dialog.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get wheelReset;

  /// Tooltip and button that puts all eaten dishes back on the wheel.
  ///
  /// In en, this message translates to:
  /// **'Reset wheel'**
  String get wheelResetWheel;

  /// Tooltip of the button opening the wheel appearance settings.
  ///
  /// In en, this message translates to:
  /// **'Wheel look'**
  String get wheelLook;

  /// Button/tooltip that removes the tag or pantry focus from the wheel.
  ///
  /// In en, this message translates to:
  /// **'Show all dishes'**
  String get wheelShowAll;

  /// Empty-state title when the filters hide every dish.
  ///
  /// In en, this message translates to:
  /// **'No dishes match your filters'**
  String get wheelNoFilterMatch;

  /// Empty-state message when the filters hide every dish.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dish is hidden by the filters.} other{{count} dishes are hidden by the filters.}}'**
  String wheelHiddenByFilters(int count);

  /// Button that switches all wheel filters off.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get wheelClearFilters;

  /// Empty-state title when no recipe has the selected tag.
  ///
  /// In en, this message translates to:
  /// **'Nothing tagged {tag}'**
  String wheelNothingTagged(String tag);

  /// Empty-state message when no recipe has the selected tag.
  ///
  /// In en, this message translates to:
  /// **'Add the tag to recipes in the recipe editor, or pick another tag.'**
  String get wheelNothingTaggedMessage;

  /// Empty-state title when there are no recipes at all.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get wheelNoRecipes;

  /// Empty-state message when there are no recipes at all.
  ///
  /// In en, this message translates to:
  /// **'Add your favourite dishes in the Recipes tab and they will show up here.'**
  String get wheelNoRecipesMessage;

  /// Title when every dish of this round was eaten.
  ///
  /// In en, this message translates to:
  /// **'You ate everything!'**
  String get wheelAllEaten;

  /// Title when every dish with the selected tag was eaten.
  ///
  /// In en, this message translates to:
  /// **'All {tag} dishes eaten'**
  String wheelAllTagEaten(String tag);

  /// Message when every dish of this round was eaten.
  ///
  /// In en, this message translates to:
  /// **'Every dish on the wheel has been cooked this round.'**
  String get wheelAllEatenMessage;

  /// Message when every dish with the selected tag was eaten.
  ///
  /// In en, this message translates to:
  /// **'Every dish tagged {tag} has been cooked this round.'**
  String wheelAllTagEatenMessage(String tag);

  /// Badge above the wheel when it only shows dishes from 'What can I cook?'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dish you can make now} other{{count} dishes you can make now}}'**
  String wheelCanMakeNow(int count);

  /// Badge above the wheel; may be prefixed with the tag name and ' · '.
  ///
  /// In en, this message translates to:
  /// **'{left} of {total} dishes left'**
  String wheelDishesLeft(int left, int total);

  /// Active-filter summary under the badge, first part.
  ///
  /// In en, this message translates to:
  /// **'Up to {kcal} kcal'**
  String wheelFilterUpToKcal(int kcal);

  /// Active-filter summary part, joined with ' · ' after the kcal part (hence lower case).
  ///
  /// In en, this message translates to:
  /// **'up to {minutes} min'**
  String wheelFilterUpToMinutes(int minutes);

  /// Active-filter summary part: number of dishes hidden by the filters.
  ///
  /// In en, this message translates to:
  /// **'{count} hidden'**
  String wheelFilterHidden(int count);

  /// Button that spins the wheel.
  ///
  /// In en, this message translates to:
  /// **'Spin'**
  String get wheelSpin;

  /// Spin button text while the wheel spins.
  ///
  /// In en, this message translates to:
  /// **'Spinning…'**
  String get wheelSpinning;

  /// Label above the picked recipe name.
  ///
  /// In en, this message translates to:
  /// **'Today you cook'**
  String get wheelTodayYouCook;

  /// Button to spin again after a result.
  ///
  /// In en, this message translates to:
  /// **'Spin again'**
  String get wheelSpinAgain;

  /// Button confirming the picked recipe (logs the meal).
  ///
  /// In en, this message translates to:
  /// **'Let\'s cook it'**
  String get wheelLetsCook;

  /// Tooltip of the filter button and title of the filter sheet.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get wheelFilters;

  /// Tag chip that shows dishes of every tag.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wheelAllTags;

  /// Calorie filter switch title when on.
  ///
  /// In en, this message translates to:
  /// **'Up to {kcal} kcal per portion'**
  String wheelFilterKcalOn(int kcal);

  /// Calorie filter switch title when off.
  ///
  /// In en, this message translates to:
  /// **'Calories per portion'**
  String get wheelFilterKcalOff;

  /// Calorie filter switch subtitle.
  ///
  /// In en, this message translates to:
  /// **'From the linked ingredients'**
  String get wheelFilterKcalHelp;

  /// Slider value label of the time filter.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String wheelMinutesValue(int minutes);

  /// Time filter switch title when on.
  ///
  /// In en, this message translates to:
  /// **'Ready in up to {minutes} min'**
  String wheelFilterMinutesOn(int minutes);

  /// Time filter switch title when off.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get wheelFilterMinutesOff;

  /// Time filter switch subtitle.
  ///
  /// In en, this message translates to:
  /// **'Prep and cooking together'**
  String get wheelFilterMinutesHelp;

  /// Filter switch title.
  ///
  /// In en, this message translates to:
  /// **'Include dishes with unknown values'**
  String get wheelFilterUnknown;

  /// Filter switch subtitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes without linked ingredients or times stay on the wheel'**
  String get wheelFilterUnknownHelp;

  /// Option: when the wheel refills.
  ///
  /// In en, this message translates to:
  /// **'When every dish was eaten'**
  String get wheelResetModeWhenEmpty;

  /// Option: when the wheel refills.
  ///
  /// In en, this message translates to:
  /// **'After a number of days'**
  String get wheelResetModeAfterDays;

  /// Option: when the wheel refills.
  ///
  /// In en, this message translates to:
  /// **'Only manually'**
  String get wheelResetModeManual;

  /// What the wheel slices show.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get wheelContentText;

  /// What the wheel slices show.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get wheelContentPhoto;

  /// What the wheel slices show.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get wheelContentBoth;

  /// Wheel theme name.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get wheelThemeClassic;

  /// Wheel theme name (looks like a pizza).
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get wheelThemePizza;

  /// Wheel theme name (looks like a burek).
  ///
  /// In en, this message translates to:
  /// **'Burek'**
  String get wheelThemeBurek;

  /// Wheel theme name (looks like a Sachertorte).
  ///
  /// In en, this message translates to:
  /// **'Sachertorte'**
  String get wheelThemeSacher;

  /// Wheel theme name (looks like baklava).
  ///
  /// In en, this message translates to:
  /// **'Baklava'**
  String get wheelThemeBaklava;

  /// App colour theme name; the app name, never translated.
  ///
  /// In en, this message translates to:
  /// **'Manja'**
  String get themeManja;

  /// Description of the Manja colour theme.
  ///
  /// In en, this message translates to:
  /// **'Paprika, basil and saffron'**
  String get themeManjaDescription;

  /// App colour theme name.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get themeNeutral;

  /// Description of the Neutral colour theme.
  ///
  /// In en, this message translates to:
  /// **'Calm slate and grey'**
  String get themeNeutralDescription;

  /// App colour theme name (developer style).
  ///
  /// In en, this message translates to:
  /// **'Dev'**
  String get themeDev;

  /// Description of the Dev colour theme.
  ///
  /// In en, this message translates to:
  /// **'Charcoal and yellow, always dark'**
  String get themeDevDescription;

  /// Brightness option: follow the system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeBrightnessSystem;

  /// Brightness option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeBrightnessLight;

  /// Brightness option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeBrightnessDark;

  /// Title of the meal history screen.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Header text of the date range picker.
  ///
  /// In en, this message translates to:
  /// **'Show meals from'**
  String get historyRangeHelp;

  /// Confirm button of the date range picker.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get historyRangeSave;

  /// Snackbar after swiping a meal away.
  ///
  /// In en, this message translates to:
  /// **'{recipe} removed from the history'**
  String historyRemoved(String recipe);

  /// Snackbar action restoring a removed meal.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get historyUndo;

  /// Shown when the history is empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing cooked yet. Spin the wheel!'**
  String get historyEmpty;

  /// Month section header, e.g. 'October 2026 · 3 meals'.
  ///
  /// In en, this message translates to:
  /// **'{month} · {count, plural, =1{1 meal} other{{count} meals}}'**
  String historyMonthHeader(String month, int count);

  /// Hint of the history search field.
  ///
  /// In en, this message translates to:
  /// **'Search dishes'**
  String get historySearchHint;

  /// Tooltip of the clear button in the search field.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get historyClearSearch;

  /// Tooltip of the date range button.
  ///
  /// In en, this message translates to:
  /// **'Pick dates'**
  String get historyPickDates;

  /// Summary when the search/date filter matches nothing.
  ///
  /// In en, this message translates to:
  /// **'No meals match'**
  String get historyNoMatch;

  /// Summary of the filtered meals; date is the most recent one.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meal on {date}} other{{count} meals, last on {date}}}'**
  String historyMatchSummary(int count, String date);

  /// Title of the pantry screen and tooltip of the wheel button opening it.
  ///
  /// In en, this message translates to:
  /// **'What can I cook?'**
  String get pantryTitle;

  /// Button putting only the dishes you can make on the wheel.
  ///
  /// In en, this message translates to:
  /// **'Spin with these {count}'**
  String pantrySpinWith(int count);

  /// Disabled spin button text; quotes the pantryOnWheel segment.
  ///
  /// In en, this message translates to:
  /// **'Switch to \"On the wheel\" to spin with these'**
  String get pantrySwitchToWheel;

  /// Section title: basics you always have.
  ///
  /// In en, this message translates to:
  /// **'Always at home'**
  String get pantryAlwaysAtHome;

  /// Hint of the always-at-home input.
  ///
  /// In en, this message translates to:
  /// **'Add a basic, e.g. olive oil'**
  String get pantryAddBasicHint;

  /// Shown while the always-at-home list is empty.
  ///
  /// In en, this message translates to:
  /// **'Add what you always have, like salt, oil or flour.'**
  String get pantryAlwaysEmpty;

  /// Comma-separated basics suggested as chips (no spaces after the commas); also never suggested as cravings.
  ///
  /// In en, this message translates to:
  /// **'Salt,Pepper,Oil,Flour,Sugar,Eggs,Milk,Butter,Onion,Garlic,Rice'**
  String get pantryStaples;

  /// Section title: ingredients you feel like today.
  ///
  /// In en, this message translates to:
  /// **'In the mood for'**
  String get pantryInTheMood;

  /// Hint of the in-the-mood input.
  ///
  /// In en, this message translates to:
  /// **'Add an ingredient, e.g. chicken'**
  String get pantryAddCravingHint;

  /// Shown while the in-the-mood list is empty.
  ///
  /// In en, this message translates to:
  /// **'Optional. Pick what you feel like today to only see dishes with it.'**
  String get pantryCravingEmpty;

  /// Segment: only match dishes currently on the wheel.
  ///
  /// In en, this message translates to:
  /// **'On the wheel'**
  String get pantryOnWheel;

  /// Segment: match all recipes.
  ///
  /// In en, this message translates to:
  /// **'All recipes'**
  String get pantryAllRecipes;

  /// Section title with the number of complete matches.
  ///
  /// In en, this message translates to:
  /// **'You can make ({count})'**
  String pantryCanMake(int count);

  /// Shown when nothing is entered yet.
  ///
  /// In en, this message translates to:
  /// **'Add what you have at home to see which dishes you can make.'**
  String get pantryEmptyHint;

  /// Shown when no dish can be made.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet with these ingredients.'**
  String get pantryNothingYet;

  /// Section title: dishes missing one or two ingredients.
  ///
  /// In en, this message translates to:
  /// **'Missing one or two ({count})'**
  String pantryMissingFew(int count);

  /// Tooltip of the add button in the pantry inputs.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get pantryAdd;

  /// Subtitle of a dish you can make.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{You have all {count} ingredients}}'**
  String pantryHaveAll(int count);

  /// Subtitle listing the missing ingredients, comma separated.
  ///
  /// In en, this message translates to:
  /// **'Missing: {items}'**
  String pantryMissing(String items);

  /// Nutrient name on nutrition tables (EU label wording).
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get nutrientEnergy;

  /// Nutrient name.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutrientProtein;

  /// Nutrient name.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutrientFat;

  /// Nutrient name; shown indented below fat.
  ///
  /// In en, this message translates to:
  /// **'Saturated fat'**
  String get nutrientSaturatedFat;

  /// Nutrient name.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrate'**
  String get nutrientCarbohydrate;

  /// Nutrient name; shown indented below carbohydrate.
  ///
  /// In en, this message translates to:
  /// **'Sugars'**
  String get nutrientSugars;

  /// Nutrient name (dietary fibre).
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get nutrientFiber;

  /// Nutrient name.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get nutrientSodium;

  /// Nutrient name.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get nutrientCholesterol;

  /// Mineral name.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get nutrientCalcium;

  /// Mineral name.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get nutrientIron;

  /// Mineral name.
  ///
  /// In en, this message translates to:
  /// **'Magnesium'**
  String get nutrientMagnesium;

  /// Mineral name.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get nutrientPotassium;

  /// Mineral name.
  ///
  /// In en, this message translates to:
  /// **'Zinc'**
  String get nutrientZinc;

  /// Vitamin name.
  ///
  /// In en, this message translates to:
  /// **'Vitamin A'**
  String get nutrientVitaminA;

  /// Vitamin name.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C'**
  String get nutrientVitaminC;

  /// Vitamin name.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D'**
  String get nutrientVitaminD;

  /// Vitamin name.
  ///
  /// In en, this message translates to:
  /// **'Vitamin E'**
  String get nutrientVitaminE;

  /// Vitamin name.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B12'**
  String get nutrientVitaminB12;

  /// Vitamin name (folate, EU label wording).
  ///
  /// In en, this message translates to:
  /// **'Folate'**
  String get nutrientFolate;

  /// Name of the source for ingredients the user entered.
  ///
  /// In en, this message translates to:
  /// **'My ingredients'**
  String get foodSourceUser;

  /// Name of the source for recipes used as ingredients.
  ///
  /// In en, this message translates to:
  /// **'My recipes'**
  String get foodSourceRecipe;

  /// Button closing a dialog without changes.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get nutritionCancel;

  /// Save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get nutritionSave;

  /// Delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get nutritionDelete;

  /// Button editing the user's own ingredient.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get nutritionEdit;

  /// Button repeating a failed online lookup.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get nutritionRetry;

  /// Shown in a recipe instead of nutrition values when no ingredient is linked to a food.
  ///
  /// In en, this message translates to:
  /// **'Link ingredients to foods in the recipe editor to see nutrition values.'**
  String get nutritionNoLinks;

  /// Segment: show nutrition per portion.
  ///
  /// In en, this message translates to:
  /// **'Portion'**
  String get nutritionBasisPortion;

  /// Segment: show nutrition for a weight the user types.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get nutritionBasisCustom;

  /// Field label for the custom weight in grams.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get nutritionAmount;

  /// Total weight of the finished dish, weighed by the user.
  ///
  /// In en, this message translates to:
  /// **'Dish {weight} (weighed)'**
  String nutritionDishWeighed(String weight);

  /// Total weight of the dish, added up from the ingredients.
  ///
  /// In en, this message translates to:
  /// **'Dish {weight} (sum of ingredients)'**
  String nutritionDishSum(String weight);

  /// Number of portions and the weight of one, e.g. "4 portions of about 250 g".
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 portion of about {weight}} other{{count} portions of about {weight}}}'**
  String nutritionPortionsOfAbout(int count, String weight);

  /// Footnote for values marked with *.
  ///
  /// In en, this message translates to:
  /// **'* Some linked foods have no data for this value, so it is a lower bound.'**
  String get nutritionLowerBound;

  /// Salt row of the nutrition table (EU label wording).
  ///
  /// In en, this message translates to:
  /// **'Salt'**
  String get nutritionSalt;

  /// Expandable section title.
  ///
  /// In en, this message translates to:
  /// **'Vitamins and minerals'**
  String get nutritionVitaminsMinerals;

  /// Explains the percentages in the vitamins and minerals section.
  ///
  /// In en, this message translates to:
  /// **'% of the EU daily reference intake for adults'**
  String get nutritionDailyReferenceHint;

  /// Card title listing recipe ingredients left out of the nutrition values.
  ///
  /// In en, this message translates to:
  /// **'Not counted'**
  String get nutritionNotCounted;

  /// An ingredient line without a linked food.
  ///
  /// In en, this message translates to:
  /// **'{name}: no food linked'**
  String nutritionMissingNoFood(String name);

  /// An ingredient line whose unit cannot be turned into grams.
  ///
  /// In en, this message translates to:
  /// **'{name}: no gram weight for \"{unit}\"'**
  String nutritionMissingNoWeight(String name, String unit);

  /// Error message.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts could not be reached. Check your internet connection.'**
  String get nutritionOffUnreachable;

  /// Error message.
  ///
  /// In en, this message translates to:
  /// **'USDA could not be reached. Check your internet connection.'**
  String get nutritionUsdaUnreachable;

  /// Title of the ingredients (food database) screen.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get nutritionIngredientsTitle;

  /// Button adding an own ingredient.
  ///
  /// In en, this message translates to:
  /// **'My ingredient'**
  String get nutritionMyIngredientButton;

  /// Title of the offline ingredient database entry.
  ///
  /// In en, this message translates to:
  /// **'Built-in ingredients'**
  String get nutritionBuiltIn;

  /// Title of the offline ingredient database with its size.
  ///
  /// In en, this message translates to:
  /// **'Built-in ingredients: {count}'**
  String nutritionBuiltInCount(int count);

  /// Subtitle of the offline ingredient database.
  ///
  /// In en, this message translates to:
  /// **'USDA FoodData Central, works offline'**
  String get nutritionBuiltInSubtitle;

  /// Settings entry for searching USDA online.
  ///
  /// In en, this message translates to:
  /// **'USDA online lookup'**
  String get nutritionUsdaOnline;

  /// Which USDA API key is used.
  ///
  /// In en, this message translates to:
  /// **'Shared demo key, a few lookups per hour. Add your own free key for more.'**
  String get apiKeyOriginDemo;

  /// Which USDA API key is used.
  ///
  /// In en, this message translates to:
  /// **'Developer key from config/local.json'**
  String get apiKeyOriginDeveloper;

  /// Which USDA API key is used.
  ///
  /// In en, this message translates to:
  /// **'Your own API key'**
  String get apiKeyOriginUser;

  /// Button changing the API key.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get apiKeyChange;

  /// Button adding an API key.
  ///
  /// In en, this message translates to:
  /// **'Add key'**
  String get apiKeyAdd;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'My ingredients'**
  String get nutritionMyIngredients;

  /// Shown when the user has no own ingredients.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients you cannot find, e.g. from a package label.'**
  String get nutritionMyIngredientsEmpty;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Online ingredients in your recipes'**
  String get nutritionOnlineInRecipes;

  /// Shown while a food is refreshed online.
  ///
  /// In en, this message translates to:
  /// **'Asking {source} for the latest values…'**
  String foodAskingLatest(String source);

  /// Subtitle of a food.
  ///
  /// In en, this message translates to:
  /// **'used in recipes'**
  String get foodUsedInRecipes;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String foodDeleteTitle(String name);

  /// Delete dialog text when recipes use the ingredient.
  ///
  /// In en, this message translates to:
  /// **'Some recipes use this ingredient. They will show it as \"no food linked\" until you link another one.'**
  String get foodDeleteUsed;

  /// Delete dialog text.
  ///
  /// In en, this message translates to:
  /// **'The ingredient will be removed from this device.'**
  String get foodDeleteUnused;

  /// Snackbar after refreshing a food that no longer exists online.
  ///
  /// In en, this message translates to:
  /// **'{source} no longer has this food'**
  String foodGone(String source);

  /// Snackbar after refreshing a food.
  ///
  /// In en, this message translates to:
  /// **'Updated \"{name}\"'**
  String foodUpdated(String name);

  /// Heading of a food's nutrition values.
  ///
  /// In en, this message translates to:
  /// **'Per 100 g'**
  String get nutritionPer100g;

  /// Heading of a food's portion weights.
  ///
  /// In en, this message translates to:
  /// **'Portions'**
  String get nutritionPortions;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Copy to my ingredients'**
  String get foodCopyToMine;

  /// Button while a food is refreshed.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get foodUpdating;

  /// Button refreshing a food from its online source.
  ///
  /// In en, this message translates to:
  /// **'Update from {source}'**
  String foodUpdateFrom(String source);

  /// Screen title.
  ///
  /// In en, this message translates to:
  /// **'New ingredient'**
  String get foodNewTitle;

  /// Screen title.
  ///
  /// In en, this message translates to:
  /// **'Edit ingredient'**
  String get foodEditTitle;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get foodName;

  /// Validation error for an empty required field.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get foodRequiredError;

  /// Validation error: the field needs a number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get foodNumberError;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Nutrition per 100 g'**
  String get foodNutritionPer100g;

  /// Hint below the section title.
  ///
  /// In en, this message translates to:
  /// **'Copy the values from the package label. Leave unknown values empty.'**
  String get foodNutritionHint;

  /// Field label, indented below fat (EU label wording).
  ///
  /// In en, this message translates to:
  /// **'of which saturates'**
  String get foodOfWhichSaturates;

  /// Field label, indented below carbohydrate (EU label wording).
  ///
  /// In en, this message translates to:
  /// **'of which sugars'**
  String get foodOfWhichSugars;

  /// Expandable section title.
  ///
  /// In en, this message translates to:
  /// **'More nutrients'**
  String get foodMoreNutrients;

  /// Subtitle of the expandable section.
  ///
  /// In en, this message translates to:
  /// **'Vitamins, minerals and cholesterol'**
  String get foodMoreNutrientsHint;

  /// Hint below the portions title.
  ///
  /// In en, this message translates to:
  /// **'How much one unit weighs, so recipes can use cups, spoons or pieces.'**
  String get foodPortionsHint;

  /// Short field label for the portion amount (narrow field).
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get foodQty;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get foodUnit;

  /// Field label for the portion weight in grams.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get foodWeight;

  /// Tooltip of the button removing a portion row.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get foodRemovePortion;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Add portion'**
  String get foodAddPortion;

  /// Snackbar when the link cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'Open {url} in your browser'**
  String apiKeyOpenInBrowser(String url);

  /// Error message.
  ///
  /// In en, this message translates to:
  /// **'You reached the hourly USDA limit for your key. Please try again later.'**
  String get apiKeyRateLimited;

  /// Error message; the path names the ingredients screen and its USDA entry.
  ///
  /// In en, this message translates to:
  /// **'USDA did not accept the API key. Check it in Ingredients > USDA online lookup.'**
  String get apiKeyRejected;

  /// Dialog title when the shared demo key is used up.
  ///
  /// In en, this message translates to:
  /// **'Out of free lookups'**
  String get apiKeyDemoLimitTitle;

  /// Casual, friendly dialog text.
  ///
  /// In en, this message translates to:
  /// **'Oh, hey there buddy, we see that you used up all the built-in USDA requests.'**
  String get apiKeyDemoLimitIntro;

  /// Text before the link api.data.gov/signup; ends with a space.
  ///
  /// In en, this message translates to:
  /// **'If you need more, you can sign up for your own free API key at '**
  String get apiKeyDemoLimitSignupBefore;

  /// Text right after the link api.data.gov/signup; starts with the character following the link.
  ///
  /// In en, this message translates to:
  /// **'. Once you register, you will receive your very own API key by email.'**
  String get apiKeyDemoLimitSignupAfter;

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'You can then enter this key in the app to get more lookups.'**
  String get apiKeyDemoLimitEnterKey;

  /// Bold warning in the dialog.
  ///
  /// In en, this message translates to:
  /// **'Do not forget: do not share your key publicly.'**
  String get apiKeyDemoLimitWarning;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get apiKeyNotNow;

  /// Dialog button opening the signup page.
  ///
  /// In en, this message translates to:
  /// **'Get a key'**
  String get apiKeyGetKey;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Enter my key'**
  String get apiKeyEnterMine;

  /// Snackbar.
  ///
  /// In en, this message translates to:
  /// **'Your API key is saved'**
  String get apiKeySaved;

  /// Snackbar.
  ///
  /// In en, this message translates to:
  /// **'Your API key was removed'**
  String get apiKeyRemoved;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Your USDA API key'**
  String get apiKeyDialogTitle;

  /// Field label.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get apiKeyLabel;

  /// Hint below the key field.
  ///
  /// In en, this message translates to:
  /// **'The key is stored only on this device. Do not share it publicly.'**
  String get apiKeyStoredLocally;

  /// Button opening the signup page.
  ///
  /// In en, this message translates to:
  /// **'Get a free key'**
  String get apiKeyGetFreeKey;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Remove key'**
  String get apiKeyRemove;

  /// Subtitle marking a recipe used as an ingredient.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get pickerRecipeDetail;

  /// Snackbar.
  ///
  /// In en, this message translates to:
  /// **'This ingredient is no longer available'**
  String get pickerNoLongerAvailable;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get pickerProductNotFound;

  /// Dialog text after scanning an unknown barcode.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts does not know the barcode {code} yet. You can enter the values from the label instead.'**
  String pickerProductNotFoundBody(String code);

  /// Dialog button creating an own ingredient.
  ///
  /// In en, this message translates to:
  /// **'Create my own'**
  String get pickerCreateOwnButton;

  /// Search field hint.
  ///
  /// In en, this message translates to:
  /// **'Search ingredients, e.g. \"flour wheat\"'**
  String get pickerSearchHint;

  /// List entry.
  ///
  /// In en, this message translates to:
  /// **'Create my own ingredient'**
  String get pickerCreateOwn;

  /// List entry subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter values from a package label'**
  String get pickerCreateOwnSubtitle;

  /// List entry.
  ///
  /// In en, this message translates to:
  /// **'Scan a package barcode'**
  String get pickerScanBarcode;

  /// List entry on devices without a camera scanner.
  ///
  /// In en, this message translates to:
  /// **'Enter a package barcode'**
  String get pickerEnterBarcode;

  /// List entry subtitle.
  ///
  /// In en, this message translates to:
  /// **'Looks the product up in Open Food Facts'**
  String get pickerBarcodeSubtitle;

  /// Shows the scanned barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode {code}'**
  String pickerBarcodeCode(String code);

  /// Shown when the local search has no results.
  ///
  /// In en, this message translates to:
  /// **'Nothing found on this device'**
  String get pickerNothingLocal;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Search online'**
  String get pickerSearchOnline;

  /// Section title with the search text.
  ///
  /// In en, this message translates to:
  /// **'Search online for \"{query}\"'**
  String pickerSearchOnlineFor(String query);

  /// Button searching USDA.
  ///
  /// In en, this message translates to:
  /// **'USDA ingredients'**
  String get pickerUsdaIngredients;

  /// Button searching Open Food Facts.
  ///
  /// In en, this message translates to:
  /// **'Store products'**
  String get pickerStoreProducts;

  /// Progress text.
  ///
  /// In en, this message translates to:
  /// **'Asking USDA, this can take a few seconds…'**
  String get pickerAskingUsda;

  /// Progress text.
  ///
  /// In en, this message translates to:
  /// **'Asking Open Food Facts…'**
  String get pickerAskingOff;

  /// Shown when the online search finds nothing new.
  ///
  /// In en, this message translates to:
  /// **'No additional online results'**
  String get pickerNoMoreOnline;

  /// How many recipes use a food.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{In 1 recipe} other{In {count} recipes}}'**
  String pickerUses(int count);

  /// Required attribution; keep "Open Database License (ODbL)".
  ///
  /// In en, this message translates to:
  /// **'Product data from Open Food Facts, made by its contributors under the Open Database License (ODbL).'**
  String get pickerOffAttribution;

  /// Screen title.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scannerTitle;

  /// Tooltip of the flashlight button.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get scannerTorch;

  /// Hint over the camera view.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the barcode on the package'**
  String get scannerHint;

  /// Button to enter the barcode by hand.
  ///
  /// In en, this message translates to:
  /// **'Type the number'**
  String get scannerTypeNumber;

  /// Error text.
  ///
  /// In en, this message translates to:
  /// **'Manja may not use the camera. Allow it in the phone settings, or type the number.'**
  String get scannerPermissionDenied;

  /// Error text.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be started.'**
  String get scannerCameraFailed;

  /// Validation error.
  ///
  /// In en, this message translates to:
  /// **'A barcode has 8 to 14 digits'**
  String get scannerInvalidBarcode;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Package barcode'**
  String get scannerDialogTitle;

  /// Dialog button looking up the barcode.
  ///
  /// In en, this message translates to:
  /// **'Look up'**
  String get scannerLookUp;

  /// Screen title.
  ///
  /// In en, this message translates to:
  /// **'Unit converter'**
  String get converterTitle;

  /// Tooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap units'**
  String get converterSwap;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get converterIngredient;

  /// Hint below the section title.
  ///
  /// In en, this message translates to:
  /// **'Cups, spoons and millilitres weigh differently for every ingredient.'**
  String get converterIngredientHint;

  /// Chip opening the ingredient search.
  ///
  /// In en, this message translates to:
  /// **'Other…'**
  String get converterOther;

  /// Error text.
  ///
  /// In en, this message translates to:
  /// **'Pick an ingredient to convert between volume and weight.'**
  String get converterPickIngredient;

  /// Error text; food is a food name from the database.
  ///
  /// In en, this message translates to:
  /// **'There is no weight for \"{unit}\" of {food}.'**
  String converterNoWeight(String unit, String food);

  /// Shown when a food has no volume data.
  ///
  /// In en, this message translates to:
  /// **'No volume weights known for this ingredient.'**
  String get converterNoVolumeWeights;

  /// Table title.
  ///
  /// In en, this message translates to:
  /// **'Common equivalents'**
  String get converterCommonEquivalents;

  /// Teaspoon count in the equivalents table.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 teaspoon} other{{count} teaspoons}}'**
  String converterTeaspoons(int count);

  /// Tablespoon count in the equivalents table.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tablespoon} other{{count} tablespoons}}'**
  String converterTablespoons(int count);

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Flour'**
  String get converterFlour;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get converterSugar;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Powdered sugar'**
  String get converterPowderedSugar;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get converterButter;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get converterWater;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get converterMilk;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
  String get converterOliveOil;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get converterRice;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get converterHoney;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Salt'**
  String get converterSalt;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Oats'**
  String get converterOats;

  /// Quick-pick ingredient chip.
  ///
  /// In en, this message translates to:
  /// **'Cocoa'**
  String get converterCocoa;

  /// Title of the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get settingsSectionApp;

  /// Settings section title for the meal wheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get settingsSectionWheel;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get settingsSectionKitchen;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get settingsSectionIngredients;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// Subtitle of the appearance entry.
  ///
  /// In en, this message translates to:
  /// **'Theme, light and dark mode'**
  String get settingsAppearanceSubtitle;

  /// Subtitle of the backup entry.
  ///
  /// In en, this message translates to:
  /// **'Export or import your whole profile'**
  String get settingsBackupSubtitle;

  /// Subtitle of the wheel look entry.
  ///
  /// In en, this message translates to:
  /// **'Theme, photos, size, names'**
  String get settingsWheelLookSubtitle;

  /// Subtitle of the wheel rounds entry.
  ///
  /// In en, this message translates to:
  /// **'When eaten dishes come back'**
  String get settingsRoundsSubtitle;

  /// Subtitle of the tags entry.
  ///
  /// In en, this message translates to:
  /// **'Courses and your own groups of dishes'**
  String get settingsTagsSubtitle;

  /// Settings entry for the unit converter.
  ///
  /// In en, this message translates to:
  /// **'Unit converter'**
  String get settingsConverterTitle;

  /// Subtitle of the unit converter entry.
  ///
  /// In en, this message translates to:
  /// **'Cups, spoons, grams and millilitres'**
  String get settingsConverterSubtitle;

  /// Settings entry for own ingredients and the USDA API key.
  ///
  /// In en, this message translates to:
  /// **'Ingredients & USDA key'**
  String get settingsIngredientsTitle;

  /// Subtitle of the ingredients entry.
  ///
  /// In en, this message translates to:
  /// **'Own ingredients, built-in data, online lookup'**
  String get settingsIngredientsSubtitle;

  /// Settings entry that opens the about and license page.
  ///
  /// In en, this message translates to:
  /// **'About Manja'**
  String get settingsAboutTitle;

  /// Subtitle of the about entry.
  ///
  /// In en, this message translates to:
  /// **'License, source code and credits'**
  String get settingsAboutSubtitle;

  /// Title of the appearance screen and its settings entry.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// Section title for the app colour theme.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get appearanceAppTheme;

  /// Section title for light/dark mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get appearanceMode;

  /// Hint when the Dev theme is chosen.
  ///
  /// In en, this message translates to:
  /// **'The Dev theme is always dark.'**
  String get appearanceDevAlwaysDark;

  /// Explains the System mode option.
  ///
  /// In en, this message translates to:
  /// **'System follows the light or dark setting of your device.'**
  String get appearanceSystemHint;

  /// Title of the backup screen and its settings entry.
  ///
  /// In en, this message translates to:
  /// **'Backup & move'**
  String get backupTitle;

  /// File picker dialog title.
  ///
  /// In en, this message translates to:
  /// **'Open a Manja profile'**
  String get backupPickTitle;

  /// Save file dialog title.
  ///
  /// In en, this message translates to:
  /// **'Save your profile'**
  String get backupSaveTitle;

  /// Subject when sharing the profile file.
  ///
  /// In en, this message translates to:
  /// **'Manja profile'**
  String get backupShareSubject;

  /// Snackbar after saving the profile file.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get backupSaved;

  /// Snackbar for an unexpected error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String backupError(String error);

  /// Error when the opened file is not a profile.
  ///
  /// In en, this message translates to:
  /// **'This is not a Manja profile.'**
  String get backupNotAProfile;

  /// Error when the profile comes from a newer app version.
  ///
  /// In en, this message translates to:
  /// **'This profile was made by a newer version of the app. Please update first.'**
  String get backupNewerVersion;

  /// Snackbar after importing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipe added} other{{count} recipes added}}'**
  String backupRecipesAdded(int count);

  /// Snackbar after importing when some recipes were skipped; added is the backupRecipesAdded text.
  ///
  /// In en, this message translates to:
  /// **'{added}, {skipped} already there'**
  String backupAddedSkipped(String added, int skipped);

  /// Confirm dialog title before replacing all data.
  ///
  /// In en, this message translates to:
  /// **'Replace everything?'**
  String get backupReplaceTitle;

  /// Confirm dialog text before replacing all data.
  ///
  /// In en, this message translates to:
  /// **'All recipes, photos, meal history, own ingredients, pantry and settings on this device will be replaced by the profile. Your USDA key stays.'**
  String get backupReplaceText;

  /// Confirm button that replaces all data.
  ///
  /// In en, this message translates to:
  /// **'Replace everything'**
  String get backupReplaceEverything;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get backupCancel;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get backupExport;

  /// Explains the export; extension is the file extension, e.g. ".manja".
  ///
  /// In en, this message translates to:
  /// **'Puts your recipes, photos, own ingredients, pantry, meal history and settings into one {extension} file. Use it as a backup or to move to another device. Your USDA key is never included.'**
  String backupExportText(String extension);

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Save to file'**
  String get backupSaveToFile;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get backupShare;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get backupImport;

  /// Explains the import; extension is the file extension, e.g. ".manja".
  ///
  /// In en, this message translates to:
  /// **'Open a {extension} file. You can add its recipes to yours or replace everything.'**
  String backupImportText(String extension);

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Open a profile'**
  String get backupOpenProfile;

  /// Import dialog title.
  ///
  /// In en, this message translates to:
  /// **'Import profile'**
  String get backupImportTitle;

  /// When the profile was exported; date is already formatted.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String backupSavedOn(String date);

  /// Number of recipes in the profile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipe} other{{count} recipes}}'**
  String backupRecipeCount(int count);

  /// Number of photos in the profile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String backupPhotoCount(int count);

  /// Number of meals in the history of the profile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 meal} other{{count} meals}}'**
  String backupMealCount(int count);

  /// Number of own ingredients in the profile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 own ingredient} other{{count} own ingredients}}'**
  String backupOwnIngredientCount(int count);

  /// Number of pantry items in the profile.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pantry item} other{{count} pantry items}}'**
  String backupPantryCount(int count);

  /// Hint in the import dialog.
  ///
  /// In en, this message translates to:
  /// **'When adding, recipes with a name you already have are skipped.'**
  String get backupSkipHint;

  /// Import dialog button: replace everything.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get backupReplace;

  /// Import dialog button: add recipes to the existing ones.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get backupAdd;

  /// Title of the wheel look screen and its settings entry.
  ///
  /// In en, this message translates to:
  /// **'Wheel look'**
  String get wheelLookTitle;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get wheelLookTheme;

  /// Section title: what is shown on the slices.
  ///
  /// In en, this message translates to:
  /// **'Show on the wheel'**
  String get wheelLookShow;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get wheelLookSize;

  /// Slider title.
  ///
  /// In en, this message translates to:
  /// **'Recipes shown on the wheel: {count}'**
  String wheelLookMaxSlices(int count);

  /// Explains the max slices slider.
  ///
  /// In en, this message translates to:
  /// **'With more recipes, one \"+n\" slice stands for the rest. Every recipe still has the same chance.'**
  String get wheelLookMaxSlicesHint;

  /// Slider title.
  ///
  /// In en, this message translates to:
  /// **'Winning dish takes {percent}% of the wheel'**
  String wheelLookWinnerPercent(int percent);

  /// Slider value label.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String wheelLookPercent(int percent);

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Spin'**
  String get wheelLookSpin;

  /// Slider title; seconds is already formatted.
  ///
  /// In en, this message translates to:
  /// **'Spin time: {seconds} s'**
  String wheelLookSpinTime(String seconds);

  /// Explains the spin time slider.
  ///
  /// In en, this message translates to:
  /// **'How long the wheel turns before it stops'**
  String get wheelLookSpinTimeHint;

  /// Slider title; seconds is already formatted.
  ///
  /// In en, this message translates to:
  /// **'Winner reveal: {seconds} s'**
  String wheelLookReveal(String seconds);

  /// Explains the reveal slider.
  ///
  /// In en, this message translates to:
  /// **'How long the chosen dish takes to grow on the wheel'**
  String get wheelLookRevealHint;

  /// Slider value label; seconds is already formatted.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String wheelLookSeconds(String seconds);

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Names'**
  String get wheelLookNames;

  /// Switch title.
  ///
  /// In en, this message translates to:
  /// **'Keep names upright'**
  String get wheelLookUpright;

  /// Switch subtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn names on the left half so they are never upside down'**
  String get wheelLookUprightHint;

  /// Title of the wheel rounds screen and its settings entry.
  ///
  /// In en, this message translates to:
  /// **'Wheel rounds'**
  String get roundsTitle;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Put eaten dishes back on the wheel'**
  String get roundsPutBack;

  /// Text before the number of days: "Reset every [3] days".
  ///
  /// In en, this message translates to:
  /// **'Reset every'**
  String get roundsResetEvery;

  /// Tooltip.
  ///
  /// In en, this message translates to:
  /// **'Fewer days'**
  String get roundsFewerDays;

  /// Tooltip.
  ///
  /// In en, this message translates to:
  /// **'More days'**
  String get roundsMoreDays;

  /// Word after the number of days (the number is shown separately).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String roundsDays(int count);

  /// Hint at the bottom.
  ///
  /// In en, this message translates to:
  /// **'Your meal history is always kept. A new round only puts the dishes back on the wheel.'**
  String get roundsHistoryKept;

  /// Title of the tags screen and its settings entry.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// Button and dialog title.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get tagsNew;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Rename tag'**
  String get tagsRenameTitle;

  /// Button and tooltip.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get tagsRename;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get tagsAdd;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tagsCancel;

  /// Button and tooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tagsDelete;

  /// Confirm dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String tagsDeleteTitle(String name);

  /// Confirm dialog text.
  ///
  /// In en, this message translates to:
  /// **'No recipe uses this tag.'**
  String get tagsDeleteUnused;

  /// Confirm dialog text.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{It is removed from 1 recipe. The recipes themselves stay.} other{It is removed from {count} recipes. The recipes themselves stay.}}'**
  String tagsDeleteUsed(int count);

  /// Header text.
  ///
  /// In en, this message translates to:
  /// **'Tags group your recipes. Pick one above the wheel to spin only those. Drag to change the order.'**
  String get tagsIntro;

  /// Number of recipes with the tag.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipe} other{{count} recipes}}'**
  String tagsRecipeCount(int count);

  /// Subtitle part for ingredient tags (e.g. sauces).
  ///
  /// In en, this message translates to:
  /// **'usable as ingredients, not on the wheel unless chosen'**
  String get tagsIngredientHint;

  /// Example tag name in the name field.
  ///
  /// In en, this message translates to:
  /// **'Quick weekday'**
  String get tagsNameHint;

  /// Title of the cookbook screen.
  ///
  /// In en, this message translates to:
  /// **'Cookbook PDF'**
  String get cookbookTitle;

  /// Default title of the cookbook.
  ///
  /// In en, this message translates to:
  /// **'Manja cookbook'**
  String get cookbookDefaultTitle;

  /// Title used when the title field is empty.
  ///
  /// In en, this message translates to:
  /// **'Cookbook'**
  String get cookbookFallbackTitle;

  /// Disabled create button.
  ///
  /// In en, this message translates to:
  /// **'No recipes selected'**
  String get cookbookNoneSelected;

  /// Create button.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Create PDF with 1 recipe} other{Create PDF with {count} recipes}}'**
  String cookbookCreate(int count);

  /// Label of the title field.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get cookbookTitleField;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get cookbookLayout;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get cookbookRecipes;

  /// Selection option.
  ///
  /// In en, this message translates to:
  /// **'All recipes ({count})'**
  String cookbookAll(int count);

  /// Selection option.
  ///
  /// In en, this message translates to:
  /// **'Favorites ({count})'**
  String cookbookFavorites(int count);

  /// Selection option: recipes with the chosen tag.
  ///
  /// In en, this message translates to:
  /// **'Tagged'**
  String get cookbookTagged;

  /// Selection option.
  ///
  /// In en, this message translates to:
  /// **'Chosen ({count})'**
  String cookbookChosen(int count);

  /// Button that opens the recipe chooser.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get cookbookChoose;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get cookbookInclude;

  /// Switch.
  ///
  /// In en, this message translates to:
  /// **'Cover page'**
  String get cookbookCover;

  /// Switch.
  ///
  /// In en, this message translates to:
  /// **'Table of contents'**
  String get cookbookContents;

  /// Switch.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get cookbookPhotos;

  /// Switch.
  ///
  /// In en, this message translates to:
  /// **'Nutrition per portion'**
  String get cookbookNutrition;

  /// Switch subtitle.
  ///
  /// In en, this message translates to:
  /// **'Only for recipes with linked ingredients'**
  String get cookbookNutritionHint;

  /// Title of the recipe chooser.
  ///
  /// In en, this message translates to:
  /// **'{count} chosen'**
  String cookbookChosenCount(int count);

  /// Header button: deselect all.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get cookbookSelectNone;

  /// Header button: select all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get cookbookSelectAll;

  /// Header button.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get cookbookDone;

  /// Title of the PDF preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get cookbookPreview;

  /// Shown while the PDF is built.
  ///
  /// In en, this message translates to:
  /// **'Laying out your cookbook…'**
  String get cookbookLayingOut;

  /// Layout name.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get cookbookLayoutClassic;

  /// Layout description.
  ///
  /// In en, this message translates to:
  /// **'A4, one recipe per page with a big photo'**
  String get cookbookLayoutClassicHint;

  /// Layout name.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get cookbookLayoutCompact;

  /// Layout description.
  ///
  /// In en, this message translates to:
  /// **'A4, recipes one after another, saves paper'**
  String get cookbookLayoutCompactHint;

  /// Layout name.
  ///
  /// In en, this message translates to:
  /// **'Recipe cards'**
  String get cookbookLayoutCards;

  /// Layout description.
  ///
  /// In en, this message translates to:
  /// **'A6 cards, one recipe each, easy to cut out'**
  String get cookbookLayoutCardsHint;

  /// PDF page when the cookbook is empty.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get pdfNoRecipes;

  /// Cover line, before the month.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipe} other{{count} recipes}}'**
  String pdfRecipeCount(int count);

  /// The twelve month names separated by commas (no spaces), as written before the year on the cover.
  ///
  /// In en, this message translates to:
  /// **'January,February,March,April,May,June,July,August,September,October,November,December'**
  String get pdfMonths;

  /// Cover footer.
  ///
  /// In en, this message translates to:
  /// **'Made with Manja'**
  String get pdfMadeWith;

  /// Heading of the table of contents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get pdfContents;

  /// Before the nutrition values.
  ///
  /// In en, this message translates to:
  /// **'Per portion'**
  String get pdfPerPortion;

  /// Before the nutrition values when some ingredients are not linked.
  ///
  /// In en, this message translates to:
  /// **'Per portion, at least'**
  String get pdfPerPortionAtLeast;

  /// Heading (printed in capitals).
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get pdfIngredients;

  /// Heading (printed in capitals).
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get pdfPreparation;

  /// Heading (printed in capitals).
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get pdfNotes;

  /// Link to the recipe source website.
  ///
  /// In en, this message translates to:
  /// **'Source: {host}'**
  String pdfSource(String host);

  /// Page reference after an ingredient that is a recipe in the book.
  ///
  /// In en, this message translates to:
  /// **'p. {page}'**
  String pdfPage(String page);

  /// Recipe info line.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 portion} other{{count} portions}}'**
  String pdfPortions(int count);

  /// Recipe info line; time is e.g. "20 min".
  ///
  /// In en, this message translates to:
  /// **'Prep {time}'**
  String pdfPrep(String time);

  /// Recipe info line; time is e.g. "1 h 30 min".
  ///
  /// In en, this message translates to:
  /// **'Cook {time}'**
  String pdfCook(String time);

  /// Duration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String pdfMinutes(int minutes);

  /// Duration in whole hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String pdfHours(int hours);

  /// Duration.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String pdfHoursMinutes(int hours, int minutes);

  /// Nutrition line, after the amount: "31 g protein".
  ///
  /// In en, this message translates to:
  /// **'protein'**
  String get pdfProtein;

  /// Nutrition line, after the amount.
  ///
  /// In en, this message translates to:
  /// **'fat'**
  String get pdfFat;

  /// Nutrition line, after the amount.
  ///
  /// In en, this message translates to:
  /// **'carbohydrate'**
  String get pdfCarbohydrate;

  /// Nutrition line, after the amount.
  ///
  /// In en, this message translates to:
  /// **'fiber'**
  String get pdfFiber;

  /// About page; the license name stays in English.
  ///
  /// In en, this message translates to:
  /// **'Free software under the GNU Affero General Public License v3.0.'**
  String get aboutLicense;

  /// About page.
  ///
  /// In en, this message translates to:
  /// **'Source code: {url}'**
  String aboutSource(String url);

  /// About page.
  ///
  /// In en, this message translates to:
  /// **'The name \"Manja\" and its logo are not covered by the license.'**
  String get aboutTrademark;
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
