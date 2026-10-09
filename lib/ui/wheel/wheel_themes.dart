import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/wheel_service.dart';

abstract class WheelTheme {
  const WheelTheme();

  factory WheelTheme.of(WheelThemeKind kind, ColorScheme scheme) => switch (kind) {
    WheelThemeKind.classic => ClassicWheelTheme(scheme.onSurface),
    WheelThemeKind.pizza => const PizzaWheelTheme(),
    WheelThemeKind.burek => const BurekWheelTheme(),
    WheelThemeKind.sacher => const SacherWheelTheme(),
    WheelThemeKind.baklava => const BaklavaWheelTheme(),
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
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: size * 0.7, height: size * 1.6),
        i.isEven ? toast : bubble,
      );
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

class SacherWheelTheme extends WheelTheme {
  const SacherWheelTheme();

  static const _glaze = Color(0xFF2E160C);
  static const _apricot = Color(0xFFE59A3A);

  @override
  List<Color> get palette => const [
    Color(0xFF4A2616),
    Color(0xFF3A1D10),
    Color(0xFF55301C),
    Color(0xFF41210F),
    Color(0xFF5C3520),
    Color(0xFF361A0E),
  ];

  @override
  double get rimFraction => 0.09;

  @override
  Color labelColor(Color slice) => slice == overflow ? const Color(0xFF2E160C) : const Color(0xFFF6E7D2);

  @override
  Color get divider => const Color(0xD9E59A3A);

  @override
  Color get pointer => _apricot;

  @override
  Color get overflow => const Color(0xFFF3E3C6);

  @override
  void paintSurface(Canvas canvas, double inner) {
    canvas.drawCircle(
      Offset.zero,
      inner,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0x00FFFFFF), Color(0x00FFFFFF), Color(0x1FFFFFFF), Color(0x00FFFFFF)],
          stops: [0, 0.55, 0.72, 0.9],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: inner)),
    );
  }

  @override
  void paintRim(Canvas canvas, double outer, double inner) {
    final edge = inner / outer;
    canvas.drawPath(
      WheelTheme.ring(outer, inner),
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF1E0D06), Color(0xFF4B2715), _glaze, Color(0xFF140803)],
          stops: [edge, edge + (1 - edge) * 0.35, edge + (1 - edge) * 0.7, 1],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: outer)),
    );
    canvas.drawCircle(
      Offset.zero,
      inner + (outer - inner) * 0.35,
      Paint()
        ..color = const Color(0x33FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.drawCircle(
      Offset.zero,
      inner,
      Paint()
        ..color = const Color(0xCC1A0A04)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  void paintHub(Canvas canvas, double outer) {
    final r = outer * 0.12;
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = const RadialGradient(colors: [Color(0xFF5A3420), Color(0xFF2A130A)])
            .createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    final emboss = Paint()
      ..color = const Color(0x66E8C9A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset.zero, r * 0.78, emboss);
    canvas.drawCircle(Offset.zero, r * 0.5, emboss);
    canvas.drawCircle(Offset(-r * 0.35, -r * 0.4), r * 0.16, Paint()..color = const Color(0x40FFFFFF));
  }
}

class BaklavaWheelTheme extends WheelTheme {
  const BaklavaWheelTheme();

  static const _pistachio = Color(0xFF7DA43A);
  static const _pistachioDark = Color(0xFF4F7420);

  @override
  List<Color> get palette => const [
    Color(0xFFE8B254),
    Color(0xFFD69A3A),
    Color(0xFFF0C46E),
    Color(0xFFDDA544),
    Color(0xFFE9BB62),
    Color(0xFFCF9234),
  ];

  @override
  double get rimFraction => 0.08;

  @override
  Color labelColor(Color slice) => slice == overflow ? Colors.white : const Color(0xFF3E2408);

  @override
  Color get divider => const Color(0xB37A4A12);

  @override
  Color get pointer => const Color(0xFF7A5418);

  @override
  Color get overflow => _pistachioDark;

  @override
  void paintSurface(Canvas canvas, double inner) {
    final flakes = Paint()
      ..color = const Color(0x2E7A4A12)
      ..strokeWidth = 0.8;
    for (var i = 0; i < 180; i++) {
      final a = i * 2 * pi / 180;
      final dir = Offset(cos(a), sin(a));
      canvas.drawLine(dir * inner * 0.13, dir * inner * 0.92, flakes);
    }
    final band = WheelTheme.ring(inner, inner * 0.92);
    canvas.drawPath(band, Paint()..color = _pistachio);
    canvas.save();
    canvas.clipPath(band);
    final random = Random(7);
    final crumbs = [const Color(0xFF9CC453), _pistachioDark, const Color(0xFFB9D872), const Color(0xFF5E3B1E)];
    for (var i = 0; i < 200; i++) {
      final a = random.nextDouble() * 2 * pi;
      final r = inner * (0.92 + random.nextDouble() * 0.08);
      canvas.drawCircle(
        Offset(cos(a), sin(a)) * r,
        inner * (0.006 + random.nextDouble() * 0.01),
        Paint()..color = crumbs[i % crumbs.length],
      );
    }
    canvas.restore();
  }

  @override
  void paintRim(Canvas canvas, double outer, double inner) {
    final edge = inner / outer;
    canvas.drawPath(
      WheelTheme.ring(outer, inner),
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF8A5A22), Color(0xFFE2B66A), Color(0xFFB27A34), Color(0xFF6E4518)],
          stops: [edge, edge + (1 - edge) * 0.4, edge + (1 - edge) * 0.7, 1],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: outer)),
    );
    canvas.drawCircle(
      Offset.zero,
      inner,
      Paint()
        ..color = const Color(0xFF5A3810)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  void paintHub(Canvas canvas, double outer) {
    final r = outer * 0.11;
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = const RadialGradient(colors: [Color(0xFFF2CB7C), Color(0xFFC88A30)])
            .createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    final random = Random(3);
    for (var i = 0; i < 40; i++) {
      final a = random.nextDouble() * 2 * pi;
      final d = r * 0.6 * sqrt(random.nextDouble());
      canvas.drawCircle(
        Offset(cos(a), sin(a)) * d,
        r * (0.06 + random.nextDouble() * 0.06),
        Paint()..color = i.isEven ? _pistachio : const Color(0xFFA9CC62),
      );
    }
  }
}
