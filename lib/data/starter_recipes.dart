import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'profile_backup.dart';

const starterRecipesSetting = 'app.starterRecipes';

String starterRecipesAsset(String language) => 'assets/starter/starter_$language.manja';

/// Adds the recipes that ship with the app, once. Deleted ones stay deleted.
Future<bool> importStarterRecipes(ProfileBackup backup, String language, {AssetBundle? bundle}) async {
  final db = backup.db;
  if (await db.getSetting(starterRecipesSetting) != null) return false;
  final assets = bundle ?? rootBundle;
  final ByteData data;
  try {
    data = await assets.load(starterRecipesAsset(language));
  } on FlutterError {
    if (language == 'en') rethrow;
    return importStarterRecipes(backup, 'en', bundle: assets);
  }
  await backup.import(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), replace: false);
  await db.setSetting(starterRecipesSetting, '1');
  return true;
}
