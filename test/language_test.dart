import 'dart:convert';
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
import 'package:manja/domain/units.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/l10n/l10n.dart';
import 'package:manja/main.dart';
import 'package:manja/ui/app_theme.dart';

Map<String, Object?> _arb(String language) =>
    jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync()) as Map<String, Object?>;

Set<String> _placeholders(String message) => {for (final m in RegExp(r'(?<!\w)\{(\w+)[,}]').allMatches(message)) m[1]!};

void main() {
  test('German and Bosnian translate every text, with the same placeholders', () {
    final english = _arb('en');
    final keys = {
      for (final k in english.keys)
        if (!k.startsWith('@')) k,
    };
    for (final language in ['de', 'bs']) {
      final other = _arb(language);
      expect(keys.difference(other.keys.toSet()), isEmpty, reason: '$language is missing these');
      for (final key in keys) {
        expect(
          _placeholders(other[key] as String),
          containsAll(_placeholders(english[key] as String).difference({'count'})),
          reason: '$language $key',
        );
      }
    }
  });

  test('units follow the plural rules of each language', () {
    final bs = lookupAppLocalizations(const Locale('bs'));
    expect(
      [
        for (final n in [1, 2, 5, 21]) CookingUnit.portion.symbolIn(bs, n),
      ],
      ['porcija', 'porcije', 'porcija', 'porcija'],
    );
    final de = lookupAppLocalizations(const Locale('de'));
    expect((CookingUnit.tbsp.symbolIn(de, 2), CookingUnit.pinch.symbolIn(de, 2)), ('EL', 'Prisen'));
    final en = lookupAppLocalizations(const Locale('en'));
    expect((CookingUnit.portion.symbolIn(en, 1), CookingUnit.portion.symbolIn(en, 1.5)), ('portion', 'portions'));
  });

  test('amounts use the decimal comma in German and Bosnian', () {
    addTearDown(() => Intl.defaultLocale = null);
    for (final (locale, text) in [('en', '1.5'), ('de', '1,5'), ('bs', '1,5')]) {
      Intl.defaultLocale = locale;
      expect(formatAmount(1.5), text, reason: locale);
    }
  });

  testWidgets('the language can be chosen in the settings and is kept', (tester) async {
    addTearDown(() => Intl.defaultLocale = null);
    final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    final appearance = AppearanceController(db);
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db),
        appearance: appearance,
        child: const ManjaApp(),
      ),
    );
    await tester.pumpAndSettle();
    Locale locale() => Localizations.localeOf(tester.element(find.byType(Scaffold).first));
    expect(locale().languageCode, 'en');

    await tester.runAsync(() => appearance.setLanguage('de'));
    await tester.pumpAndSettle();
    expect(locale().languageCode, 'de');
    expect(Intl.defaultLocale, 'de');

    final reloaded = AppearanceController(db);
    await tester.runAsync(reloaded.load);
    expect(reloaded.language, 'de');
    await tester.runAsync(() => appearance.setLanguage(null));
    await tester.pumpAndSettle();
    expect(locale().languageCode, 'en');
  });
}
