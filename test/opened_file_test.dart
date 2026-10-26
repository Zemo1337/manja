import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/data/profile_backup.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/l10n/l10n.dart';
import 'package:manja/main.dart';

AppDatabase _memory() {
  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  addTearDown(db.close);
  return db;
}

/// Starts the app the way Android does when a file is opened with Manja: the file waits in the cache.
Future<File> _openWith(WidgetTester tester, List<int> bytes) async {
  final dir = Directory.systemTemp.createTempSync('manja_opened_');
  addTearDown(() => dir.deleteSync(recursive: true));
  final file = File('${dir.path}/opened.manja')..writeAsBytesSync(bytes);
  const channel = MethodChannel('manja/opened_file');
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (call) async => call.method == 'take' ? file.path : null,
  );
  addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null));
  final db = _memory();
  await tester.pumpWidget(
    AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(dir),
      nutrition: NutritionRepository(db),
      child: const ManjaApp(),
    ),
  );
  for (var i = 0; i < 10; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump();
  }
  await tester.pumpAndSettle();
  return file;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final l = lookupAppLocalizations(const Locale('en'));

  testWidgets('a profile opened from another app goes straight to the import', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final phone = _memory();
    await phone.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    final dir = Directory.systemTemp.createTempSync('manja_phone_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final bytes = await ProfileBackup(phone, PhotoStore(dir)).export();

    final file = await _openWith(tester, bytes);
    expect(find.text(l.backupImportTitle), findsOneWidget);
    expect(find.text(l.backupRecipeCount(1)), findsOneWidget);
    expect(file.existsSync(), isFalse, reason: 'the copy in the cache is cleaned up');
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('another file opened with Manja is turned away politely', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await _openWith(tester, [1, 2, 3, 4]);
    expect(find.text(l.backupImportTitle), findsNothing);
    expect(find.text(l.backupNotAProfile), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
