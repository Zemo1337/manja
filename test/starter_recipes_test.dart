import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/data/profile_backup.dart';
import 'package:manja/data/recipe_foods.dart';
import 'package:manja/data/starter_recipes.dart';
import 'package:manja/l10n/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<(AppDatabase, ProfileBackup)> phone(String language) async {
    final db = AppDatabase(
      DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
      builtInTagNames(lookupAppLocalizations(Locale(language))),
    );
    addTearDown(db.close);
    final dir = Directory.systemTemp.createTempSync('manja_starter_');
    addTearDown(() => dir.deleteSync(recursive: true));
    return (db, ProfileBackup(db, PhotoStore(dir)));
  }

  test('the starter recipes arrive once, with photos, links and the phone language tags', () async {
    final (db, backup) = await phone('de');
    expect(await importStarterRecipes(backup, 'de'), isTrue, reason: 'falls back to the English set');
    final recipes = {for (final r in await db.allRecipes()) r.name: r};
    expect(
      recipes.keys,
      unorderedEquals([
        'Manja Pizza',
        'Manja Apple Pie',
        'Manja Pumpkin Compote',
        'Manja Baked Feta and Tomatoes',
        'Pizza dough',
      ]),
    );
    for (final r in recipes.values) {
      expect(backup.photos.file(r.photoPath!).existsSync(), isTrue, reason: r.name);
    }
    final dough = (await db.allRecipeIngredients()).firstWhere(
      (i) => i.recipeId == recipes['Manja Pizza']!.id && i.name == 'Pizza dough',
    );
    expect(dough.foodKey, recipeFoodKey(recipes['Pizza dough']!.id));

    final tags = {for (final t in await db.allTags()) t.id: t};
    expect(tags.length, 7, reason: 'no English tags next to the German ones');
    final byRecipe = await db.tagsByRecipe();
    expect([for (final id in byRecipe[recipes['Pizza dough']!.id]!) tags[id]!.kind], [TagKind.ingredient]);
    expect(
      [for (final id in byRecipe[recipes['Manja Apple Pie']!.id]!) tags[id]!.name],
      [lookupAppLocalizations(const Locale('de')).tagNameDessert],
    );

    await db.deleteRecipe(recipes['Manja Pumpkin Compote']!.id);
    expect(await importStarterRecipes(backup, 'de'), isFalse);
    expect(await db.allRecipes(), hasLength(4), reason: 'deleted starter recipes stay deleted');
  });

  test('replacing the profile from a backup does not bring them back', () async {
    final (other, otherBackup) = await phone('en');
    await other.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    final bytes = await otherBackup.export();

    final (db, backup) = await phone('en');
    await importStarterRecipes(backup, 'en');
    await backup.import(bytes, replace: true);
    expect(await importStarterRecipes(backup, 'en'), isFalse);
    expect([for (final r in await db.allRecipes()) r.name], ['Sarma']);
  });
}
