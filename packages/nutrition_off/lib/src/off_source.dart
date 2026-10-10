import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nutrition_core/nutrition_core.dart';

import 'off_product_parser.dart';

class OffSource implements NutritionSource {
  OffSource({
    http.Client? client,
    Uri? baseUri,
    this.userAgent = defaultUserAgent,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client(),
       _base = baseUri ?? Uri.parse('https://world.openfoodfacts.org/');

  static const defaultUserAgent = 'Manja/1.0 (https://github.com/Zemo1337/manja)';
  static const _fields =
      'code,product_name,product_name_en,generic_name,brands,quantity,nutriments,'
      'serving_size,serving_quantity,serving_quantity_unit,product_quantity,product_quantity_unit';

  final String userAgent;
  final Duration timeout;
  final http.Client _client;
  final Uri _base;

  @override
  FoodSource get source => FoodSource.openFoodFacts;

  @override
  Future<List<FoodSummary>> search(String query, {int limit = 25}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final json = await _get('cgi/search.pl', {
      'search_terms': q,
      'search_simple': '1',
      'action': 'process',
      'json': '1',
      'page_size': '$limit',
      'fields': 'code,product_name,product_name_en,generic_name,brands,quantity',
    });
    return [
      for (final p in (json?['products'] as List? ?? const []).cast<Map<String, dynamic>>())
        if (p['code'] case final String code when code.isNotEmpty)
          FoodSummary(
            source: FoodSource.openFoodFacts,
            sourceId: code,
            name: offProductName(p),
            detail: offProductDetail(p),
          ),
    ];
  }

  @override
  Future<Food?> fetch(String sourceId) async {
    final code = normalizeBarcode(sourceId);
    if (code == null) return null;
    final json = await _get('api/v2/product/$code', const {'fields': _fields});
    return json == null ? null : parseOffProduct(json);
  }

  Future<Map<String, dynamic>?> _get(String path, Map<String, String> query) async {
    final uri = _base.resolve(path).replace(queryParameters: query);
    final http.Response response;
    try {
      response = await _client.get(uri, headers: {'User-Agent': userAgent}).timeout(timeout);
    } on TimeoutException catch (e) {
      throw NutritionSourceException(
        'Open Food Facts did not answer in time',
        kind: NutritionErrorKind.unreachable,
        cause: e,
        source: FoodSource.openFoodFacts,
      );
    } on http.ClientException catch (e) {
      throw NutritionSourceException(
        'Could not reach Open Food Facts',
        kind: NutritionErrorKind.unreachable,
        cause: e,
        source: FoodSource.openFoodFacts,
      );
    }
    switch (response.statusCode) {
      case 200:
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      case 404:
        return null;
      case 429:
        throw const NutritionSourceException(
          'Open Food Facts is busy, try again in a minute',
          kind: NutritionErrorKind.rateLimited,
          source: FoodSource.openFoodFacts,
        );
      default:
        throw NutritionSourceException(
          'Open Food Facts returned HTTP ${response.statusCode}',
          source: FoodSource.openFoodFacts,
        );
    }
  }

  void close() => _client.close();
}
