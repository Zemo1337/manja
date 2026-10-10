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
import 'package:manja/ui/nutrition/food_picker_sheet.dart';
import 'package:nutrition_core/nutrition_core.dart';

class _FakeOff implements NutritionSource {
  final lookups = <String>[];
  bool offline = false;

  static final ajvar = Food(
    source: FoodSource.openFoodFacts,
    sourceId: '3850104051029',
    name: 'Ajvar (mild)',
    detail: 'Podravka · 350g',
    per100g: Nutrients.of(energyKcal: 78, sodiumMg: 600),
    portions: const [FoodPortion(label: 'package (350 g)', grams: 350)],
  );

  @override
  FoodSource get source => FoodSource.openFoodFacts;

  @override
  Future<List<FoodSummary>> search(String query, {int limit = 25}) async => [ajvar.summary];

  @override
  Future<Food?> fetch(String sourceId) async {
    lookups.add(sourceId);
    if (offline) {
      throw const NutritionSourceException(
        'no network',
        kind: NutritionErrorKind.unreachable,
        source: FoodSource.openFoodFacts,
      );
    }
    return sourceId == ajvar.sourceId ? ajvar : null;
  }
}

void main() {
  late AppDatabase db;
  late _FakeOff off;
  Food? picked;

  Future<void> pumpPicker(WidgetTester tester, {String query = ''}) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    addTearDown(db.close);
    off = _FakeOff();
    picked = null;
    await tester.pumpWidget(
      AppScope(
        db: db,
        wheel: WheelService(db),
        photos: PhotoStore(Directory.systemTemp),
        nutrition: NutritionRepository(db, remotes: {FoodSource.openFoodFacts: off}),
        child: MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async => picked = await showFoodPicker(context, initialQuery: query),
              child: const Text('Pick'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Pick'));
    await tester.pumpAndSettle();
  }

  testWidgets('a typed barcode links the Open Food Facts product and caches it', (tester) async {
    await pumpPicker(tester);
    await tester.tap(find.text('Enter a package barcode'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '12');
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();
    expect(find.text('A barcode has 8 to 14 digits'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, '3850 1040 51029');
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();

    expect(picked?.key, 'off:3850104051029');
    expect((await db.foodRow('off:3850104051029'))?.name, 'Ajvar (mild)', reason: 'cached for offline use');
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('an unknown barcode offers to create an own ingredient', (tester) async {
    await pumpPicker(tester);
    await tester.tap(find.text('Enter a package barcode'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '4000000000000');
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();
    expect(find.text('Product not found'), findsOneWidget);
    expect(off.lookups, ['4000000000000']);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(picked, isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('store products can be searched by name and show the ODbL notice', (tester) async {
    await pumpPicker(tester, query: 'podravka ajvar');
    expect(find.text('USDA ingredients'), findsNothing, reason: 'only configured sources get a button');
    await tester.tap(find.text('Store products'));
    await tester.pumpAndSettle();
    expect(find.text('Ajvar (mild)'), findsOneWidget);
    expect(find.textContaining('Open Database License'), findsOneWidget);
    await tester.tap(find.text('Ajvar (mild)'));
    await tester.pumpAndSettle();
    expect(picked?.name, 'Ajvar (mild)');
  });

  testWidgets('without internet the picker says so and can retry the same barcode', (tester) async {
    await pumpPicker(tester);
    off.offline = true;
    await tester.tap(find.text('Enter a package barcode'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '3850104051029');
    await tester.tap(find.text('Look up'));
    await tester.pumpAndSettle();
    expect(find.text('Open Food Facts could not be reached. Check your internet connection.'), findsOneWidget);
    expect(find.text('Barcode 3850104051029'), findsOneWidget);

    off.offline = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(picked?.key, 'off:3850104051029');
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));
}
