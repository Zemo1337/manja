import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/data/profile_backup.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/settings/backup_screen.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('a saved profile can be added to or replace the recipes', (tester) async {
    AppDatabase memory() => AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    final other = memory();
    addTearDown(other.close);
    final photos = PhotoStore(Directory.systemTemp);
    await other.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    await other.saveRecipe(RecipeDraft(name: 'Burek', portions: 2));
    final profile = await ProfileBackup(other, photos).export();

    final db = memory();
    addTearDown(db.close);
    await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    await db.saveRecipe(RecipeDraft(name: 'Grah', portions: 4));
    String? savedName;
    Uint8List? saved;
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: photos,
        nutrition: NutritionRepository(db),
        child: MaterialApp(
          home: BackupScreen(
            pick: () async => profile,
            save: (name, bytes) async {
              savedName = name;
              saved = bytes;
              return true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Save to file'));
    await tester.pumpAndSettle();
    expect(savedName, endsWith('.manja'));
    expect(ProfileBackup(db, photos).read(saved!).recipes, 2);
    expect(find.text('Profile saved'), findsOneWidget);

    await tester.tap(find.text('Open a profile'));
    await tester.pumpAndSettle();
    expect(find.text('2 recipes'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('1 recipe added, 1 already there'), findsOneWidget);
    expect([for (final r in await db.allRecipes()) r.name]..sort(), ['Burek', 'Grah', 'Sarma']);

    await tester.tap(find.text('Open a profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Replace'));
    await tester.pumpAndSettle();
    expect(find.text('Replace everything?'), findsOneWidget);
    await tester.tap(find.text('Replace everything'));
    await tester.pumpAndSettle();
    expect(find.text('2 recipes added'), findsOneWidget);
    expect([for (final r in await db.allRecipes()) r.name]..sort(), ['Burek', 'Sarma']);
  });
}
