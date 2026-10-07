import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_usda/nutrition_usda.dart';

import 'nutrition_repository.dart';

const usdaBundleAsset = 'assets/food/usda.json.gz';

({String version, List<Food> foods}) decodeGzipBundle(Uint8List bytes) =>
    decodeUsdaBundle(jsonDecode(utf8.decode(gzip.decode(bytes))) as Map<String, dynamic>);

Future<bool> importBundledFoods(NutritionRepository repo, {AssetBundle? bundle}) async {
  final data = await (bundle ?? rootBundle).load(usdaBundleAsset);
  final decoded = await compute(decodeGzipBundle, data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  return repo.importBundle(decoded.version, decoded.foods);
}
