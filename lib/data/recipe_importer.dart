import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:recipe_import/recipe_import.dart';

import '../domain/units.dart';
import '../l10n/app_localizations.dart';

enum RecipeImportError { timeout, unreachable, blocked, httpStatus, noRecipe }

class RecipeImportException implements Exception {
  const RecipeImportException(this.error, {this.statusCode});

  final RecipeImportError error;
  final int? statusCode;

  String messageIn(AppLocalizations l) => switch (error) {
    RecipeImportError.timeout => l.recipeImportTimeout,
    RecipeImportError.unreachable => l.recipeImportUnreachable,
    RecipeImportError.blocked => l.recipeImportBlocked,
    RecipeImportError.httpStatus => l.recipeImportHttpError(statusCode ?? 0),
    RecipeImportError.noRecipe => l.recipeImportNoRecipe,
  };

  String get message => messageIn(lookupAppLocalizations(const Locale('en')));

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
      throw const RecipeImportException(RecipeImportError.timeout);
    } on http.ClientException {
      throw const RecipeImportException(RecipeImportError.unreachable);
    }
    if (response.statusCode == 403 || response.statusCode == 503) {
      throw const RecipeImportException(RecipeImportError.blocked);
    }
    if (response.statusCode != 200) {
      throw RecipeImportException(RecipeImportError.httpStatus, statusCode: response.statusCode);
    }
    final type = response.headers['content-type'] ?? '';
    final page = type.contains('charset=') ? response.body : utf8.decode(response.bodyBytes, allowMalformed: true);
    return fromBlocks(jsonLdBlocksFromHtml(page), url).withImage(previewImageFromHtml(page, pageUrl: url));
  }

  ImportedRecipe fromBlocks(List<String> blocks, Uri url) {
    final recipe = recipeFromJsonLd(blocks, pageUrl: url);
    if (recipe == null) {
      throw const RecipeImportException(RecipeImportError.noRecipe);
    }
    return recipe;
  }

  Future<String?> downloadImage(Uri url, Directory dir) async {
    try {
      final response = await _client
          .get(
            url,
            headers: {'User-Agent': browserUserAgent, 'Accept': 'image/webp,image/jpeg,image/png,image/*;q=0.8'},
          )
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
