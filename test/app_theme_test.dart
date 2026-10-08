import 'dart:io';
import 'dart:math';

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
import 'package:manja_manja/ui/app_theme.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  group('colour contrast (WCAG AA, 4.5:1 for text)', () {
    for (final kind in AppThemeKind.values) {
      for (final brightness in Brightness.values) {
        if (kind.alwaysDark && brightness == Brightness.light) continue;
        test('${kind.label} ${brightness.name}', () {
          final s = appColorScheme(kind, brightness);
          final pairs = {
            'primary': (s.primary, s.onPrimary),
            'secondary': (s.secondary, s.onSecondary),
            'primaryContainer': (s.primaryContainer, s.onPrimaryContainer),
            'secondaryContainer': (s.secondaryContainer, s.onSecondaryContainer),
            'tertiaryContainer': (s.tertiaryContainer, s.onTertiaryContainer),
            'surface': (s.surface, s.onSurface),
            'surface variant text': (s.surface, s.onSurfaceVariant),
            'surfaceContainerHighest': (s.surfaceContainerHighest, s.onSurface),
            'surfaceContainerHighest variant text': (s.surfaceContainerHighest, s.onSurfaceVariant),
            'primary text on surface': (s.surface, s.primary),
          };
          for (final MapEntry(key: name, value: (bg, fg)) in pairs.entries) {
            expect(contrast(bg, fg), greaterThanOrEqualTo(4.5), reason: '$name ${contrast(bg, fg).toStringAsFixed(2)}');
          }
        });
      }
    }
  });

  test('dev theme uses the requested colours and is always dark', () {
    final s = appColorScheme(AppThemeKind.dev, Brightness.light);
    expect(s.brightness, Brightness.dark);
    expect(s.surface, const Color.fromARGB(255, 32, 32, 32));
    expect(s.primary, const Color.fromARGB(255, 255, 211, 0));
  });

  testWidgets('the app theme and mode are applied immediately and saved', (tester) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final appearance = AppearanceController(db);
    await tester.pumpWidget(AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(Directory.systemTemp),
      nutrition: NutritionRepository(db),
      appearance: appearance,
      child: const ManjaManjaApp(),
    ));
    await tester.pumpAndSettle();
    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app().themeMode, ThemeMode.system);
    expect(app().theme!.colorScheme.primary, appColorScheme(AppThemeKind.manja, Brightness.light).primary);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(app().themeMode, ThemeMode.dark);

    await tester.tap(find.text('Dev'));
    await tester.pumpAndSettle();
    expect(app().darkTheme!.colorScheme.primary, const Color(0xFFFFD300));
    expect(find.text('The Dev theme is always dark.'), findsOneWidget);
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(app().themeMode, ThemeMode.dark, reason: 'mode is locked for Dev');

    final reloaded = AppearanceController(db);
    await reloaded.load();
    expect(reloaded.theme, AppThemeKind.dev);
    expect(reloaded.brightness, AppBrightness.dark);
  });
}
