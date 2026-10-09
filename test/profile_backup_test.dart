import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/data/profile_backup.dart';
import 'package:nutrition_core/nutrition_core.dart';

class _Device {
  _Device() {
    addTearDown(db.close);
    addTearDown(() {
      try {
        photos.baseDir.deleteSync(recursive: true);
      } on FileSystemException {
        // Already gone.
      }
    });
  }

  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  final photos = PhotoStore(Directory.systemTemp.createTempSync('manja_backup_'));

  late final backup = ProfileBackup(db, photos);
  late final nutrition = NutritionRepository(db);

  Future<int> recipe(String name, {String? photoBytes, List<IngredientDraft> ingredients = const []}) async {
    String? photo;
    if (photoBytes != null) photo = await photos.saveBytes(utf8.encode(photoBytes), '.jpg');
    return db.saveRecipe(
      RecipeDraft(
        name: name,
        portions: 4,
        prepMinutes: 10,
        photoPath: photo,
        sourceUrl: 'https://example.com/$name',
        ingredients: ingredients,
        steps: ['Cook $name', 'Eat'],
      ),
    );
  }

  Future<List<String>> names() async => [for (final r in await db.allRecipes()) r.name]..sort();
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('a profile moves recipes, photos, meals, pantry, own ingredients and settings', () async {
    final phone = _Device();
    final ajvar = await phone.nutrition.saveUserFood(name: 'Ajvar', per100g: Nutrients.of(energyKcal: 85));
    final sarma = await phone.recipe(
      'Sarma',
      photoBytes: 'cabbage photo',
      ingredients: [IngredientDraft(name: 'ajvar', amount: 2, unit: 'tbsp', foodKey: ajvar.key)],
    );
    await phone.recipe('Grah');
    final eaten = DateTime(2026, 10, 1, 18, 30);
    await phone.db.logMeal(sarma, eaten);
    await phone.db.addPantryItem('Salt');
    await phone.db.setSetting('app.theme', 'dev');
    await phone.nutrition.setUserApiKey('SECRET-KEY-123');

    final bytes = await phone.backup.export(at: DateTime(2026, 10, 9));
    final archive = ZipDecoder().decodeBytes(bytes);
    final json = utf8.decode(archive.findFile('manja.json')!.content);
    expect(json, isNot(contains('SECRET-KEY-123')));
    expect(json, isNot(contains('usdaApiKey')));
    expect(phone.backup.fileName(DateTime(2026, 10, 9)), 'manja-manja-2026-10-09.manja');

    final summary = phone.backup.read(bytes);
    expect([summary.recipes, summary.photos, summary.meals, summary.ownIngredients, summary.pantry], [2, 1, 1, 1, 1]);

    final pc = _Device();
    await pc.nutrition.setUserApiKey('PC-KEY');
    await pc.recipe('Old dish', photoBytes: 'old photo');
    final result = await pc.backup.import(bytes, replace: true);
    expect(result.added, 2);
    expect(await pc.names(), ['Grah', 'Sarma']);
    expect(await pc.nutrition.userApiKey(), 'PC-KEY', reason: 'the own key stays on the device');
    expect(await pc.db.getSetting('app.theme'), 'dev');
    expect([for (final p in await pc.db.pantry()) p.name], ['Salt']);

    final imported = (await pc.db.allRecipes()).singleWhere((r) => r.name == 'Sarma');
    final full = (await pc.db.recipeFull(imported.id))!;
    expect(full.recipe.portions, 4);
    expect(full.recipe.sourceUrl, 'https://example.com/Sarma');
    expect([for (final s in full.steps) s.body], ['Cook Sarma', 'Eat']);
    expect(full.ingredients.single.foodKey, ajvar.key);
    expect(utf8.decode(await pc.photos.file(full.recipe.photoPath!).readAsBytes()), 'cabbage photo');
    expect((await pc.nutrition.food(ajvar.key))?.name, 'Ajvar');
    final meals = await pc.db.select(pc.db.mealLogs).get();
    expect(meals.single.recipeId, imported.id);
    expect(meals.single.eatenAt, eaten);
    final photoFiles = Directory('${pc.photos.baseDir.path}/photos').listSync();
    expect(photoFiles, hasLength(1), reason: 'the replaced recipe photo is removed');
  });

  test('adding skips recipes and meals that are already there', () async {
    final phone = _Device();
    final sarma = await phone.recipe('Sarma');
    await phone.recipe('Burek', photoBytes: 'flaky');
    await phone.db.logMeal(sarma, DateTime(2026, 10, 1));
    await phone.db.addPantryItem('Salt');
    await phone.db.setSetting('app.theme', 'dev');
    final bytes = await phone.backup.export();

    final pc = _Device();
    final own = await pc.recipe('sarma');
    await pc.db.addPantryItem('salt');
    await pc.db.setSetting('app.theme', 'neutral');

    var result = await pc.backup.import(bytes, replace: false);
    expect((result.added, result.skipped, result.meals), (1, 1, 1));
    expect(await pc.names(), ['Burek', 'sarma']);
    expect((await pc.db.select(pc.db.mealLogs).get()).single.recipeId, own);
    expect(await pc.db.pantry(), hasLength(1));
    expect(await pc.db.getSetting('app.theme'), 'neutral', reason: 'adding keeps own settings');

    result = await pc.backup.import(bytes, replace: false);
    expect((result.added, result.skipped, result.meals), (0, 2, 0));
    expect(Directory('${pc.photos.baseDir.path}/photos').listSync(), hasLength(1));
  });

  test('other files are refused', () async {
    final device = _Device();
    expect(() => device.backup.read(utf8.encode('hello')), throwsFormatException);
    final other = ZipEncoder().encodeBytes(Archive()..addFile(ArchiveFile.string('manja.json', '{"format":"x"}')));
    expect(() => device.backup.read(other), throwsFormatException);
    final newer = ZipEncoder().encodeBytes(
      Archive()..addFile(ArchiveFile.string('manja.json', '{"format":"manja-profile","version":99}')),
    );
    expect(
      () => device.backup.read(newer),
      throwsA(isA<FormatException>().having((e) => e.message, 'message', contains('newer version'))),
    );
  });
}
