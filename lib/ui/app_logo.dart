import 'dart:math';

import 'package:flutter/material.dart';

import 'app_theme.dart';

const _cream = Color(0xFFFFF4EC);
const _paprika = Color(0xFFC2410C);
const _saffron = Color(0xFFE9A000);
const _basil = Color(0xFF2E7D32);
const _ink = Color(0xFF5C1F05);
const _wood = Color(0xFFE3B778);
const _woodDark = Color(0xFFC98F4A);
const _woodLight = Color(0xFFF3D7A6);

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32, this.background = false});

  final double size;
  final bool background;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: AppLogoPainter(background: background),
  );
}

/// The half wheel with a fork pointer resting on a rolling pin, drawn on a 100 × 100 grid.
class AppLogoPainter extends CustomPainter {
  const AppLogoPainter({this.background = true, this.scale = 1});

  static const cream = _cream;

  final bool background;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = min(size.width, size.height);
    if (background) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & Size.square(s), Radius.circular(s * 0.22)),
        Paint()..color = _cream,
      );
    }
    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.scale(scale * s / 100);
    canvas.translate(-50, -41.5);

    const center = Offset(50, 66);
    const radius = 34.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const colors = [_paprika, _saffron, _basil, _paprika];
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(rect, pi + i * pi / 4, pi / 4, true, Paint()..color = colors[i]);
    }
    final divider = Paint()
      ..color = _cream
      ..strokeWidth = 1.6;
    for (var i = 1; i < 4; i++) {
      final a = pi + i * pi / 4;
      canvas.drawLine(center, center + Offset(cos(a), sin(a)) * radius, divider);
    }
    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final tine = Paint()
      ..color = _ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final x in const [44.0, 48.0, 52.0, 56.0]) {
      canvas.drawLine(Offset(x, 6), Offset(x, 16), tine);
    }
    canvas.drawPath(
      Path()
        ..moveTo(42, 15)
        ..lineTo(58, 15)
        ..quadraticBezierTo(58, 22, 53.5, 24)
        ..lineTo(50, 33)
        ..lineTo(46.5, 24)
        ..quadraticBezierTo(42, 22, 42, 15)
        ..close(),
      Paint()..color = _ink,
    );

    final outline = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke;
    for (final x in const [4.0, 84.0]) {
      final handle = RRect.fromRectAndRadius(Rect.fromLTWH(x, 67.5, 12, 6), const Radius.circular(3));
      canvas.drawRRect(handle, Paint()..color = _woodDark);
      canvas.drawRRect(handle, outline..strokeWidth = 1.6);
    }
    final body = RRect.fromRectAndRadius(const Rect.fromLTWH(14, 64, 72, 13), const Radius.circular(6));
    canvas.drawRRect(body, Paint()..color = _wood);
    canvas.drawRRect(body, outline..strokeWidth = 2.2);
    canvas.drawLine(
      const Offset(22, 68),
      const Offset(78, 68),
      Paint()
        ..color = _woodLight
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(AppLogoPainter oldDelegate) => oldDelegate.background != background || oldDelegate.scale != scale;
}

/// "Manja" in the title font with the chef's hat sitting on the M.
class ManjaWordmark extends StatelessWidget {
  const ManjaWordmark({super.key, this.fontSize = 30, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final titleColor = color ?? Theme.of(context).appBarTheme.titleTextStyle?.color ?? _cream;
    final painter = _WordmarkPainter(fontSize: fontSize, color: titleColor);
    return Semantics(
      label: 'Manja',
      child: CustomPaint(size: painter.measure(), painter: painter),
    );
  }
}

class _WordmarkPainter extends CustomPainter {
  _WordmarkPainter({required this.fontSize, required this.color})
    : _text = TextPainter(
        text: TextSpan(
          text: 'Manja',
          style: TextStyle(fontFamily: appTitleFont, fontSize: fontSize, color: color, height: 1),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  // Designed in an SVG where "Manja" is 58 px Lobster starting at x 10 on baseline 100, and the hat fits above y 0.
  static const _designSize = 58.0;
  static const _left = 4.0;
  static const _above = 100.0;

  final double fontSize;
  final Color color;
  final TextPainter _text;

  double get _unit => fontSize / _designSize;

  double get _baseline => _text.computeDistanceToActualBaseline(TextBaseline.alphabetic);

  Size measure() => Size((_left + 2) * _unit + _text.width, _above * _unit + _text.height - _baseline);

  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = _above * _unit;
    _text.paint(canvas, Offset(_left * _unit, baselineY - _baseline));
    canvas.save();
    canvas.translate(_left * _unit, baselineY);
    canvas.scale(_unit);
    canvas.translate(-10 - 8.8, -100 + 24.26);
    canvas.scale(0.3412);
    canvas.translate(48, 6);
    canvas.translate(52, 80);
    canvas.rotate(-20 * pi / 180);
    canvas.translate(-52, -80);
    canvas.scale(1.15);
    paintChefHat(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WordmarkPainter oldDelegate) => oldDelegate.fontSize != fontSize || oldDelegate.color != color;
}

/// The chef's hat from the wordmark on its own 0–110 × 0–92 grid.
void paintChefHat(Canvas canvas) {
  final fill = Paint()..color = Colors.white;
  final line = Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;
  final puff = Path()
    ..moveTo(26, 74)
    ..cubicTo(6, 76, -2, 56, 10, 44)
    ..cubicTo(0, 26, 18, 6, 38, 14)
    ..cubicTo(44, -2, 70, -4, 78, 12)
    ..cubicTo(98, 6, 110, 30, 96, 46)
    ..cubicTo(106, 58, 94, 76, 72, 72)
    ..close();
  canvas.drawPath(puff, fill);
  canvas.drawPath(puff, line..strokeWidth = 3.4);
  canvas.drawPath(
    Path()
      ..moveTo(40, 70)
      ..cubicTo(39, 60, 34, 50, 27, 43)
      ..moveTo(58, 70)
      ..cubicTo(60, 60, 66, 50, 74, 44),
    line..strokeWidth = 2.2,
  );
  final band = Path()
    ..moveTo(24, 71)
    ..lineTo(72, 69)
    ..lineTo(71, 88)
    ..quadraticBezierTo(48, 92, 26, 89)
    ..close();
  canvas.drawPath(band, fill);
  canvas.drawPath(band, line..strokeWidth = 3.4);
}
