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
import 'package:manja/ui/wheel/wheel_painter.dart';

void main() {
  testWidgets('the spin takes the chosen time, even when the phone removes animations', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final wheel = WheelService(db);
    await wheel.saveAppearance(const WheelAppearance(spinSeconds: 12, revealMillis: 2000));
    expect((await wheel.loadAppearance()).spinSeconds, 12);
    for (final name in ['Sarma', 'Grah', 'Burek']) {
      await db.saveRecipe(RecipeDraft(name: name, portions: 2));
    }
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: wheel,
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        child: const ManjaApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spin'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 11));
    expect(find.text('Today you cook'), findsNothing, reason: 'still turning after 11 of 12 seconds');
    await tester.pump(const Duration(seconds: 1, milliseconds: 100));
    double winnerSweep() {
      final painter = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((w) => w.painter)
          .whereType<WheelPainter>()
          .single;
      return painter.sweeps[painter.highlight!];
    }

    final early = winnerSweep();
    await tester.pump(const Duration(milliseconds: 600));
    final later = winnerSweep();
    expect(later, greaterThan(early), reason: 'the winner is still growing 0.7 s into a 2 s reveal');
    await tester.pumpAndSettle();
    expect(winnerSweep(), greaterThan(later));
    expect(find.text('Today you cook'), findsOneWidget);
  });

  test('spin time stays within limits', () async {
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final wheel = WheelService(db);
    expect((await wheel.loadAppearance()).spinSeconds, 4);
    expect((await wheel.loadAppearance()).revealMillis, 1000);
    await db.setSetting('wheel.spinSeconds', '999');
    expect((await wheel.loadAppearance()).spinSeconds, WheelAppearance.maxSpinSeconds);
  });
}
