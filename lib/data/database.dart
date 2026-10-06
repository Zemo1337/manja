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
}

class RecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get unit => text()();
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
  IngredientDraft({required this.name, required this.amount, required this.unit});

  final String name;
  final double amount;
  final String unit;
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
  final List<IngredientDraft> ingredients;
  final List<String> steps;
}

class MealLogEntry {
  MealLogEntry(this.log, this.recipe);

  final MealLog log;
  final Recipe recipe;
}

@DriftDatabase(tables: [Recipes, RecipeIngredients, RecipeSteps, MealLogs, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'manja_manja'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
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

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
}
