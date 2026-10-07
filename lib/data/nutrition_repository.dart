import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:nutrition_core/nutrition_core.dart';

import 'database.dart';

class NutritionRepository {
  NutritionRepository(this.db, {this._remotes = const {}, Random? random}) : _random = random ?? Random();

  static const _keyBundleVersion = 'nutrition.bundleVersion';

  final AppDatabase db;
  final Map<FoodSource, NutritionSource> _remotes;
  final Random _random;

  bool get hasRemote => _remotes.isNotEmpty;

  Future<List<FoodSummary>> searchLocal(String query, {int limit = 25}) async {
    final rows = await db.searchFoodRows(query, limit: 300);
    final scored = [
      for (final row in rows)
        (
          row,
          searchScore(query, row.name, hasPortions: row.portions != '[]') + (row.source == FoodSource.user.id ? 30 : 0),
        ),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final (row, _) in scored.take(limit)) foodFromRow(row).summary];
  }

  Future<Food?> refresh(Food food) async {
    final remote = _remotes[food.source];
    if (remote == null) return null;
    final fresh = await remote.fetch(food.sourceId);
    if (fresh != null) await store(fresh);
    return fresh;
  }

  Future<List<FoodSummary>> searchRemote(String query, {int limit = 25}) async => [
        for (final remote in _remotes.values) ...await remote.search(query, limit: limit),
      ];

  Future<Food?> food(String key) async {
    final local = await db.foodRow(key);
    if (local != null) return foodFromRow(local);
    final remote = _remotes[FoodSource.fromId(key.substring(0, key.indexOf(':')))];
    final fetched = await remote?.fetch(key.substring(key.indexOf(':') + 1));
    if (fetched != null) await store(fetched);
    return fetched;
  }

  Future<Map<String, Food>> foodsByKey(Iterable<String> keys) async {
    final rows = await db.foodRows(keys.toSet());
    return {for (final row in rows) row.key: foodFromRow(row)};
  }

  Future<void> store(Food food, {DateTime? at}) => db.upsertFoodRow(_row(food, at ?? DateTime.now()));

  Future<void> storeAll(List<Food> foods, {DateTime? at}) {
    final now = at ?? DateTime.now();
    return db.upsertFoodRows([for (final f in foods) _row(f, now)]);
  }

  FoodsCompanion _row(Food food, DateTime at) => FoodsCompanion.insert(
        key: food.key,
        source: food.source.id,
        sourceId: food.sourceId,
        name: food.name,
        detail: Value(food.detail),
        nutrients: jsonEncode(food.per100g.toJson()),
        portions: Value(jsonEncode([for (final p in food.portions) p.toJson()])),
        densityGPerMl: Value(food.densityGPerMl),
        fetchedAt: at,
      );

  Future<String?> bundleVersion() => db.getSetting(_keyBundleVersion);

  Future<bool> importBundle(String version, List<Food> foods) async {
    if (await bundleVersion() == version) return false;
    await storeAll(foods);
    await db.setSetting(_keyBundleVersion, version);
    return true;
  }

  Future<int> countBySource(FoodSource source) => db.countFoodRows(source.id);

  Future<Food> saveUserFood({
    String? sourceId,
    required String name,
    required Nutrients per100g,
    List<FoodPortion> portions = const [],
    double? densityGPerMl,
  }) async {
    final food = Food(
      source: FoodSource.user,
      sourceId: sourceId ?? '${DateTime.now().microsecondsSinceEpoch}${_random.nextInt(1 << 20)}',
      name: name,
      per100g: per100g,
      portions: portions,
      densityGPerMl: densityGPerMl,
    );
    await store(food);
    return food;
  }

  Future<void> delete(String key) => db.deleteFoodRow(key);

  Future<List<Food>> library() async => [for (final r in await db.select(db.foods).get()) foodFromRow(r)];

  Stream<List<Food>> watchUserFoods() =>
      db.watchFoodRows(source: FoodSource.user.id).map((rows) => [for (final r in rows) foodFromRow(r)]);
}

Food foodFromRow(FoodRow row) => Food(
      source: FoodSource.fromId(row.source),
      sourceId: row.sourceId,
      name: row.name,
      detail: row.detail,
      per100g: Nutrients.fromJson(jsonDecode(row.nutrients) as Map<String, dynamic>),
      portions: [
        for (final p in jsonDecode(row.portions) as List) FoodPortion.fromJson(p as Map<String, dynamic>),
      ],
      densityGPerMl: row.densityGPerMl,
    );
