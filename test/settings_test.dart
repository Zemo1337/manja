import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/main.dart';

void main() {
  late AppDatabase db;
  late WheelService wheel;

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    wheel = WheelService(db);
    await db.saveRecipe(RecipeDraft(name: 'Sarma', portions: 4));
    await tester.pumpWidget(AppScope(
      db: db,
      wheel: wheel,
      photos: PhotoStore(Directory.systemTemp),
      nutrition: NutritionRepository(db),
      child: const ManjaManjaApp(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('wheel look changes are saved immediately', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wheel look'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Text'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep names upright'));
    await tester.pumpAndSettle();

    final look = await wheel.loadAppearance();
    expect(look.theme, WheelThemeKind.pizza);
    expect(look.content, WheelContent.text);
    expect(look.flipText, isFalse);
  });

  testWidgets('wheel round rules are saved immediately', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wheel rounds'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(ResetMode.afterDays.label));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('More days'));
    await tester.pumpAndSettle();

    final settings = await wheel.loadSettings();
    expect(settings.mode, ResetMode.afterDays);
    expect(settings.resetDays, 8);
  });

  testWidgets('the wheel settings button opens the wheel look page', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Wheel look'));
    await tester.pumpAndSettle();
    expect(find.text('Show on the wheel'), findsOneWidget);
  });
}
