import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:nutrition_core/nutrition_core.dart';

import 'database.dart';

enum FoodCacheMode {
  online('Always online', 'Ingredients are looked up live. Only ingredients used in recipes are kept on the device.'),
  cacheUsed('Save what I use', 'Every ingredient you look up is saved on the device and works offline.'),
  full('Download everything', 'The whole ingredient list is stored on the device. Search works fully offline.');

  const FoodCacheMode(this.label, this.description);

  final String label;
  final String description;
}

class NutritionRepository {
  NutritionRepository(this.db, {this._remotes = const {}, Random? random}) : _random = random ?? Random();

  static const _keyMode = 'nutrition.cacheMode';

  final AppDatabase db;
  final Map<FoodSource, NutritionSource> _remotes;
  final Random _random;

  Iterable<NutritionSource> get remotes => _remotes.values;

  Future<FoodCacheMode> mode() async =>
      FoodCacheMode.values.asNameMap()[await db.getSetting(_keyMode)] ?? FoodCacheMode.cacheUsed;

  Future<void> setMode(FoodCacheMode mode) => db.setSetting(_keyMode, mode.name);

  Future<List<FoodSummary>> searchLocal(String query, {int limit = 25}) async =>
      [for (final row in await db.searchFoodRows(query, limit: limit)) foodFromRow(row).summary];

  Future<List<FoodSummary>> searchRemote(String query, {int limit = 25}) async {
    if (await mode() == FoodCacheMode.full) return const [];
    final results = <FoodSummary>[];
    for (final remote in _remotes.values) {
      results.addAll(await remote.search(query, limit: limit));
    }
    return results;
  }

  Future<Food?> food(String key, {bool keep = false}) async {
    final local = await db.foodRow(key);
    final source = FoodSource.fromId(key.substring(0, key.indexOf(':')));
    final remote = _remotes[source];
    final currentMode = await mode();
    if (local != null && (currentMode != FoodCacheMode.online || remote == null)) return foodFromRow(local);
    if (remote == null) return local == null ? null : foodFromRow(local);
    final Food? fetched;
    try {
      fetched = await remote.fetch(key.substring(key.indexOf(':') + 1));
    } on NutritionSourceException {
      if (local != null) return foodFromRow(local);
      rethrow;
    }
    if (fetched != null && (keep || local != null || currentMode != FoodCacheMode.online)) await store(fetched);
    return fetched ?? (local == null ? null : foodFromRow(local));
  }

  Future<Map<String, Food>> foodsByKey(Iterable<String> keys) async {
    final rows = await db.foodRows(keys.toSet());
    return {for (final row in rows) row.key: foodFromRow(row)};
  }

  Future<void> store(Food food, {DateTime? at}) => db.upsertFoodRow(FoodsCompanion.insert(
        key: food.key,
        source: food.source.id,
        sourceId: food.sourceId,
        name: food.name,
        detail: Value(food.detail),
        nutrients: jsonEncode(food.per100g.toJson()),
        portions: Value(jsonEncode([for (final p in food.portions) p.toJson()])),
        densityGPerMl: Value(food.densityGPerMl),
        fetchedAt: at ?? DateTime.now(),
      ));

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

  Stream<List<Food>> watchLibrary() => db.watchFoodRows().map((rows) => [for (final r in rows) foodFromRow(r)]);

  Future<({int updated, int failed})> refreshCached() async {
    var updated = 0;
    var failed = 0;
    for (final food in await library()) {
      final remote = _remotes[food.source];
      if (remote == null) continue;
      try {
        final fresh = await remote.fetch(food.sourceId);
        if (fresh == null) {
          failed++;
          continue;
        }
        await store(fresh);
        updated++;
      } on NutritionSourceException {
        failed++;
      }
    }
    return (updated: updated, failed: failed);
  }

  Future<int> pruneUnused() async {
    final linked = await db.linkedFoodKeys();
    var removed = 0;
    for (final food in await library()) {
      if (food.source != FoodSource.user && !linked.contains(food.key)) {
        await delete(food.key);
        removed++;
      }
    }
    return removed;
  }
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
