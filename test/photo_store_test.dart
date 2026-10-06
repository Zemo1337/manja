import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory temp;

  setUp(() => temp = Directory.systemTemp.createTempSync('manja_test_'));
  tearDown(() => temp.deleteSync(recursive: true));

  group('photo store', () {
    test('copies the photo under a relative path and deletes it again', () async {
      final source = File(p.join(temp.path, 'pick.JPG'))..writeAsBytesSync([1, 2, 3]);
      final store = PhotoStore(Directory(p.join(temp.path, 'app')));

      final relative = await store.save(source.path);
      expect(relative, startsWith('photos/'));
      expect(relative, endsWith('.jpg'));
      expect(p.isRelative(relative), isTrue);
      expect(store.file(relative).readAsBytesSync(), [1, 2, 3]);
      expect(source.existsSync(), isTrue, reason: 'the original pick is left alone');

      await store.delete(relative);
      expect(store.file(relative).existsSync(), isFalse);
      await store.delete(relative);
      await store.delete(null);
    });

    test('two saves never collide', () async {
      final source = File(p.join(temp.path, 'a.png'))..writeAsBytesSync([0]);
      final store = PhotoStore(temp);
      final a = await store.save(source.path);
      final b = await store.save(source.path);
      expect(a, isNot(b));
    });
  });

  group('database', () {
    test('saves and clears the photo path', () async {
      final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
      addTearDown(db.close);
      final id = await db.saveRecipe(RecipeDraft(name: 'Burek', portions: 4, photoPath: 'photos/x.jpg'));
      expect((await db.recipeFull(id))!.recipe.photoPath, 'photos/x.jpg');
      await db.saveRecipe(RecipeDraft(id: id, name: 'Burek', portions: 4));
      expect((await db.recipeFull(id))!.recipe.photoPath, isNull);
    });

    test('upgrading a version 1 database keeps recipes and adds the photo column', () async {
      final file = File(p.join(temp.path, 'v1.sqlite'));
      final v1 = NativeDatabase(file, setup: (raw) {
        raw.execute('''
          CREATE TABLE recipes (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            portions INTEGER NOT NULL DEFAULT 1,
            prep_minutes INTEGER NULL,
            cook_minutes INTEGER NULL,
            cooking_info TEXT NOT NULL DEFAULT '',
            is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1)),
            created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
          );
        ''');
        raw.execute("INSERT INTO recipes (name, portions) VALUES ('Sarma', 6);");
        raw.execute('PRAGMA user_version = 1;');
      });
      await v1.ensureOpen(_NoUser());
      await v1.close();

      final db = AppDatabase(NativeDatabase(file));
      addTearDown(db.close);
      final recipes = await db.allRecipes();
      expect(recipes.single.name, 'Sarma');
      expect(recipes.single.photoPath, isNull);
    });
  });
}

class _NoUser extends QueryExecutorUser {
  @override
  int get schemaVersion => 1;

  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) async {}
}
