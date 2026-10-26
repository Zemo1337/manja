import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_usda/nutrition_usda.dart';

import '../domain/text_fold.dart';
import 'database.dart';
import 'recipe_foods.dart';

enum ApiKeyOrigin { demo, developer, user }

class NutritionRepository {
  NutritionRepository(this.db, {this._remotes = const {}, this.buildApiKey = UsdaSource.demoKey, Random? random})
      : _random = random ?? Random();

  static const _keyBundleVersion = 'nutrition.bundleVersion';
  static const _keyUsdaApiKey = 'nutrition.usdaApiKey';

  final AppDatabase db;
  final Map<FoodSource, NutritionSource> _remotes;
  final String buildApiKey;
  final Random _random;

  bool get hasRemote => _remotes.isNotEmpty;

  UsdaSource? get _usda => switch (_remotes[FoodSource.usda]) {
        final UsdaSource usda => usda,
        _ => null,
      };

  bool get usingDemoKey => _usda?.usingDemoKey ?? false;

  Future<String?> userApiKey() async {
    final key = (await db.getSetting(_keyUsdaApiKey))?.trim();
    return key == null || key.isEmpty ? null : key;
  }

  Future<ApiKeyOrigin> loadApiKey() async {
    final user = await userApiKey();
    _usda?.apiKey = user ?? buildApiKey;
    if (user != null) return ApiKeyOrigin.user;
    return buildApiKey == UsdaSource.demoKey ? ApiKeyOrigin.demo : ApiKeyOrigin.developer;
  }

  Future<ApiKeyOrigin> setUserApiKey(String? key) async {
    final trimmed = key?.trim() ?? '';
    if (trimmed.isEmpty) {
      await db.deleteSetting(_keyUsdaApiKey);
    } else {
      await db.setSetting(_keyUsdaApiKey, trimmed);
    }
    return loadApiKey();
  }

  /// Local names of common foods, folded, with the English words that find them in the built-in data.
  final searchNames = <String, String>{};

  /// Reads every `assets/food/search_<language>.json`, so searching "Mehl" or "brašno" finds the USDA flour.
  Future<void> loadSearchNames(AssetBundle bundle) async {
    final manifest = await AssetManifest.loadFromAssetBundle(bundle);
    for (final asset in manifest.listAssets().where((a) => RegExp(r'assets/food/search_\w+\.json$').hasMatch(a))) {
      for (final entry in jsonDecode(await bundle.loadString(asset)) as List) {
        final search = entry['search'] as String;
        for (final name in entry['names'] as List) {
          searchNames[foldText((name as String).trim())] = search;
        }
      }
    }
  }

  /// The English words for local names matching [query], exact matches first.
  List<String> _translatedQueries(String query) {
    final folded = foldText(query.trim());
    if (folded.length < 2) return const [];
    return <String>{
      ?searchNames[folded],
      if (folded.length >= 3)
        for (final MapEntry(:key, :value) in searchNames.entries)
          if (key.startsWith(folded)) value,
    }.take(4).toList();
  }

  /// Foods on this device matching [query]; the ones already used in recipes come first, the most used on top.
  Future<List<FoodSummary>> searchLocal(String query, {int limit = 25, Map<String, int>? uses}) async {
    final used = uses ?? await db.foodUseCounts();
    final queries = [query, ..._translatedQueries(query)];
    final rows = {
      for (final q in queries)
        for (final row in [
          if (used.isNotEmpty) ...await db.searchFoodRows(q, limit: 300, keys: used.keys.toSet()),
          ...await db.searchFoodRows(q, limit: q == query ? 300 : 20),
        ])
          row.key: row,
    }.values;
    double score(FoodRow row) =>
        queries.map((q) => searchScore(q, row.name, hasPortions: row.portions != '[]')).reduce(max) +
        (row.source == FoodSource.user.id ? 30 : 0);
    final scored = [for (final row in rows) (row, used[row.key] ?? 0, score(row))]
      ..sort((a, b) {
        final byUse = b.$2.compareTo(a.$2);
        return byUse != 0 ? byUse : b.$3.compareTo(a.$3);
      });
    return [for (final (row, _, _) in scored.take(limit)) foodFromRow(row).summary];
  }

  final updating = ValueNotifier<Set<String>>(const {});

  Future<Food?> refresh(Food food) async {
    final remote = _remotes[food.source];
    if (remote == null) return null;
    updating.value = {...updating.value, food.key};
    try {
      final fresh = await remote.fetch(food.sourceId);
      if (fresh != null) await store(fresh);
      return fresh;
    } finally {
      updating.value = {...updating.value}..remove(food.key);
    }
  }

  bool hasSource(FoodSource source) => _remotes.containsKey(source);

  Future<List<FoodSummary>> searchRemote(String query, {int limit = 10, FoodSource? source}) async => [
        for (final remote in _remotes.values)
          if (source == null || remote.source == source) ...await remote.search(query, limit: limit),
      ];

  Future<Food?> productByBarcode(String barcode) => food('${FoodSource.openFoodFacts.id}:$barcode');

  Future<Food?> food(String key) async {
    if (recipeIdOfFoodKey(key) case final id?) return recipeFood(db, id);
    final local = await db.foodRow(key);
    if (local != null) return foodFromRow(local);
    final remote = _remotes[FoodSource.fromId(key.substring(0, key.indexOf(':')))];
    final fetched = await remote?.fetch(key.substring(key.indexOf(':') + 1));
    if (fetched != null) await store(fetched);
    return fetched;
  }

  Future<Map<String, Food>> foodsByKey(Iterable<String> keys) => resolveFoods(db, keys.toSet());

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
