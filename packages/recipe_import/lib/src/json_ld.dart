import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:nutrition_core/nutrition_core.dart';

import 'imported_recipe.dart';

final _duration = RegExp(r'^P(?:(\d+(?:\.\d+)?)D)?(?:T(?:(\d+(?:\.\d+)?)H)?(?:(\d+(?:\.\d+)?)M)?(?:(\d+(?:\.\d+)?)S)?)?$');
final _firstNumber = RegExp(r'\d+');

ImportedRecipe? recipeFromJsonLd(Iterable<String> blocks, {Uri? pageUrl}) {
  for (final block in blocks) {
    final Object? json;
    try {
      json = jsonDecode(block);
    } on FormatException {
      continue;
    }
    final recipe = _findRecipe(json);
    if (recipe != null) return recipeFromSchema(recipe, pageUrl: pageUrl);
  }
  return null;
}

List<String> jsonLdBlocksFromHtml(String page) => [
      for (final script in html.parse(page).querySelectorAll('script[type="application/ld+json"]')) script.text,
    ];

ImportedRecipe? recipeFromSchema(Map<String, dynamic> recipe, {Uri? pageUrl}) {
  final name = cleanText(recipe['name']);
  if (name == null || name.isEmpty) return null;
  final image = _imageUrl(recipe['image']);
  return ImportedRecipe(
    name: name,
    description: cleanText(recipe['description']),
    imageUrl: image == null ? null : (pageUrl?.resolve(image) ?? Uri.tryParse(image)),
    portions: parsePortions(recipe['recipeYield']),
    prepMinutes: parseDurationMinutes(recipe['prepTime']),
    cookMinutes: parseDurationMinutes(recipe['cookTime']),
    totalMinutes: parseDurationMinutes(recipe['totalTime']),
    ingredients: [
      for (final line in _strings(recipe['recipeIngredient'] ?? recipe['ingredients']))
        if (cleanText(line) case final text? when text.isNotEmpty) parseIngredientLine(text),
    ],
    steps: _steps(recipe['recipeInstructions']),
    sourceUrl: pageUrl ?? Uri.tryParse(recipe['url'] as String? ?? ''),
    categories: [
      for (final c in _strings(recipe['recipeCategory']))
        if (cleanText(c) case final text? when text.isNotEmpty) text,
    ],
  );
}

Map<String, dynamic>? _findRecipe(Object? node) {
  if (node is List) {
    for (final item in node) {
      final found = _findRecipe(item);
      if (found != null) return found;
    }
  } else if (node is Map<String, dynamic>) {
    final type = node['@type'];
    if (type == 'Recipe' || (type is List && type.contains('Recipe'))) return node;
    for (final key in const ['@graph', 'mainEntity', 'mainEntityOfPage', 'itemListElement', 'item']) {
      final found = _findRecipe(node[key]);
      if (found != null) return found;
    }
  }
  return null;
}

String? cleanText(Object? value) {
  if (value is! String) return null;
  final text = html.parseFragment(value).text ?? value;
  return text.replaceAll(' ', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
}

Iterable<String> _strings(Object? value) sync* {
  if (value is String) {
    yield value;
  } else if (value is List) {
    for (final v in value) {
      yield* _strings(v);
    }
  }
}

String? _imageUrl(Object? value) => switch (value) {
      final String url => url,
      final List<dynamic> list when list.isNotEmpty => _imageUrl(list.first),
      {'url': final String url} => url,
      {'contentUrl': final String url} => url,
      _ => null,
    };

int? parsePortions(Object? value) {
  final text = switch (value) {
    final num n => '$n',
    final String s => s,
    final List<dynamic> list => list.whereType<Object>().map((e) => '$e').firstWhere(
          (s) => _firstNumber.hasMatch(s),
          orElse: () => '',
        ),
    _ => '',
  };
  final match = _firstNumber.firstMatch(text);
  final n = match == null ? null : int.tryParse(match.group(0)!);
  return n == null || n < 1 ? null : n;
}

int? parseDurationMinutes(Object? value) {
  if (value is num) return value.round();
  if (value is! String || value.isEmpty) return null;
  final m = _duration.firstMatch(value.trim().toUpperCase());
  if (m == null || m.group(0) == 'P' || m.group(0) == 'PT') return null;
  double part(int i) => double.tryParse(m.group(i) ?? '') ?? 0;
  final minutes = part(1) * 1440 + part(2) * 60 + part(3) + part(4) / 60;
  return minutes <= 0 ? null : minutes.round();
}

List<String> _steps(Object? value) {
  final steps = <String>[];
  void add(Object? node) {
    switch (node) {
      case final String text:
        for (final line in text.split(RegExp(r'\n+|<br\s*/?>', caseSensitive: false))) {
          if (cleanText(line) case final step? when step.isNotEmpty) steps.add(step);
        }
      case final List<dynamic> list:
        list.forEach(add);
      case {'itemListElement': final Object items}:
        add(items);
      case {'text': final String text}:
        add(text);
      case {'name': final String name}:
        add(name);
    }
  }

  add(value);
  return steps;
}
