import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:recipe_import/recipe_import.dart';

import '../domain/units.dart';

class RecipeImportException implements Exception {
  const RecipeImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

const browserUserAgent =
    'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0 Mobile Safari/537.36';

class RecipeImporter {
  RecipeImporter({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ImportedRecipe> fromUrl(Uri url) async {
    final http.Response response;
    try {
      response = await _client
          .get(url, headers: {'User-Agent': browserUserAgent, 'Accept': 'text/html'})
          .timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw const RecipeImportException('The page did not load in time.');
    } on http.ClientException {
      throw const RecipeImportException('The page could not be reached. Check your internet connection.');
    }
    if (response.statusCode == 403 || response.statusCode == 503) {
      throw const RecipeImportException(
        'This site blocks automatic downloads. Import it on your phone, where the page opens in a browser view.',
      );
    }
    if (response.statusCode != 200) throw RecipeImportException('The page answered with HTTP ${response.statusCode}.');
    final type = response.headers['content-type'] ?? '';
    final page = type.contains('charset=') ? response.body : utf8.decode(response.bodyBytes, allowMalformed: true);
    return fromBlocks(jsonLdBlocksFromHtml(page), url);
  }

  ImportedRecipe fromBlocks(List<String> blocks, Uri url) {
    final recipe = recipeFromJsonLd(blocks, pageUrl: url);
    if (recipe == null) {
      throw const RecipeImportException(
        'No recipe data found on this page. The site may not publish its recipes in a readable format.',
      );
    }
    return recipe;
  }

  Future<String?> downloadImage(Uri url, Directory dir) async {
    try {
      final response = await _client
          .get(url, headers: {'User-Agent': browserUserAgent})
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) return null;
      final type = response.headers['content-type'] ?? '';
      final ext = type.contains('png')
          ? '.png'
          : type.contains('webp')
          ? '.webp'
          : '.jpg';
      final file = File(p.join(dir.path, 'import_${DateTime.now().microsecondsSinceEpoch}$ext'));
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}

class RecipeTemplate {
  const RecipeTemplate({
    required this.name,
    this.portions,
    this.prepMinutes,
    this.cookMinutes,
    this.cookingInfo = '',
    this.ingredients = const [],
    this.steps = const [],
    this.photoPath,
    this.sourceUrl,
    this.categories = const [],
  });

  factory RecipeTemplate.fromImported(ImportedRecipe r, {String? photoPath}) => RecipeTemplate(
    name: r.name,
    portions: r.portions,
    prepMinutes: r.prepMinutes,
    cookMinutes: r.cookMinutes ?? (r.prepMinutes == null ? r.totalMinutes : null),
    cookingInfo: r.description ?? '',
    ingredients: [
      for (final i in r.ingredients)
        (name: i.note == null ? i.name : '${i.name} (${i.note})', amount: i.amount, unit: i.unit ?? CookingUnit.piece),
    ],
    steps: r.steps,
    photoPath: photoPath,
    sourceUrl: r.sourceUrl?.toString(),
    categories: r.categories,
  );

  final String name;
  final int? portions;
  final int? prepMinutes;
  final int? cookMinutes;
  final String cookingInfo;
  final List<({String name, double? amount, CookingUnit unit})> ingredients;
  final List<String> steps;
  final String? photoPath;
  final String? sourceUrl;
  final List<String> categories;
}
