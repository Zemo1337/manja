import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/wheel_service.dart';

abstract class WheelTheme {
  const WheelTheme();

  factory WheelTheme.of(WheelThemeKind kind, ColorScheme scheme) => switch (kind) {
        WheelThemeKind.classic => ClassicWheelTheme(scheme.onSurface),
        WheelThemeKind.pizza => const PizzaWheelTheme(),
        WheelThemeKind.burek => const BurekWheelTheme(),
      };

  List<Color> get palette;
  double get rimFraction;
  Color get divider;
  Color get pointer;
  Color get overflow;

  Color labelColor(Color slice) => slice.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;

  Color sliceColor(int index, int count) {
    final last = count > 1 && index == count - 1 && index % palette.length == 0;
    return palette[last ? 1 : index % palette.length];
  }

  void paintRim(Canvas canvas, double outer, double inner);

  void paintHub(Canvas canvas, double outer);

  void paintSurface(Canvas canvas, double inner) {}

  static Path ring(double outer, double inner) => Path()
    ..fillType = PathFillType.evenOdd
    ..addOval(Rect.fromCircle(center: Offset.zero, radius: outer))
    ..addOval(Rect.fromCircle(center: Offset.zero, radius: inner));

  static Path spiral(double from, double to, double turns, {double phase = 0}) {
    final path = Path();
    final total = turns * 2 * pi;
    const step = 0.04;
    for (var t = 0.0; t <= total; t += step) {
      final r = from + (to - from) * t / total;
      final p = Offset(cos(t + phase), sin(t + phase)) * r;
      t == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path;
  }
}

class ClassicWheelTheme extends WheelTheme {
  const ClassicWheelTheme(this.ink);

  final Color ink;

  @override
  List<Color> get palette => const [
        Color(0xFFE4572E),
        Color(0xFFF3A712),
        Color(0xFF29335C),
        Color(0xFF669BBC),
        Color(0xFF7FB069),
        Color(0xFFA8325E),
      ];

  @override
  double get rimFraction => 0.035;

  @override
  Color get divider => Colors.white.withValues(alpha: 0.6);

  @override
  Color get pointer => ink;

  @override
  Color get overflow => const Color(0xFF4A3F3B);

  @override
  void paintRim(Canvas canvas, double outer, double inner) =>
      canvas.drawPath(WheelTheme.ring(outer, inner), Paint()..color = ink);

  @override
  void paintHub(Canvas canvas, double outer) {
    canvas.drawCircle(Offset.zero, outer * 0.12, Paint()..color = ink);
    canvas.drawCircle(Offset.zero, outer * 0.07, Paint()..color = Colors.white);
  }
}

class PizzaWheelTheme extends WheelTheme {
  const PizzaWheelTheme();

  static const _crustLight = Color(0xFFEDC27A);
  static const _crust = Color(0xFFD08B3E);
  static const _crustDark = Color(0xFF9C5A22);

  @override
  List<Color> get palette => const [
        Color(0xFFF4C450),
        Color(0xFFC8402A),
        Color(0xFFF7D57A),
        Color(0xFFD35A30),
        Color(0xFFEDB43E),
        Color(0xFFB5361F),
      ];

  @override
  double get rimFraction => 0.12;

  @override
  Color labelColor(Color slice) => slice.computeLuminance() > 0.3 ? const Color(0xFF3B1E0A) : Colors.white;

  @override
  Color get divider => const Color(0xB3FFF4DC);

  @override
  Color get pointer => const Color(0xFF4E2A12);

  @override
  Color get overflow => const Color(0xFF5B3A1E);

  @override
  void paintRim(Canvas canvas, double outer, double inner) {
    final ring = WheelTheme.ring(outer, inner);
    final edge = inner / outer;
    canvas.drawPath(
      ring,
      Paint()
        ..shader = RadialGradient(
          colors: const [_crustLight, _crust, _crustDark],
          stops: [edge, edge + (1 - edge) * 0.55, 1],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: outer)),
    );
    canvas.save();
    canvas.clipPath(ring);
    final random = Random(42);
    final width = outer - inner;
    final toast = Paint()..color = const Color(0x557A3E12);
    final bubble = Paint()..color = const Color(0x40FFF3D6);
    for (var i = 0; i < 70; i++) {
      final a = random.nextDouble() * 2 * pi;
      final r = inner + width * (0.2 + random.nextDouble() * 0.7);
      final size = width * (0.08 + random.nextDouble() * 0.16);
      canvas.save();
      canvas.translate(cos(a) * r, sin(a) * r);
      canvas.rotate(a);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size * 0.7, height: size * 1.6), i.isEven ? toast : bubble);
      canvas.restore();
    }
    canvas.restore();
    canvas.drawCircle(
      Offset.zero,
      inner,
      Paint()
        ..color = const Color(0x99A0391C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  void paintHub(Canvas canvas, double outer) {
    canvas.drawCircle(Offset.zero, outer * 0.11, Paint()..color = const Color(0xFF26231F));
    canvas.drawCircle(Offset.zero, outer * 0.045, Paint()..color = const Color(0xFF8A3B22));
    canvas.drawCircle(Offset(-outer * 0.045, -outer * 0.05), outer * 0.018, Paint()..color = const Color(0x66FFFFFF));
  }
}

class BurekWheelTheme extends WheelTheme {
  const BurekWheelTheme();

  static const _ink = Color(0xFF6B3A12);

  @override
  List<Color> get palette => const [
        Color(0xFFF3C46A),
        Color(0xFFE2A84C),
        Color(0xFFF7D893),
        Color(0xFFD99A3C),
        Color(0xFFEDB75A),
        Color(0xFFE8BE74),
      ];

  @override
  double get rimFraction => 0.12;

  @override
  Color labelColor(Color slice) => slice == overflow ? Colors.white : const Color(0xFF3B2108);

  @override
  Color get divider => const Color(0x80FFF3D0);

  @override
  Color get pointer => const Color(0xFF5A3010);

  @override
  Color get overflow => const Color(0xFF7A4A1C);

  @override
  void paintRim(Canvas canvas, double outer, double inner) {
    final ring = WheelTheme.ring(outer, inner);
    canvas.drawPath(
      ring,
      Paint()
        ..shader = const RadialGradient(colors: [Color(0xFFEDB75A), Color(0xFFB9772C)])
            .createShader(Rect.fromCircle(center: Offset.zero, radius: outer)),
    );
    canvas.save();
    canvas.clipPath(ring);
    final coil = WheelTheme.spiral(inner, outer, 3);
    canvas.drawPath(
      coil,
      Paint()
        ..color = const Color(0xB36B3A12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawPath(
      WheelTheme.spiral(inner + 2.5, outer + 2.5, 3),
      Paint()
        ..color = const Color(0x80FFF0C8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.restore();
  }

  @override
  void paintSurface(Canvas canvas, double inner) {
    canvas.drawPath(
      WheelTheme.spiral(inner * 0.14, inner, 4, phase: pi / 3),
      Paint()
        ..color = const Color(0x245A3410)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void paintHub(Canvas canvas, double outer) {
    final r = outer * 0.12;
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = const RadialGradient(colors: [Color(0xFFF2C46D), Color(0xFFC98A34)])
            .createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.drawPath(
      WheelTheme.spiral(0, r * 0.9, 2.2),
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }
}
