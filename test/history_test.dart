import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/main.dart';
import 'package:manja/ui/history/history_screen.dart';
import 'package:manja/ui/wheel/wheel_painter.dart';

AppDatabase _memory() {
  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  addTearDown(db.close);
  return db;
}

void _tall(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('history groups by month, finds dishes without diacritics and can undo a delete', (tester) async {
    _tall(tester);
    final db = _memory();
    final sarma = await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    final cevapi = await db.saveRecipe(RecipeDraft(name: 'Ćevapi', portions: 4));
    await db.logMeal(sarma, DateTime(2026, 8, 20, 19));
    await db.logMeal(cevapi, DateTime(2026, 9, 3, 18));
    await db.logMeal(sarma, DateTime(2026, 9, 28, 19));
    await db.logMeal(sarma, DateTime(2026, 10, 2, 20));
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        child: const MaterialApp(home: HistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('October 2026 · 1 meal'), findsOneWidget);
    expect(find.text('September 2026 · 2 meals'), findsOneWidget);
    expect(find.text('August 2026 · 1 meal'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'cev');
    await tester.pumpAndSettle();
    expect(find.text('Ćevapi'), findsOneWidget);
    expect(find.text('Sarma'), findsNothing);
    expect(find.text('1 meal on 03.09.2026'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'sarma');
    await tester.pumpAndSettle();
    expect(find.text('3 meals, last on 02.10.2026'), findsOneWidget);

    await tester.drag(find.text('Sarma').first, const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 meals, last on 28.09.2026'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('3 meals, last on 02.10.2026'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Ćevapi'), findsOneWidget);
  });

  testWidgets('the wheel picks up a renamed dish or a new photo without a restart', (tester) async {
    _tall(tester);
    final db = _memory();
    final id = await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    await db.saveRecipe(RecipeDraft(name: 'Grah', portions: 4));
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        child: const ManjaApp(),
      ),
    );
    await tester.pumpAndSettle();
    List<String> labels() => [
      for (final w in tester.widgetList<CustomPaint>(find.byType(CustomPaint)))
        if (w.painter case final WheelPainter p) ...[for (final s in p.slices) s.label],
    ];
    expect(labels(), containsAll(['Sarma', 'Grah']));

    await db.saveRecipe(RecipeDraft(id: id, name: 'Sarma od kiselog kupusa', portions: 4, photoPath: 'photos/new.jpg'));
    await tester.pumpAndSettle();
    expect(labels(), containsAll(['Sarma od kiselog kupusa', 'Grah']));
  });
}
