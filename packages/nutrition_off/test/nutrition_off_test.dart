import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_off/nutrition_off.dart';
import 'package:test/test.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

void main() {
  group('barcodes', () {
    test('EAN-8, EAN-13 and UPC with spaces or dashes are accepted', () {
      expect(normalizeBarcode('3850104051029'), '3850104051029');
      expect(normalizeBarcode(' 385-0104 051029 '), '3850104051029');
      expect(normalizeBarcode('20528447'), '20528447');
      expect(normalizeBarcode('1234567'), isNull);
      expect(normalizeBarcode('ajvar'), isNull);
    });
  });

  group('product', () {
    test('a real product becomes a food per 100 g with serving and package', () {
      final food = parseOffProduct(jsonDecode(fixture('ajvar_product.json')) as Map<String, dynamic>)!;
      expect(food.key, 'off:3850104051029');
      expect(food.name, 'Ajvar (mild)');
      expect(food.detail, 'Podravka · 350g');
      expect(food.per100g[Nutrient.energy], 78);
      expect(food.per100g[Nutrient.protein], 1.5);
      expect(food.per100g[Nutrient.sugars], 8);
      expect(food.per100g[Nutrient.sodium], closeTo(600, 1e-9), reason: 'from 1.5 g salt, the label value');
      expect(
        [for (final p in food.portions) (p.label, p.grams)],
        [('serving (1 serving (100 g))', 100.0), ('package (350 g)', 350.0)],
      );
    });

    test('energy falls back to kJ and missing values stay missing', () {
      final food = parseOffProduct({
        'status': 1,
        'product': {
          'code': '20528447',
          'product_name': '',
          'product_name_en': 'Ajvar',
          'nutriments': {'energy-kj_100g': 418.4, 'fat_100g': '2,5'},
          'product_quantity': 360,
          'product_quantity_unit': 'ml',
        },
      })!;
      expect(food.name, 'Ajvar');
      expect(food.per100g[Nutrient.energy], closeTo(100, 1e-9));
      expect(food.per100g[Nutrient.fat], 2.5);
      expect(food.per100g.has(Nutrient.protein), isFalse);
      expect(food.portions, isEmpty, reason: 'a package in ml has no weight');
    });

    test('unknown products give null', () {
      expect(parseOffProduct({'status': 0, 'status_verbose': 'product not found'}), isNull);
    });
  });

  group('source', () {
    late List<http.Request> requests;
    OffSource source(http.Response Function(http.Request) answer) {
      requests = [];
      return OffSource(
        client: MockClient((r) async {
          requests.add(r);
          return answer(r);
        }),
      );
    }

    test('search asks with a user agent and returns summaries', () async {
      final off = source((_) => http.Response.bytes(utf8.encode(fixture('ajvar_search.json')), 200));
      final results = await off.search('podravka ajvar', limit: 5);
      expect(results.first.key, 'off:3850104051029');
      expect(results.first.name, 'Ajvar (mild)');
      expect(results, hasLength(5));
      expect(requests.single.headers['User-Agent'], OffSource.defaultUserAgent);
      expect(requests.single.url.queryParameters['search_terms'], 'podravka ajvar');
    });

    test('fetch reads a product by barcode; unknown and invalid codes give null', () async {
      final off = source(
        (r) => r.url.path.endsWith('3850104051029')
            ? http.Response.bytes(utf8.encode(fixture('ajvar_product.json')), 200)
            : http.Response('{"status":0}', 404),
      );
      expect((await off.fetch('3850104051029'))?.name, 'Ajvar (mild)');
      expect(await off.fetch('4000000000000'), isNull);
      expect(await off.fetch('not a code'), isNull);
      expect(requests, hasLength(2));
    });

    test('busy and unreachable servers become typed errors', () async {
      expect(
        () => source((_) => http.Response('', 429)).search('x'),
        throwsA(
          isA<NutritionSourceException>()
              .having((e) => e.kind, 'kind', NutritionErrorKind.rateLimited)
              .having((e) => e.source, 'source', FoodSource.openFoodFacts),
        ),
      );
      final offline = OffSource(client: MockClient((_) => throw http.ClientException('no network')));
      expect(
        () => offline.fetch('3850104051029'),
        throwsA(isA<NutritionSourceException>().having((e) => e.kind, 'kind', NutritionErrorKind.unreachable)),
      );
    });
  });
}
