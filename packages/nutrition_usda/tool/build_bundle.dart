import 'dart:convert';
import 'dart:io';

import 'package:nutrition_usda/nutrition_usda.dart';

void main(List<String> args) {
  if (args.length < 3) {
    stderr.writeln('Usage: dart run tool/build_bundle.dart <version> <output.json.gz> <usda bulk json>...');
    exit(64);
  }
  final [version, output, ...inputs] = args;
  final foods = [
    for (final path in inputs) ...parseUsdaBulk(jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>),
  ]..sort((a, b) => a.name.compareTo(b.name));
  final bytes = gzip.encode(utf8.encode(jsonEncode(encodeUsdaBundle(foods, version: version))));
  File(output).writeAsBytesSync(bytes);
  final withPortions = foods.where((f) => f.portions.isNotEmpty).length;
  stdout.writeln('${foods.length} foods ($withPortions with portions), ${(bytes.length / 1024).round()} KB -> $output');
}
