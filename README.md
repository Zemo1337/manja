# Manja

Meal Wheel & Recipe Book. Add your favourite dishes, spin the wheel to decide what to cook, and the dishes you ate leave the wheel until it refills.

Built with Flutter for Android, iOS, Windows, Linux and macOS.

## Features

- Recipes with ingredients (metric and imperial units), cooking info, preparation steps and portions
- Spin wheel with the dishes you have not eaten yet this round
- Reset rules: when every dish was eaten, after a number of days, or manually
- Meal history

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter run
```

### Built-in ingredient data

`assets/food/usda.json.gz` holds the USDA Foundation and SR Legacy foods (about 8,000 foods, 330 KB). The app imports
it on first start and again whenever the file's version changes, so corrected values reach users with app updates.
To rebuild it from the bulk downloads at [fdc.nal.usda.gov/download-datasets](https://fdc.nal.usda.gov/download-datasets):

```bash
cd packages/nutrition_usda && dart run tool/build_bundle.dart "FDC Foundation <date> + SR Legacy 2018-04" ../../assets/food/usda.json.gz <foundation.json> <sr_legacy.json>
```

### USDA API key

Ingredient nutrition comes from [USDA FoodData Central](https://fdc.nal.usda.gov/). Get a free key at
[api.data.gov/signup](https://api.data.gov/signup/), then:

```bash
cp config/local.example.json config/local.json
```

Put the key into `config/local.json` (ignored by git) and run with:

```bash
flutter run --dart-define-from-file=config/local.json
```

The VS Code launch configuration "Manja" does this automatically. Without a key the app uses USDA's
`DEMO_KEY`, which is limited to a few requests per hour.

The database layer uses [drift](https://drift.simonbinder.eu/). After changing tables in `lib/data/database.dart`, rerun `build_runner`.

## Project layout

```
lib/
  data/       drift database, tables and queries
  domain/     units and wheel logic
  ui/         screens (wheel, recipes, history)
test/         unit and widget tests
packages/
  nutrition_core/   nutrient model, food sources interface, unit conversion,
                    recipe nutrition calculation (plain Dart)
  nutrition_usda/   USDA FoodData Central adapter (search, food details,
                    portion parsing)
  recipe_import/    reads schema.org recipe data from web pages
```

Packages are tested on their own:

```bash
cd packages/nutrition_core && dart test
```

```bash
cd packages/nutrition_usda && dart test
```
