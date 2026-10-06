import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:manja_manja/data/database.dart';
import 'package:manja_manja/domain/wheel_layout.dart';

Recipe _recipe(int id) => Recipe(
      id: id,
      name: 'Dish $id',
      portions: 2,
      cookingInfo: '',
      isFavorite: false,
      createdAt: DateTime(2026),
    );

void main() {
  group('entries', () {
    final recipes = [for (var i = 1; i <= 30; i++) _recipe(i)];

    test('all recipes get a slice when they fit', () {
      final entries = buildEntries(recipes.take(20).toList(), 20, Random(1));
      expect(entries, hasLength(20));
      expect(entries.any((e) => e.isOverflow), isFalse);
    });

    test('overflow slice holds the rest and every recipe is represented once', () {
      final entries = buildEntries(recipes, 20, Random(1));
      expect(entries, hasLength(20));
      expect(entries.last.isOverflow, isTrue);
      expect(entries.last.hidden, hasLength(11));
      for (final r in recipes) {
        expect(entries.where((e) => e.represents(r)), hasLength(1), reason: r.name);
        expect(entryIndexFor(entries, r), greaterThanOrEqualTo(0));
      }
      final visible = [for (final e in entries.take(19)) e.recipe!.name.toLowerCase()];
      expect(visible, [...visible]..sort());
    });

    test('a hidden recipe resolves to the overflow slice', () {
      final entries = buildEntries(recipes, 5, Random(2));
      final hidden = entries.last.hidden.first;
      expect(entryIndexFor(entries, hidden), 4);
    });
  });


  test('equal sweeps fill the whole wheel', () {
    for (var count = 1; count <= 50; count++) {
      expect(sliceSweeps(count).reduce((a, b) => a + b), closeTo(fullTurn, 1e-9));
    }
  });

  test('target rotation lands the pointer on the chosen slice', () {
    final random = Random(1);
    for (var count = 1; count <= 30; count++) {
      final sweeps = sliceSweeps(count);
      var rotation = 0.0;
      for (var round = 0; round < 50; round++) {
        final index = random.nextInt(count);
        final jitter = (random.nextDouble() - 0.5) * 0.7;
        rotation = targetRotation(current: rotation, sweeps: sweeps, index: index, fullSpins: 5, jitter: jitter);
        expect(sliceAtPointer(rotation, sweeps), index, reason: 'count=$count round=$round');
        rotation %= fullTurn;
      }
    }
  });

  test('target rotation always spins forward by at least the full spins', () {
    final end = targetRotation(current: 1.0, sweeps: sliceSweeps(4), index: 0, fullSpins: 5);
    expect(end - 1.0, greaterThanOrEqualTo(5 * fullTurn));
    expect(end - 1.0, lessThan(6 * fullTurn));
  });

  test('label font shrinks with more slices but stays readable', () {
    const radius = 170.0;
    final sizes = [for (final n in [2, 6, 12, 20, 50]) labelFontSize(sweep: fullTurn / n, radius: radius)];
    for (var i = 1; i < sizes.length; i++) {
      expect(sizes[i], lessThanOrEqualTo(sizes[i - 1]));
    }
    expect(sizes.first, 17.0);
    expect(sizes.last, greaterThanOrEqualTo(9.0));
  });

  test('labels on the left half are flipped', () {
    expect(shouldFlipLabel(0), isFalse);
    expect(shouldFlipLabel(-pi / 2 + 0.1), isFalse);
    expect(shouldFlipLabel(pi), isTrue);
    expect(shouldFlipLabel(pi / 2 + 0.1), isTrue);
    expect(shouldFlipLabel(-pi + 0.1), isTrue);
  });
}
