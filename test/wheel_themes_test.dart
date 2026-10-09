import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manja/domain/wheel_service.dart';
import 'package:manja/ui/wheel/wheel_themes.dart';

double _contrast(Color a, Color b) {
  final (la, lb) = (a.computeLuminance(), b.computeLuminance());
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

void main() {
  test('names are readable on every slice of the food wheel themes', () {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFFC2410C));
    for (final kind in [WheelThemeKind.burek, WheelThemeKind.sacher, WheelThemeKind.baklava]) {
      final theme = WheelTheme.of(kind, scheme);
      for (final slice in [...theme.palette, theme.overflow]) {
        expect(
          _contrast(theme.labelColor(slice), slice),
          greaterThanOrEqualTo(4.5),
          reason: '${kind.name} on ${slice.toARGB32().toRadixString(16)}',
        );
      }
    }
  });
}
