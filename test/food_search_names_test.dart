import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/data/database.dart';
import 'package:manja/data/food_bundle.dart';
import 'package:manja/data/nutrition_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late NutritionRepository repo;

  setUpAll(() async {
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    repo = NutritionRepository(db);
    final bundle = decodeFoodBundle(File(usdaBundleAsset).readAsBytesSync());
    await repo.importBundle(bundle.version, bundle.foods);
    await repo.loadSearchNames(rootBundle);
  });

  tearDownAll(() => db.close());

  test('German and Bosnian names find the built-in USDA foods', () async {
    Future<String> top(String query) async => (await repo.searchLocal(query)).first.name;
    expect(await top('Mehl'), 'Wheat flour, white, all-purpose, enriched, bleached');
    expect(await top('brašno'), 'Wheat flour, white, all-purpose, enriched, bleached');
    expect(await top('brasno'), 'Wheat flour, white, all-purpose, enriched, bleached', reason: 'without accents');
    expect(await top('kupus'), 'Cabbage, raw');
    expect(await top('Zwieb'), 'Onions, raw', reason: 'the start of a name is enough');
    expect(await top('onions raw'), 'Onions, raw', reason: 'English still works');
  });

  test('every name in the search files finds a food', () async {
    final files = Directory('assets/food').listSync().whereType<File>().where((f) => f.path.contains('search_'));
    expect(files, isNotEmpty);
    for (final file in files) {
      for (final entry in jsonDecode(file.readAsStringSync()) as List) {
        final search = entry['search'] as String;
        expect(await repo.searchLocal(search, limit: 1), isNotEmpty, reason: '${file.path}: "$search" finds nothing');
      }
    }
  });
}
