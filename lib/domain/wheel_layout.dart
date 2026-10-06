import 'dart:math';

import '../data/database.dart';

const fullTurn = 2 * pi;

class WheelEntry {
  const WheelEntry.recipe(Recipe this.recipe) : hidden = const [];
  const WheelEntry.overflow(this.hidden) : recipe = null;

  final Recipe? recipe;
  final List<Recipe> hidden;

  bool get isOverflow => recipe == null;

  bool represents(Recipe r) => isOverflow ? hidden.any((h) => h.id == r.id) : recipe!.id == r.id;
}

List<WheelEntry> buildEntries(List<Recipe> available, int maxSlices, Random random) {
  if (available.length <= maxSlices) return [for (final r in available) WheelEntry.recipe(r)];
  final shuffled = [...available]..shuffle(random);
  final shown = shuffled.take(maxSlices - 1).toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return [for (final r in shown) WheelEntry.recipe(r), WheelEntry.overflow(shuffled.skip(maxSlices - 1).toList())];
}

int entryIndexFor(List<WheelEntry> entries, Recipe recipe) => entries.indexWhere((e) => e.represents(recipe));

List<double> sliceSweeps(int count) => List.filled(count, fullTurn / count);

double _offsetBefore(List<double> sweeps, int index) {
  var sum = 0.0;
  for (var i = 0; i < index; i++) {
    sum += sweeps[i];
  }
  return sum;
}

double targetRotation({
  required double current,
  required List<double> sweeps,
  required int index,
  required int fullSpins,
  double jitter = 0,
}) {
  final desired = -(_offsetBefore(sweeps, index) + sweeps[index] * (0.5 + jitter));
  final delta = (desired - current) % fullTurn;
  return current + fullSpins * fullTurn + delta;
}

int sliceAtPointer(double rotation, List<double> sweeps) {
  final local = (-rotation) % fullTurn;
  var end = 0.0;
  for (var i = 0; i < sweeps.length; i++) {
    end += sweeps[i];
    if (local < end) return i;
  }
  return sweeps.length - 1;
}

double labelFontSize({required double sweep, required double radius}) {
  final chord = 2 * radius * 0.6 * sin(min(sweep / 2, pi / 2));
  final largest = (radius * 0.1).clamp(12.0, 22.0);
  return (chord * 0.5).clamp(9.0, largest);
}

bool shouldFlipLabel(double screenAngle) => cos(screenAngle) < 0;
