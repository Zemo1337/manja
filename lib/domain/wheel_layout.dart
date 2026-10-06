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

List<double> sliceSweeps(int count, {int? winner, double winnerFraction = 1, double progress = 0}) {
  final base = fullTurn / count;
  if (winner == null || count == 1) return List.filled(count, base);
  final target = max(base, winnerFraction.clamp(0.0, 1.0) * fullTurn);
  final grown = base + (target - base) * progress.clamp(0.0, 1.0);
  final other = (fullTurn - grown) / (count - 1);
  return [for (var i = 0; i < count; i++) i == winner ? grown : other];
}

double centeredRotation(List<double> sweeps, int index) => -(_offsetBefore(sweeps, index) + sweeps[index] / 2);

double shortestAngle(double from, double to) {
  final d = (to - from) % fullTurn;
  return d > pi ? d - fullTurn : d;
}

double winnerRotation({
  required double landing,
  required int count,
  required int winner,
  required double winnerFraction,
  required double progress,
}) {
  final start = centeredRotation(sliceSweeps(count), winner);
  final now = centeredRotation(
    sliceSweeps(count, winner: winner, winnerFraction: winnerFraction, progress: progress),
    winner,
  );
  return now + shortestAngle(start, landing) * (1 - progress);
}

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

bool shouldFlipWideLabel(double screenAngle) => sin(screenAngle) > 0;
