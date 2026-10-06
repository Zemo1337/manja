import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:nutrition_core/nutrition_core.dart';

class FakeUsda implements NutritionSource {
  final foods = <String, Food>{
    '1': Food(
      source: FoodSource.usda,
      sourceId: '1',
      name: 'Wheat flour, white',
      per100g: Nutrients.of(energyKcal: 364, protein: 10.3),
      portions: const [FoodPortion(label: '1 cup', grams: 125, unit: CookingUnit.cup)],
    ),
    '2': Food(
      source: FoodSource.usda,
      sourceId: '2',
      name: 'Milk, whole',
      per100g: Nutrients.of(energyKcal: 61),
      densityGPerMl: 1.03,
    ),
  };
  int fetches = 0;
  int searches = 0;
  bool offline = false;

  @override
  FoodSource get source => FoodSource.usda;

  @override
  Future<Food?> fetch(String sourceId) async {
    fetches++;
    if (offline) throw const NutritionSourceException('offline');
    return foods[sourceId];
  }

  @override
  Future<List<FoodSummary>> search(String query, {int limit = 25}) async {
    searches++;
    if (offline) throw const NutritionSourceException('offline');
    return [for (final f in foods.values) if (f.name.toLowerCase().contains(query.toLowerCase())) f.summary];
  }
}

void main() {
  late AppDatabase db;
  late FakeUsda usda;
  late NutritionRepository repo;

  setUp(() {
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    usda = FakeUsda();
    repo = NutritionRepository(db, remotes: {FoodSource.usda: usda});
  });

  tearDown(() => db.close());

  test('default mode saves looked-up foods and serves them locally afterwards', () async {
    expect(await repo.mode(), FoodCacheMode.cacheUsed);
    final flour = await repo.food('usda:1');
    expect(flour!.name, 'Wheat flour, white');
    expect(flour.portions.single.grams, 125);
    expect(usda.fetches, 1);

    usda.offline = true;
    final again = await repo.food('usda:1');
    expect(again!.per100g, flour.per100g);
    expect(usda.fetches, 1);
    expect((await repo.searchLocal('flour')).single.key, 'usda:1');
  });

  test('online mode only keeps foods that are linked to a recipe', () async {
    await repo.setMode(FoodCacheMode.online);
    await repo.food('usda:1');
    expect(await repo.searchLocal('flour'), isEmpty);
    await repo.food('usda:2', keep: true);
    expect((await repo.searchLocal('milk')).single.key, 'usda:2');

    await repo.food('usda:2');
    expect(usda.fetches, 3, reason: 'online mode always asks the source');
    usda.offline = true;
    expect((await repo.food('usda:2'))!.name, 'Milk, whole', reason: 'falls back to the kept copy');
    await expectLater(repo.food('usda:1'), throwsA(isA<NutritionSourceException>()));
  });

  test('full mode searches locally only', () async {
    await repo.setMode(FoodCacheMode.full);
    expect(await repo.searchRemote('flour'), isEmpty);
    expect(usda.searches, 0);
    await repo.setMode(FoodCacheMode.cacheUsed);
    expect(await repo.searchRemote('flour'), hasLength(1));
  });

  test('user foods are stored and found like any other food', () async {
    final food = await repo.saveUserFood(
      name: 'Grandma\'s ajvar',
      per100g: Nutrients.of(energyKcal: 120, fat: 9),
      portions: const [FoodPortion(label: '1 tbsp', grams: 16, unit: CookingUnit.tbsp)],
    );
    expect(food.source, FoodSource.user);
    final found = await repo.searchLocal('ajvar');
    expect(found.single.key, food.key);
    final loaded = await repo.food(food.key);
    expect(loaded!.per100g[Nutrient.fat], 9);
    expect(gramsFor(loaded, 2, CookingUnit.tbsp), 32);
  });

  test('search words match in any order and wildcards are literal', () async {
    await repo.food('usda:1');
    await repo.food('usda:2');
    expect((await repo.searchLocal('white wheat')).single.sourceId, '1');
    expect(await repo.searchLocal('%'), isEmpty);
  });

  test('refresh updates cached foods and prune drops the unused ones', () async {
    await repo.food('usda:1');
    await repo.food('usda:2');
    await db.saveRecipe(RecipeDraft(
      name: 'Palačinke',
      portions: 4,
      ingredients: [IngredientDraft(name: 'Flour', amount: 250, unit: 'g', foodKey: 'usda:1')],
    ));
    usda.foods['1'] = Food(
      source: FoodSource.usda,
      sourceId: '1',
      name: 'Wheat flour, white, updated',
      per100g: Nutrients.of(energyKcal: 360),
    );
    final result = await repo.refreshCached();
    expect(result.updated, 2);
    expect((await repo.food('usda:1'))!.name, endsWith('updated'));

    expect(await repo.pruneUnused(), 1);
    expect(await repo.searchLocal('milk'), isEmpty);
    expect(await repo.searchLocal('flour'), hasLength(1));
  });

  test('recipe ingredients keep their food link and the finished weight', () async {
    final id = await db.saveRecipe(RecipeDraft(
      name: 'Palačinke',
      portions: 4,
      finishedWeightG: 900,
      ingredients: [
        IngredientDraft(name: 'Flour', amount: 250, unit: 'g', foodKey: 'usda:1'),
        IngredientDraft(name: 'Salt', amount: 1, unit: 'pinch'),
      ],
    ));
    final full = await db.recipeFull(id);
    expect(full!.recipe.finishedWeightG, 900);
    expect(full.ingredients.map((i) => i.foodKey), ['usda:1', null]);
  });
}
