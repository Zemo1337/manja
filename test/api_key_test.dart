import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:manja_manja/app_scope.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/data/nutrition_repository.dart';
import 'package:manja_manja/data/photo_store.dart';
import 'package:manja_manja/domain/wheel_service.dart';
import 'package:manja_manja/ui/nutrition/food_picker_sheet.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_usda/nutrition_usda.dart';

void main() {
  late AppDatabase db;
  late List<Uri> requests;
  late int status;

  setUp(() {
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    requests = [];
    status = 429;
  });

  tearDown(() => db.close());

  NutritionRepository repo({String buildKey = UsdaSource.demoKey}) => NutritionRepository(
        db,
        buildApiKey: buildKey,
        remotes: {
          FoodSource.usda: UsdaSource(
            apiKey: buildKey,
            client: MockClient((request) async {
              requests.add(request.url);
              return http.Response('{"foods": []}', status);
            }),
          ),
        },
      );

  test('your own key wins over the build key and can be removed again', () async {
    final r = repo();
    expect(await r.loadApiKey(), ApiKeyOrigin.demo);
    expect(r.usingDemoKey, isTrue);

    expect(await r.setUserApiKey('  my-key  '), ApiKeyOrigin.user);
    expect(r.usingDemoKey, isFalse);
    status = 200;
    await r.searchRemote('flour');
    expect(requests.last.queryParameters['api_key'], 'my-key');
    expect(requests.last.queryParameters['pageSize'], '10', reason: 'USDA answers much faster with fewer results');

    expect(await r.setUserApiKey(''), ApiKeyOrigin.demo);
    await r.searchRemote('flour');
    expect(requests.last.queryParameters['api_key'], UsdaSource.demoKey);

    expect(await repo(buildKey: 'dev-key').loadApiKey(), ApiKeyOrigin.developer);
  });

  Future<NutritionRepository> openPicker(WidgetTester tester, {String? userKey}) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final r = repo();
    await r.setUserApiKey(userKey);
    await tester.pumpWidget(AppScope(
      db: db,
      wheel: WheelService(db),
      photos: PhotoStore(Directory.systemTemp),
      nutrition: r,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showFoodPicker(context, initialQuery: 'ajvar'),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(requests, isEmpty, reason: 'typing never calls USDA');
    await tester.tap(find.text('Search USDA online for "ajvar"'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(requests, hasLength(1));
    return r;
  }

  testWidgets('running out of demo lookups explains how to get a key and lets you enter it', (tester) async {
    final r = await openPicker(tester);
    expect(find.text('Out of free lookups'), findsOneWidget);
    expect(find.textContaining('Oh, hey there buddy'), findsOneWidget);
    expect(find.textContaining('do not share your key publicly'), findsOneWidget);

    await tester.tap(find.text('Enter my key'));
    await tester.pumpAndSettle();
    expect(find.text('Your USDA API key'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'API key'), 'fresh-key');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Your API key is saved'), findsOneWidget);
    expect(r.usingDemoKey, isFalse);
    expect(await r.userApiKey(), 'fresh-key');
  });

  testWidgets('with your own key the limit only shows a short note', (tester) async {
    await openPicker(tester, userKey: 'my-key');
    expect(find.text('Out of free lookups'), findsNothing);
    expect(find.textContaining('hourly USDA limit for your key'), findsOneWidget);
  });
}
