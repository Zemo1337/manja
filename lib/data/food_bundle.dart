import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_usda/nutrition_usda.dart';

import 'nutrition_repository.dart';

const usdaBundleAsset = 'assets/food/usda.json';

({String version, List<Food> foods}) decodeFoodBundle(Uint8List bytes) =>
    decodeUsdaBundle(jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>);

Future<bool> importBundledFoods(NutritionRepository repo, {AssetBundle? bundle}) async {
  final data = await (bundle ?? rootBundle).load(usdaBundleAsset);
  final decoded = await compute(decodeFoodBundle, data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  return repo.importBundle(decoded.version, decoded.foods);
}
