import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get portions => integer().withDefault(const Constant(1))();
  IntColumn get prepMinutes => integer().nullable()();
  IntColumn get cookMinutes => integer().nullable()();
  TextColumn get cookingInfo => text().withDefault(const Constant(''))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get photoPath => text().nullable()();
  RealColumn get finishedWeightG => real().nullable()();
}

class RecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
  TextColumn get foodKey => text().nullable()();
}

@DataClassName('FoodRow')
class Foods extends Table {
  TextColumn get key => text()();
  TextColumn get source => text()();
  TextColumn get sourceId => text()();
  TextColumn get name => text()();
  TextColumn get detail => text().nullable()();
  TextColumn get nutrients => text()();
  TextColumn get portions => text().withDefault(const Constant('[]'))();
  RealColumn get densityGPerMl => real().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

class RecipeSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get body => text()();
}

class MealLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get eatenAt => dateTime()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class RecipeFull {
  RecipeFull(this.recipe, this.ingredients, this.steps);

  final Recipe recipe;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
}

class IngredientDraft {
  IngredientDraft({required this.name, required this.amount, required this.unit, this.foodKey});

  final String name;
  final double amount;
  final String unit;
  final String? foodKey;
}

class RecipeDraft {
  RecipeDraft({
    this.id,
    required this.name,
    required this.portions,
    this.prepMinutes,
    this.cookMinutes,
    this.cookingInfo = '',
    this.isFavorite = false,
    this.photoPath,
    this.finishedWeightG,
    this.ingredients = const [],
    this.steps = const [],
  });

  final int? id;
  final String name;
  final int portions;
  final int? prepMinutes;
  final int? cookMinutes;
  final String cookingInfo;
  final bool isFavorite;
  final String? photoPath;
  final double? finishedWeightG;
  final List<IngredientDraft> ingredients;
  final List<String> steps;
}

class MealLogEntry {
  MealLogEntry(this.log, this.recipe);

  final MealLog log;
  final Recipe recipe;
}

@DriftDatabase(tables: [Recipes, RecipeIngredients, RecipeSteps, MealLogs, AppSettings, Foods])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'manja_manja'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.addColumn(recipes, recipes.photoPath);
          if (from < 3) {
            await m.addColumn(recipes, recipes.finishedWeightG);
            await m.addColumn(recipeIngredients, recipeIngredients.foodKey);
            await m.createTable(foods);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Stream<List<Recipe>> watchRecipes() =>
      (select(recipes)..orderBy([(r) => OrderingTerm.asc(r.name.collate(Collate.noCase))])).watch();

  Future<List<Recipe>> allRecipes() => select(recipes).get();

  Future<RecipeFull?> recipeFull(int id) async {
    final recipe = await (select(recipes)..where((r) => r.id.equals(id))).getSingleOrNull();
    if (recipe == null) return null;
    final ingredients = await (select(recipeIngredients)
          ..where((i) => i.recipeId.equals(id))
          ..orderBy([(i) => OrderingTerm.asc(i.position)]))
        .get();
    final steps = await (select(recipeSteps)
          ..where((s) => s.recipeId.equals(id))
          ..orderBy([(s) => OrderingTerm.asc(s.position)]))
        .get();
    return RecipeFull(recipe, ingredients, steps);
  }

  Future<int> saveRecipe(RecipeDraft draft) => transaction(() async {
        final companion = RecipesCompanion(
          name: Value(draft.name),
          portions: Value(draft.portions),
          prepMinutes: Value(draft.prepMinutes),
          cookMinutes: Value(draft.cookMinutes),
          cookingInfo: Value(draft.cookingInfo),
          isFavorite: Value(draft.isFavorite),
          photoPath: Value(draft.photoPath),
          finishedWeightG: Value(draft.finishedWeightG),
        );
        final int id;
        if (draft.id == null) {
          id = await into(recipes).insert(companion);
        } else {
          id = draft.id!;
          await (update(recipes)..where((r) => r.id.equals(id))).write(companion);
          await (delete(recipeIngredients)..where((i) => i.recipeId.equals(id))).go();
          await (delete(recipeSteps)..where((s) => s.recipeId.equals(id))).go();
        }
        await batch((b) {
          b.insertAll(recipeIngredients, [
            for (final (index, ingredient) in draft.ingredients.indexed)
              RecipeIngredientsCompanion.insert(
                recipeId: id,
                position: index,
                name: ingredient.name,
                amount: ingredient.amount,
                unit: ingredient.unit,
                foodKey: Value(ingredient.foodKey),
              ),
          ]);
          b.insertAll(recipeSteps, [
            for (final (index, step) in draft.steps.indexed)
              RecipeStepsCompanion.insert(recipeId: id, position: index, body: step),
          ]);
        });
        return id;
      });

  Future<void> deleteRecipe(int id) => (delete(recipes)..where((r) => r.id.equals(id))).go();

  Future<void> setFavorite(int id, bool value) =>
      (update(recipes)..where((r) => r.id.equals(id))).write(RecipesCompanion(isFavorite: Value(value)));

  Future<int> logMeal(int recipeId, DateTime eatenAt) =>
      into(mealLogs).insert(MealLogsCompanion.insert(recipeId: recipeId, eatenAt: eatenAt));

  Future<void> deleteMealLog(int id) => (delete(mealLogs)..where((m) => m.id.equals(id))).go();

  Future<FoodRow?> foodRow(String key) => (select(foods)..where((f) => f.key.equals(key))).getSingleOrNull();

  Future<List<FoodRow>> foodRows(Iterable<String> keys) => (select(foods)..where((f) => f.key.isIn(keys))).get();

  Future<List<FoodRow>> searchFoodRows(String query, {int limit = 25}) {
    final words = query.trim().toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final q = select(foods);
    for (final w in words) {
      final escaped = w.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
      q.where((f) => f.name.lower().like('%$escaped%', escapeChar: r'\'));
    }
    return (q
          ..orderBy([(f) => OrderingTerm.asc(f.name.length), (f) => OrderingTerm.asc(f.name)])
          ..limit(limit))
        .get();
  }

  Stream<List<FoodRow>> watchFoodRows({String? source}) {
    final q = select(foods)..orderBy([(f) => OrderingTerm.asc(f.name.collate(Collate.noCase))]);
    if (source != null) q.where((f) => f.source.equals(source));
    return q.watch();
  }

  Future<int> countFoodRows(String source) {
    final count = foods.key.count();
    return (selectOnly(foods)
          ..addColumns([count])
          ..where(foods.source.equals(source)))
        .map((r) => r.read(count)!)
        .getSingle();
  }

  Future<void> upsertFoodRow(FoodsCompanion row) => into(foods).insertOnConflictUpdate(row);

  Future<void> upsertFoodRows(List<FoodsCompanion> rows) =>
      batch((b) => b.insertAllOnConflictUpdate(foods, rows));

  Future<void> deleteFoodRow(String key) => (delete(foods)..where((f) => f.key.equals(key))).go();

  Future<Set<String>> linkedFoodKeys() async {
    final key = recipeIngredients.foodKey;
    final rows = await (selectOnly(recipeIngredients, distinct: true)
          ..addColumns([key])
          ..where(key.isNotNull()))
        .map((r) => r.read(key)!)
        .get();
    return rows.toSet();
  }

  Future<DateTime?> latestMealAt() async {
    final latest = mealLogs.eatenAt.max();
    return (selectOnly(mealLogs)..addColumns([latest])).map((row) => row.read(latest)).getSingle();
  }

  Future<List<MealLog>> mealLogsSince(DateTime since) async {
    final logs = await select(mealLogs).get();
    return [for (final log in logs) if (!log.eatenAt.isBefore(since)) log];
  }

  Stream<List<MealLogEntry>> watchMealLog() {
    final query = select(mealLogs).join([innerJoin(recipes, recipes.id.equalsExp(mealLogs.recipeId))])
      ..orderBy([OrderingTerm.desc(mealLogs.eatenAt)]);
    return query.watch().map((rows) => [
          for (final row in rows) MealLogEntry(row.readTable(mealLogs), row.readTable(recipes)),
        ]);
  }

  Stream<void> watchWheelInputs() =>
      tableUpdates(TableUpdateQuery.onAllTables([recipes, mealLogs, appSettings]));

  Future<String?> getSetting(String key) async =>
      (await (select(appSettings)..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> deleteSetting(String key) => (delete(appSettings)..where((s) => s.key.equals(key))).go();

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
}
