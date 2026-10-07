import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_usda/nutrition_usda.dart';
import 'package:test/test.dart';

Map<String, dynamic> fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync()) as Map<String, dynamic>;

void main() {
  group('parser', () {
    test('SR Legacy milk: nutrients and text portions', () {
      final milk = parseUsdaFood(fixture('sr_milk.json'));
      expect(milk.source, FoodSource.usda);
      expect(milk.sourceId, '171265');
      expect(milk.name, startsWith('Milk, whole'));
      expect(milk.per100g[Nutrient.energy], 61);
      expect(milk.per100g[Nutrient.protein], closeTo(3.15, 1e-9));
      expect(milk.per100g.has(Nutrient.sodium), isTrue);
      final cup = milk.portions.firstWhere((p) => p.unit == CookingUnit.cup);
      expect(cup.grams, 244);
      expect(cup.label, '1 cup');
      expect(milk.portions.map((p) => p.unit), containsAll([CookingUnit.tbsp, CookingUnit.flOz, CookingUnit.quart]));
      expect(gramsFor(milk, 250, CookingUnit.ml), closeTo(250 * 244 / 236.5882365, 1e-6));
    });

    test('SR Legacy flour converts cups to grams', () {
      final flour = parseUsdaFood(fixture('sr_flour.json'));
      expect(flour.per100g[Nutrient.energy], 364);
      expect(gramsFor(flour, 2, CookingUnit.cup), closeTo(250, 1e-9));
      expect(flour.detail, contains('SR Legacy'));
    });

    test('Foundation egg: weight and reference portions are skipped', () {
      final egg = parseUsdaFood(fixture('foundation_egg.json'));
      expect(egg.per100g[Nutrient.energy], 150);
      expect(egg.per100g.has(Nutrient.fiber), isFalse);
      expect(egg.portions, isEmpty);
    });

    test('energy falls back to the Atwater value', () {
      final food = parseUsdaFood({
        'fdcId': 1,
        'description': 'Test',
        'foodNutrients': [
          {'nutrient': {'id': 2047}, 'amount': 120},
          {'nutrient': {'id': 1003}, 'amount': 5},
        ],
      });
      expect(food.per100g[Nutrient.energy], 120);
    });

    test('portion words are mapped to cooking units', () {
      FoodPortion? p(String modifier, {String unit = 'undetermined', double grams = 10}) => parseUsdaPortion({
            'gramWeight': grams,
            'amount': 1,
            'modifier': modifier,
            'measureUnit': {'name': unit},
          });
      expect(p('tbsp')!.unit, CookingUnit.tbsp);
      expect(p('cup, chopped')!.unit, CookingUnit.cup);
      expect(p('fl oz')!.unit, CookingUnit.flOz);
      expect(p('large')!.unit, isNull);
      expect(p('large')!.label, '1 large');
      expect(p('', unit: 'slice')!.unit, CookingUnit.slice);
      expect(p('', unit: 'oz'), isNull);
      expect(p('', unit: 'RACC'), isNull);
      expect(p('cup', grams: 0), isNull);
    });
  });

  group('bundle', () {
    test('bulk files are parsed, empty entries skipped, and the bundle round-trips', () {
      final bulk = {
        'FoundationFoods': [fixture('foundation_egg.json'), null],
        'SRLegacyFoods': [fixture('sr_milk.json'), fixture('sr_flour.json')],
      };
      final foods = parseUsdaBulk(bulk);
      expect(foods.map((f) => f.sourceId), ['323604', '171265', '168894']);

      final encoded = jsonDecode(jsonEncode(encodeUsdaBundle(foods, version: 'test')));
      final decoded = decodeUsdaBundle(encoded as Map<String, dynamic>);
      expect(decoded.version, 'test');
      for (final (i, f) in decoded.foods.indexed) {
        expect(f.key, foods[i].key);
        expect(f.name, foods[i].name);
        expect(f.detail, foods[i].detail);
        expect(f.per100g, foods[i].per100g);
        expect(f.portions.map((p) => (p.label, p.grams, p.unit, p.amount)),
            foods[i].portions.map((p) => (p.label, p.grams, p.unit, p.amount)));
      }
    });

    test('unknown bundle formats are rejected', () {
      expect(() => decodeUsdaBundle({'format': 99, 'version': 'x', 'foods': []}), throwsFormatException);
    });
  });

  group('source', () {
    late List<Uri> requests;

    UsdaSource source(http.Response Function(Uri) handler) => UsdaSource(
          apiKey: 'test-key',
          client: MockClient((request) async {
            requests.add(request.url);
            return handler(request.url);
          }),
        );

    setUp(() => requests = []);

    test('search sends the query, data types and key', () async {
      final usda = source((_) => http.Response(jsonEncode(fixture('search_flour.json')), 200));
      final results = await usda.search(' wheat flour ', limit: 3);
      expect(results, hasLength(3));
      expect(results.first.sourceId, '168944');
      expect(results.first.detail, 'SR Legacy · Cereal Grains and Pasta');
      final q = requests.single.queryParameters;
      expect(requests.single.path, '/fdc/v1/foods/search');
      expect(q['query'], 'wheat flour');
      expect(q['dataType'], 'Foundation,SR Legacy');
      expect(q['pageSize'], '3');
      expect(q['api_key'], 'test-key');
    });

    test('an empty query does not call the API', () async {
      final usda = source((_) => throw StateError('no request expected'));
      expect(await usda.search('   '), isEmpty);
      expect(requests, isEmpty);
    });

    test('fetch parses a food, unknown ids give null', () async {
      final usda = source((url) => url.path.endsWith('/171265')
          ? http.Response(jsonEncode(fixture('sr_milk.json')), 200)
          : http.Response('', 404));
      expect((await usda.fetch('171265'))!.name, startsWith('Milk'));
      expect(await usda.fetch('999'), isNull);
      expect(await usda.fetch('not-a-number'), isNull);
      expect(requests, hasLength(2));
    });

    test('rate limit and bad key become readable errors', () async {
      final limited = source((_) => http.Response('', 429));
      await expectLater(
        limited.search('egg'),
        throwsA(isA<NutritionSourceException>()
            .having((e) => e.message, 'message', contains('limit'))
            .having((e) => e.kind, 'kind', NutritionErrorKind.rateLimited)),
      );
      final rejected = source((_) => http.Response('', 403));
      await expectLater(
        rejected.fetch('1'),
        throwsA(isA<NutritionSourceException>()
            .having((e) => e.message, 'message', contains('API key'))
            .having((e) => e.kind, 'kind', NutritionErrorKind.unauthorized)),
      );
    });

    test('network failures become NutritionSourceException', () async {
      final offline = source((_) => throw http.ClientException('offline'));
      await expectLater(
        offline.search('egg'),
        throwsA(isA<NutritionSourceException>().having((e) => e.kind, 'kind', NutritionErrorKind.unreachable)),
      );
    });

    test('the key can be changed and the demo key is recognised', () async {
      final usda = source((_) => http.Response(jsonEncode(fixture('search_flour.json')), 200));
      expect(usda.usingDemoKey, isFalse);
      usda.apiKey = UsdaSource.demoKey;
      expect(usda.usingDemoKey, isTrue);
      await usda.search('flour');
      expect(requests.single.queryParameters['api_key'], 'DEMO_KEY');
    });
  });
}
