import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:manja/app_scope.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/nutrition_repository.dart';
import 'package:manja/data/photo_store.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/l10n/l10n.dart';
import 'package:manja/main.dart';
import 'package:manja/ui/app_theme.dart';
import 'package:nutrition_core/nutrition_core.dart';

/// Opens the main screens in each language on a small phone; longer German and Bosnian texts must not overflow.
void main() {
  for (final language in ['de', 'bs']) {
    testWidgets('$language texts fit a small phone', (tester) async {
      tester.view
        ..physicalSize = const Size(720, 1280)
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      addTearDown(() => Intl.defaultLocale = null);
      final l = lookupAppLocalizations(Locale(language));
      final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
      addTearDown(db.close);
      final nutrition = NutritionRepository(db);
      final flour = await nutrition.saveUserFood(name: 'Brašno', per100g: Nutrients.of(energyKcal: 364, protein: 10));
      for (final name in ['Sarma', 'Ćevapi', 'Burek']) {
        await db.saveRecipe(
          RecipeDraft(
            name: name,
            portions: 4,
            prepMinutes: 20,
            cookMinutes: 90,
            ingredients: [IngredientDraft(name: 'brašno', amount: 500, unit: 'g', foodKey: flour.key)],
            steps: ['Korak jedan'],
          ),
        );
      }
      await db.setSetting('app.language', language);
      final appearance = AppearanceController(db);
      await tester.runAsync(appearance.load);
      await tester.pumpWidget(
        AppScope(
          db: db,
          wheel: WheelService(db),
          photos: PhotoStore(Directory.systemTemp),
          nutrition: nutrition,
          appearance: appearance,
          child: const ManjaApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(l.navWheel), findsOneWidget);
      Future<void> back() async => tester.state<NavigatorState>(find.byType(Navigator).first).pop();

      await tester.tap(find.text(l.navRecipes));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sarma'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await back();
      await tester.pumpAndSettle();
      await back();
      await tester.pumpAndSettle();

      await tester.tap(find.text(l.navHistory));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l.navSettings));
      await tester.pumpAndSettle();
      for (final title in [l.appearanceTitle, l.backupTitle, l.wheelLookTitle, l.roundsTitle, l.tagsTitle]) {
        await tester.scrollUntilVisible(find.text(title), 100, scrollable: find.byType(Scrollable).last);
        await tester.tap(find.text(title));
        await tester.pumpAndSettle();
        await back();
        await tester.pumpAndSettle();
      }
    });
  }
}
