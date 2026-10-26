import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/data/profile_backup.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/l10n/l10n.dart';
import 'package:manja/ui/settings/tags_screen.dart';

AppDatabase _memory() {
  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  addTearDown(db.close);
  return db;
}

PhotoStore _photos() {
  final dir = Directory.systemTemp.createTempSync('manja_tag_');
  addTearDown(() {
    try {
      dir.deleteSync(recursive: true);
    } on FileSystemException {
      // Already gone.
    }
  });
  return PhotoStore(dir);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('recipes tagged Ingredient stay off the wheel unless that tag is chosen', () async {
    final db = _memory();
    final ingredient = (await db.tagOfKind(TagKind.ingredient))!;
    expect(ingredient.name, 'Ingredient');
    final main = (await db.tagByName('Main'))!.id;
    await db.saveRecipe(RecipeDraft(name: 'Burger', portions: 4, tagIds: [main]));
    await db.saveRecipe(RecipeDraft(name: 'Brioche bun', portions: 8, tagIds: [ingredient.id]));
    await db.saveRecipe(RecipeDraft(name: 'Pizza dough', portions: 2, tagIds: [main, ingredient.id]));
    final wheel = WheelService(db);

    List<String> names(WheelState s) => [for (final r in s.available) r.name];
    expect(names(await wheel.computeState()), ['Burger']);
    await wheel.selectTag(ingredient.id);
    expect(names(await wheel.computeState()), ['Brioche bun', 'Pizza dough']);
    await wheel.selectTag(main);
    expect(names(await wheel.computeState()), ['Burger', 'Pizza dough'], reason: 'choosing a tag shows all of it');
  });

  test('upgrading turns an existing "Ingredient" tag into the built-in one', () async {
    final dir = Directory.systemTemp.createTempSync('manja_v7_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/manja.sqlite');
    final v8 = AppDatabase(NativeDatabase(file));
    await v8.customStatement("DELETE FROM tags WHERE kind = 'ingredient'");
    await v8.customStatement('ALTER TABLE tags DROP COLUMN kind');
    await v8.customStatement("INSERT INTO tags (name, position) VALUES ('ingredient', 9)");
    await v8.customStatement('PRAGMA user_version = 7');
    await v8.close();

    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);
    final tags = await upgraded.allTags();
    expect(
      [for (final t in tags) (t.name, t.kind)],
      [for (final kind in TagKind.courses) (englishTagNames[kind], kind), ('ingredient', TagKind.ingredient)],
    );
  });

  testWidgets('the built-in tag can be renamed but not deleted', (tester) async {
    final db = _memory();
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        child: const MaterialApp(home: TagsScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final tile = find.widgetWithText(ListTile, 'Ingredient');
    expect(find.descendant(of: tile, matching: find.byTooltip('Rename')), findsOneWidget);
    expect(find.descendant(of: tile, matching: find.byTooltip('Delete')), findsNothing);
    expect(find.descendant(of: find.widgetWithText(ListTile, 'Snack'), matching: find.byTooltip('Delete')), findsOne);
  });

  test('backups keep the meaning of the tag, even renamed', () async {
    final phone = _memory();
    final ingredient = (await phone.tagOfKind(TagKind.ingredient))!;
    await phone.renameTag(ingredient.id, 'Basics');
    await phone.saveRecipe(RecipeDraft(name: 'Brioche bun', portions: 8, tagIds: [ingredient.id]));
    final bytes = await ProfileBackup(phone, _photos()).export();

    for (final replace in [false, true]) {
      final pc = _memory();
      await ProfileBackup(pc, _photos()).import(bytes, replace: replace);
      final builtIn = (await pc.tagOfKind(TagKind.ingredient))!;
      final bun = (await pc.allRecipes()).single;
      expect([for (final t in await pc.tagsOf(bun.id)) t.id], [builtIn.id], reason: 'replace: $replace');
      expect(builtIn.name, replace ? 'Basics' : 'Ingredient');
      expect((await pc.allTags()).where((t) => t.name == 'Basics'), hasLength(replace ? 1 : 0));
    }
  });

  test('a backup from a phone in another language uses the built-in tags already there', () async {
    final phone = _memory();
    final main = (await phone.tagOfKind(TagKind.main))!;
    await phone.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4, tagIds: [main.id]));
    final bytes = await ProfileBackup(phone, _photos()).export();

    final german = AppDatabase(
      DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
      builtInTagNames(lookupAppLocalizations(const Locale('de'))),
    );
    addTearDown(german.close);
    await ProfileBackup(german, _photos()).import(bytes, replace: false);
    final sarma = (await german.allRecipes()).single;
    expect([for (final t in await german.tagsOf(sarma.id)) t.name], ['Hauptgericht']);
    expect(await german.tagByName('Main'), isNull, reason: 'no English duplicate');
  });
}
