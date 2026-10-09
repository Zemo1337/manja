import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:manja/data/database.dart';
import 'package:manja/domain/wheel_layout.dart';

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

  group('winner takeover', () {
    test('sweeps always fill the wheel and the winner grows to its share', () {
      for (final count in [2, 5, 20]) {
        for (final fraction in [0.3, 0.6, 1.0]) {
          for (final progress in [0.0, 0.25, 0.5, 1.0]) {
            final sweeps = sliceSweeps(count, winner: 1, winnerFraction: fraction, progress: progress);
            expect(sweeps.reduce((a, b) => a + b), closeTo(fullTurn, 1e-9));
          }
          final done = sliceSweeps(count, winner: 1, winnerFraction: fraction, progress: 1);
          expect(done[1], closeTo(max(fullTurn / count, fraction * fullTurn), 1e-9));
        }
      }
      expect(sliceSweeps(6, winner: 2, progress: 0), [for (final s in sliceSweeps(6)) closeTo(s, 1e-9)]);
      expect(sliceSweeps(6, winner: 2, winnerFraction: 1, progress: 1)[0], closeTo(0, 1e-9));
    });

    test('a small winner share never shrinks the winning slice', () {
      final sweeps = sliceSweeps(2, winner: 0, winnerFraction: 0.3, progress: 1);
      expect(sweeps[0], closeTo(pi, 1e-9));
    });

    test('the pointer stays on the winner while it grows and ends centred', () {
      final random = Random(3);
      for (var round = 0; round < 200; round++) {
        final count = 2 + random.nextInt(30);
        final winner = random.nextInt(count);
        final fraction = 0.3 + random.nextDouble() * 0.7;
        final landing = targetRotation(
          current: random.nextDouble() * fullTurn,
          sweeps: sliceSweeps(count),
          index: winner,
          fullSpins: 0,
          jitter: (random.nextDouble() - 0.5) * 0.7,
        );
        for (final progress in [0.0, 0.1, 0.5, 0.9, 1.0]) {
          final sweeps = sliceSweeps(count, winner: winner, winnerFraction: fraction, progress: progress);
          final rotation = winnerRotation(
            landing: landing,
            count: count,
            winner: winner,
            winnerFraction: fraction,
            progress: progress,
          );
          expect(sliceAtPointer(rotation, sweeps), winner, reason: 'round $round progress $progress');
          if (progress == 0) expect(shortestAngle(landing, rotation), closeTo(0, 1e-9));
          if (progress == 1) expect(shortestAngle(centeredRotation(sweeps, winner), rotation), closeTo(0, 1e-9));
        }
      }
    });
  });

  test('shortest angle picks the short way round', () {
    expect(shortestAngle(0, 0.5), closeTo(0.5, 1e-12));
    expect(shortestAngle(0.5, 0), closeTo(-0.5, 1e-12));
    expect(shortestAngle(0.1, fullTurn - 0.1), closeTo(-0.2, 1e-12));
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

  test('wide labels on the lower half are flipped', () {
    expect(shouldFlipWideLabel(-pi / 2), isFalse);
    expect(shouldFlipWideLabel(-0.1), isFalse);
    expect(shouldFlipWideLabel(pi / 2), isTrue);
    expect(shouldFlipWideLabel(0.1), isTrue);
  });
}
