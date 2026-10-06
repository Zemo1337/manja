import 'dart:math';

const fullTurn = 2 * pi;

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
