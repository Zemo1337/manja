import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import 'database.dart';
import 'photo_store.dart';

class ProfileSummary {
  const ProfileSummary({
    required this.exportedAt,
    required this.recipes,
    required this.meals,
    required this.photos,
    required this.ownIngredients,
    required this.pantry,
  });

  final DateTime? exportedAt;
  final int recipes;
  final int meals;
  final int photos;
  final int ownIngredients;
  final int pantry;
}

class ImportResult {
  const ImportResult({required this.added, required this.skipped, required this.meals});

  final int added;
  final int skipped;
  final int meals;
}

class ProfileBackup {
  ProfileBackup(this.db, this.photos);

  static const extension = '.manja';
  static const _format = 'manja-profile';
  static const _version = 1;
  static const _dataFile = 'manja.json';
  static const _localOnlySettings = {'nutrition.usdaApiKey', 'nutrition.bundleVersion'};
  static const _deviceSettings = {'wheel.tag'};
  static final _photoName = RegExp(r'^photos/[A-Za-z0-9_.-]+$');

  final AppDatabase db;
  final PhotoStore photos;

  String fileName(DateTime at) => 'manja-${at.year}-${_two(at.month)}-${_two(at.day)}$extension';

  static String _two(int n) => n.toString().padLeft(2, '0');

  Future<Uint8List> export({DateTime? at}) async {
    final archive = Archive();
    final recipes = await db.allRecipes();
    final ingredients = await db.allRecipeIngredients();
    final steps = await (db.select(db.recipeSteps)..orderBy([(s) => OrderingTerm.asc(s.position)])).get();
    final meals = await db.select(db.mealLogs).get();
    final pantry = await db.pantry();
    final settings = await db.select(db.appSettings).get();
    final tags = await db.allTags();
    final tagNames = {for (final t in tags) t.id: t.name};
    final tagsByRecipe = await db.tagsByRecipe();
    final usedFoods = {for (final i in ingredients) ?i.foodKey, for (final i in pantry) ?i.foodKey};
    final foods = await (db.select(db.foods)..where((f) => f.source.equals('user') | f.key.isIn(usedFoods))).get();

    final recipeJson = <Map<String, Object?>>[];
    for (final r in recipes) {
      String? photo;
      if (r.photoPath != null) {
        final file = photos.file(r.photoPath!);
        if (await file.exists()) {
          photo = 'photos/${r.id}${p.extension(r.photoPath!).toLowerCase()}';
          archive.addFile(ArchiveFile.noCompress(photo, await file.length(), await file.readAsBytes()));
        }
      }
      recipeJson.add({
        'id': r.id,
        'name': r.name,
        'portions': r.portions,
        'prepMinutes': r.prepMinutes,
        'cookMinutes': r.cookMinutes,
        'cookingInfo': r.cookingInfo,
        'isFavorite': r.isFavorite,
        'createdAt': _date(r.createdAt),
        'photo': photo,
        'finishedWeightG': r.finishedWeightG,
        'sourceUrl': r.sourceUrl,
        'tags': [for (final id in tagsByRecipe[r.id] ?? const <int>{}) ?tagNames[id]],
        'ingredients': [
          for (final i in ingredients)
            if (i.recipeId == r.id) {'name': i.name, 'amount': i.amount, 'unit': i.unit, 'foodKey': i.foodKey},
        ],
        'steps': [
          for (final s in steps)
            if (s.recipeId == r.id) s.body,
        ],
      });
    }

    final data = {
      'format': _format,
      'version': _version,
      'exportedAt': _date(at ?? DateTime.now()),
      'recipes': recipeJson,
      'meals': [
        for (final m in meals) {'recipeId': m.recipeId, 'eatenAt': _date(m.eatenAt)},
      ],
      'tags': [for (final t in tags) t.name],
      'pantry': [
        for (final i in pantry) {'name': i.name, 'foodKey': i.foodKey},
      ],
      'foods': [
        for (final f in foods)
          {
            'key': f.key,
            'source': f.source,
            'sourceId': f.sourceId,
            'name': f.name,
            'detail': f.detail,
            'nutrients': f.nutrients,
            'portions': f.portions,
            'densityGPerMl': f.densityGPerMl,
            'fetchedAt': _date(f.fetchedAt),
          },
      ],
      'settings': {
        for (final s in settings)
          if (!_localOnlySettings.contains(s.key) && !_deviceSettings.contains(s.key)) s.key: s.value,
      },
    };
    archive.addFile(ArchiveFile.string(_dataFile, const JsonEncoder.withIndent(' ').convert(data)));
    return ZipEncoder().encodeBytes(archive);
  }

  static String _date(DateTime d) => d.toUtc().toIso8601String();

  static DateTime _parseDate(Object? value) => DateTime.parse(value as String).toLocal();

  (Archive, Map<String, Object?>) _open(List<int> bytes) {
    final Archive archive;
    final Map<String, Object?> data;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
      final file = archive.findFile(_dataFile);
      if (file == null) throw const FormatException();
      data = jsonDecode(utf8.decode(file.content)) as Map<String, Object?>;
    } on Object {
      throw const FormatException('This is not a Manja profile.');
    }
    if (data['format'] != _format) throw const FormatException('This is not a Manja profile.');
    if ((data['version'] as int? ?? 0) > _version) {
      throw const FormatException('This profile was made by a newer version of the app. Please update first.');
    }
    return (archive, data);
  }

  ProfileSummary read(List<int> bytes) {
    final (archive, data) = _open(bytes);
    final recipes = _list(data['recipes']);
    return ProfileSummary(
      exportedAt: DateTime.tryParse(data['exportedAt'] as String? ?? '')?.toLocal(),
      recipes: recipes.length,
      meals: _list(data['meals']).length,
      photos: recipes.where((r) => r['photo'] != null && archive.findFile(r['photo'] as String) != null).length,
      ownIngredients: _list(data['foods']).where((f) => f['source'] == 'user').length,
      pantry: _list(data['pantry']).length,
    );
  }

  static List<Map<String, Object?>> _list(Object? value) => [
    for (final item in value as List? ?? const []) item as Map<String, Object?>,
  ];

  Future<ImportResult> import(List<int> bytes, {required bool replace}) async {
    final (archive, data) = _open(bytes);
    final recipes = _list(data['recipes']);
    final newPhotos = <int, String>{};
    for (final r in recipes) {
      final photo = r['photo'] as String?;
      if (photo == null || !_photoName.hasMatch(photo)) continue;
      final file = archive.findFile(photo);
      if (file == null) continue;
      newPhotos[r['id'] as int] = await photos.saveBytes(file.content, p.extension(photo));
    }

    final oldPhotos = replace ? [for (final r in await db.allRecipes()) ?r.photoPath] : const <String>[];
    final ImportResult result;
    try {
      result = await db.transaction(() => _write(data, recipes, newPhotos, replace: replace));
    } on Object {
      for (final photo in newPhotos.values) {
        await photos.delete(photo);
      }
      rethrow;
    }
    final unused = {...newPhotos.values};
    for (final r in await db.allRecipes()) {
      unused.remove(r.photoPath);
    }
    for (final photo in [...oldPhotos, ...unused]) {
      await photos.delete(photo);
    }
    return result;
  }

  Future<ImportResult> _write(
    Map<String, Object?> data,
    List<Map<String, Object?>> recipes,
    Map<int, String> newPhotos, {
    required bool replace,
  }) async {
    if (replace) {
      await db.delete(db.recipes).go();
      await db.delete(db.pantryItems).go();
      if (data['tags'] is List) await db.delete(db.tags).go();
      await (db.delete(db.foods)..where((f) => f.source.equals('user'))).go();
      await (db.delete(db.appSettings)..where((s) => s.key.isNotIn(_localOnlySettings))).go();
    }

    final foods = [
      for (final f in _list(data['foods']))
        FoodsCompanion.insert(
          key: f['key'] as String,
          source: f['source'] as String,
          sourceId: f['sourceId'] as String,
          name: f['name'] as String,
          detail: Value(f['detail'] as String?),
          nutrients: f['nutrients'] as String,
          portions: Value(f['portions'] as String? ?? '[]'),
          densityGPerMl: Value((f['densityGPerMl'] as num?)?.toDouble()),
          fetchedAt: _parseDate(f['fetchedAt']),
        ),
    ];
    await db.batch((b) {
      if (replace) {
        b.insertAllOnConflictUpdate(db.foods, foods);
      } else {
        b.insertAll(db.foods, foods, mode: InsertMode.insertOrIgnore);
      }
    });

    final tagIds = <String, int>{};
    for (final name in [for (final t in data['tags'] as List? ?? const []) t as String]) {
      tagIds[_nameKey(name)] = await db.addTag(name);
    }
    Future<List<int>> tagsFor(Map<String, Object?> recipe) async => [
      for (final name in [for (final t in recipe['tags'] as List? ?? const []) t as String])
        tagIds[_nameKey(name)] ??= await db.addTag(name),
    ];

    final existing = {for (final r in await db.allRecipes()) _nameKey(r.name): r.id};
    final ids = <int, int>{};
    var added = 0;
    var skipped = 0;
    for (final r in recipes) {
      final oldId = r['id'] as int;
      final known = existing[_nameKey(r['name'] as String)];
      if (known != null) {
        ids[oldId] = known;
        skipped++;
        continue;
      }
      final id = await db.saveRecipe(
        RecipeDraft(
          name: r['name'] as String,
          portions: r['portions'] as int? ?? 1,
          prepMinutes: r['prepMinutes'] as int?,
          cookMinutes: r['cookMinutes'] as int?,
          cookingInfo: r['cookingInfo'] as String? ?? '',
          isFavorite: r['isFavorite'] as bool? ?? false,
          photoPath: newPhotos[oldId],
          finishedWeightG: (r['finishedWeightG'] as num?)?.toDouble(),
          sourceUrl: r['sourceUrl'] as String?,
          ingredients: [
            for (final i in _list(r['ingredients']))
              IngredientDraft(
                name: i['name'] as String,
                amount: (i['amount'] as num).toDouble(),
                unit: i['unit'] as String,
                foodKey: i['foodKey'] as String?,
              ),
          ],
          steps: [for (final s in r['steps'] as List? ?? const []) s as String],
          tagIds: await tagsFor(r),
        ),
      );
      if (r['createdAt'] != null) {
        await (db.update(
          db.recipes,
        )..where((x) => x.id.equals(id))).write(RecipesCompanion(createdAt: Value(_parseDate(r['createdAt']))));
      }
      existing[_nameKey(r['name'] as String)] = id;
      ids[oldId] = id;
      added++;
    }

    final known = {for (final m in await db.select(db.mealLogs).get()) (m.recipeId, _second(m.eatenAt))};
    var meals = 0;
    for (final m in _list(data['meals'])) {
      final id = ids[m['recipeId'] as int?];
      if (id == null) continue;
      final at = _parseDate(m['eatenAt']);
      if (!known.add((id, _second(at)))) continue;
      await db.logMeal(id, at);
      meals++;
    }

    final pantry = {for (final i in await db.pantry()) _nameKey(i.name)};
    for (final i in _list(data['pantry'])) {
      final name = i['name'] as String;
      if (!pantry.add(_nameKey(name))) continue;
      await db.addPantryItem(name, foodKey: i['foodKey'] as String?);
    }

    if (replace) {
      final settings = data['settings'] as Map<String, Object?>? ?? const {};
      for (final MapEntry(:key, :value) in settings.entries) {
        if (_localOnlySettings.contains(key) || _deviceSettings.contains(key) || value is! String) continue;
        await db.setSetting(key, value);
      }
    }
    return ImportResult(added: added, skipped: skipped, meals: meals);
  }

  static String _nameKey(String name) => name.trim().toLowerCase();

  static int _second(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;
}
