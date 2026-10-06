# Manja Manja

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
```

Packages are tested on their own:

```bash
cd packages/nutrition_core && dart test
```
