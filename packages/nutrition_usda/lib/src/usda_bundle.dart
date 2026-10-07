import 'package:nutrition_core/nutrition_core.dart';

import 'usda_food_parser.dart';

const usdaBundleFormat = 1;

List<Food> parseUsdaBulk(Map<String, dynamic> json) => [
      for (final key in const ['FoundationFoods', 'SRLegacyFoods'])
        for (final f in (json[key] as List? ?? const []))
          if (f is Map<String, dynamic>) parseUsdaFood(f),
    ];

Map<String, dynamic> encodeUsdaBundle(List<Food> foods, {required String version}) => {
      'format': usdaBundleFormat,
      'version': version,
      'foods': [
        for (final f in foods)
          [
            f.sourceId,
            f.name,
            f.detail ?? '',
            f.per100g.toJson(),
            [for (final p in f.portions) p.toJson()],
          ],
      ],
    };

({String version, List<Food> foods}) decodeUsdaBundle(Map<String, dynamic> json) {
  if (json['format'] != usdaBundleFormat) throw FormatException('Unsupported bundle format ${json['format']}');
  return (
    version: json['version'] as String,
    foods: [
      for (final row in json['foods'] as List)
        Food(
          source: FoodSource.usda,
          sourceId: row[0] as String,
          name: row[1] as String,
          detail: (row[2] as String).isEmpty ? null : row[2] as String,
          per100g: Nutrients.fromJson(row[3] as Map<String, dynamic>),
          portions: [for (final p in row[4] as List) FoodPortion.fromJson(p as Map<String, dynamic>)],
        ),
    ],
  );
}
