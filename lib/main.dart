import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nutrition_core/nutrition_core.dart';
import 'package:nutrition_off/nutrition_off.dart';
import 'package:nutrition_usda/nutrition_usda.dart';
import 'package:path_provider/path_provider.dart';

import 'app_scope.dart';
import 'config.dart';
import 'data/database.dart';
import 'data/food_bundle.dart';
import 'data/nutrition_repository.dart';
import 'data/photo_store.dart';
import 'domain/wheel_service.dart';
import 'ui/app_theme.dart';
import 'ui/settings/about.dart';
import 'ui/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerAppLicenses();
  final db = AppDatabase();
  final photos = PhotoStore(await getApplicationSupportDirectory());
  final nutrition = NutritionRepository(
    db,
    remotes: {FoodSource.usda: UsdaSource(apiKey: usdaApiKey), FoodSource.openFoodFacts: OffSource()},
    buildApiKey: usdaApiKey,
  );
  await nutrition.loadApiKey();
  final appearance = AppearanceController(db);
  await appearance.load();
  runApp(
    AppScope(
      db: db,
      wheel: WheelService(db),
      photos: photos,
      nutrition: nutrition,
      appearance: appearance,
      child: const ManjaApp(),
    ),
  );
  unawaited(
    importBundledFoods(nutrition).catchError((Object e) {
      debugPrint('Built-in foods could not be imported: $e');
      return false;
    }),
  );
}

class ManjaApp extends StatelessWidget {
  const ManjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appearance = AppScope.of(context).appearance;
    return ListenableBuilder(
      listenable: appearance,
      builder: (context, _) => MaterialApp(
        title: 'Manja',
        debugShowCheckedModeBanner: false,
        theme: appTheme(appearance.theme, Brightness.light),
        darkTheme: appTheme(appearance.theme, Brightness.dark),
        themeMode: appearance.themeMode,
        home: const HomeShell(),
      ),
    );
  }
}
