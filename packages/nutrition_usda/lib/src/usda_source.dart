import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nutrition_core/nutrition_core.dart';

import 'usda_food_parser.dart';

class UsdaSource implements NutritionSource {
  UsdaSource({
    required this.apiKey,
    http.Client? client,
    this.dataTypes = const ['Foundation', 'SR Legacy'],
    Uri? baseUri,
    this.timeout = const Duration(seconds: 15),
  })  : _client = client ?? http.Client(),
        _base = baseUri ?? Uri.parse('https://api.nal.usda.gov/fdc/v1/');

  static const demoKey = 'DEMO_KEY';

  bool get usingDemoKey => apiKey == demoKey;

  String apiKey;
  final List<String> dataTypes;
  final Duration timeout;
  final http.Client _client;
  final Uri _base;

  @override
  FoodSource get source => FoodSource.usda;

  @override
  Future<List<FoodSummary>> search(String query, {int limit = 25}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final json = await _get('foods/search', {
      'query': q,
      'dataType': dataTypes.join(','),
      'pageSize': '$limit',
    });
    return [
      for (final f in (json['foods'] as List? ?? const []))
        FoodSummary(
          source: FoodSource.usda,
          sourceId: '${f['fdcId']}',
          name: f['description'] as String,
          detail: [f['dataType'], f['foodCategory']].whereType<String>().join(' · '),
        ),
    ];
  }

  @override
  Future<Food?> fetch(String sourceId) async {
    if (int.tryParse(sourceId) == null) return null;
    try {
      return parseUsdaFood(await _get('food/$sourceId', const {}));
    } on _NotFound {
      return null;
    }
  }

  Future<Map<String, dynamic>> _get(String path, Map<String, String> query) async {
    final uri = _base.resolve(path).replace(queryParameters: {...query, 'api_key': apiKey});
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(timeout);
    } on TimeoutException catch (e) {
      throw NutritionSourceException('USDA did not answer in time', kind: NutritionErrorKind.unreachable, cause: e);
    } on http.ClientException catch (e) {
      throw NutritionSourceException('Could not reach USDA', kind: NutritionErrorKind.unreachable, cause: e);
    }
    switch (response.statusCode) {
      case 200:
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      case 404:
        throw const _NotFound();
      case 429:
        throw const NutritionSourceException(
          'USDA request limit reached, try again later',
          kind: NutritionErrorKind.rateLimited,
        );
      case 401 || 403:
        throw const NutritionSourceException('USDA rejected the API key', kind: NutritionErrorKind.unauthorized);
      default:
        throw NutritionSourceException('USDA returned HTTP ${response.statusCode}');
    }
  }

  void close() => _client.close();
}

class _NotFound implements Exception {
  const _NotFound();
}
