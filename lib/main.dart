import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_usda/nutrition_usda.dart';
import 'package:path_provider/path_provider.dart';

import 'app_scope.dart';
import 'config.dart';
import 'data/database.dart';
import 'data/food_bundle.dart';
import 'data/nutrition_repository.dart';
import 'data/photo_store.dart';
import 'domain/wheel_service.dart';
import 'ui/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final photos = PhotoStore(await getApplicationSupportDirectory());
  final nutrition = NutritionRepository(db, remotes: {FoodSource.usda: UsdaSource(apiKey: usdaApiKey)});
  runApp(AppScope(db: db, wheel: WheelService(db), photos: photos, nutrition: nutrition, child: const ManjaManjaApp()));
  unawaited(importBundledFoods(nutrition).catchError((Object e) {
    debugPrint('Built-in foods could not be imported: $e');
    return false;
  }));
}

class ManjaManjaApp extends StatelessWidget {
  const ManjaManjaApp({super.key});

  static const _seed = Color(0xFFE4572E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manja Manja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.light),
      darkTheme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark),
      home: const HomeShell(),
    );
  }
}
